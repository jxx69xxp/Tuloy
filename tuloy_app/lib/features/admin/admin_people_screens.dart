import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/adaptive.dart';
import '../../core/config.dart';
import '../../core/format.dart';
import '../../core/http.dart';
import '../../core/ui.dart';
import '../../core/web/overlays.dart';
import '../../l10n/app_localizations.dart';
import '../staff/staff_screens.dart' show leaveStatus, leaveTypeLabel;
import 'admin_catalog_screens.dart' show trOf;

// ───────────── A14/A15 staff, departments, leave ─────────────

class StaffAdminScreen extends ConsumerWidget {
  const StaffAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.staffAndLeave),
          bottom: TabBar(
            tabs: [
              Tab(text: l.staff),
              Tab(text: l.leaveRequests),
              Tab(text: l.departments),
            ],
          ),
        ),
        body: const TabBarView(children: [_StaffTab(), _LeaveTab(), _DepartmentsTab()]),
      ),
    );
  }
}

class _StaffTab extends ConsumerWidget {
  const _StaffTab();

  Future<void> _edit(BuildContext context, WidgetRef ref, [J? member]) async {
    final saved = await Navigator.of(context).push<bool>(editorRoute(context, _StaffEdit(member: member)));
    if (saved == true) ref.invalidate(getProvider('/admin/staff'));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final wide = isWide(context);
    List<String> cells(J s) => [
      '${s['employeeNo'] ?? ''}',
      '${s['fullName']}',
      '${s['email']}',
      '${s['role']}',
      '${s['department']?['name'] ?? ''}',
    ];
    return Scaffold(
      // Wide: the tab has no app bar of its own, so Add sits in the table toolbar.
      floatingActionButton: wide
          ? null
          : FloatingActionButton(
              tooltip: l.add,
              onPressed: () => _edit(context, ref),
              child: const Icon(Icons.person_add),
            ),
      body: JsonList(
        path: '/admin/staff',
        table: JsonTable(
          leading: (context, s) => StaffAvatar(name: '${s['fullName']}', url: s['photoUrl'] as String?),
          columns: [l.employeeId, l.fullName, l.email, l.role, l.department],
          cells: (context, s) => cells(s),
          onTap: (s) => _edit(context, ref, s),
          sortKeys: [for (var i = 0; i < 5; i++) (s) => cells(s)[i].toLowerCase()],
          toolbar: [
            FilledButton.icon(
              onPressed: () => _edit(context, ref),
              icon: const Icon(Icons.person_add),
              label: Text(l.add),
            ),
          ],
        ),
        item: (context, s) => ListTile(
          leading: StaffAvatar(name: '${s['fullName']}', url: s['photoUrl'] as String?),
          title: Text('${s['fullName']}'),
          subtitle: Text(
            '${s['employeeNo'] != null ? '${s['employeeNo']} · ' : ''}${s['email']} · ${s['role']}${s['department'] != null ? ' · ${s['department']['name']}' : ''}',
          ),
          onTap: () => _edit(context, ref, s),
        ),
      ),
    );
  }
}

class _StaffEdit extends ConsumerStatefulWidget {
  const _StaffEdit({this.member});
  final J? member;
  @override
  ConsumerState<_StaffEdit> createState() => _StaffEditState();
}

class _StaffEditState extends ConsumerState<_StaffEdit> {
  final _email = TextEditingController();
  final _name = TextEditingController();
  final _password = TextEditingController();
  late final _employeeNo = TextEditingController(text: '${widget.member?['employeeNo'] ?? ''}');
  late String? _photoKey = widget.member?['photoKey'] as String?;
  late String _role = '${widget.member?['role'] ?? 'STAFF'}';
  late String? _department = (widget.member?['department'] as Map?)?['id'] as String?;
  late final Set<String> _perms = {...((widget.member?['permissions'] as List?) ?? const []).cast<String>()};

  @override
  void dispose() {
    _email.dispose();
    _name.dispose();
    _password.dispose();
    _employeeNo.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final f = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 800, imageQuality: 85);
    if (f == null || !mounted) return;
    final ext = f.name.toLowerCase().endsWith('.png') ? 'png' : 'jpg';
    final bytes = await f.readAsBytes();
    if (!mounted) return;
    await act(context, () async {
      final key = await ref.read(apiProvider).upload('staff', bytes, ext);
      setState(() => _photoKey = key);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final m = widget.member;
    final api = ref.read(apiProvider);
    final departments = jsonList(ref.watch(getProvider('/admin/departments')).valueOrNull ?? const []);
    final perms = ((ref.watch(getProvider('/admin/permissions')).valueOrNull as List?) ?? const []).cast<String>();
    final wide = isWide(context);
    Future<void> save() async {
      final body = {
        'role': _role,
        if (_department != null) 'departmentId': _department,
        'permissions': _perms.toList(),
        'employeeNo': _employeeNo.text.trim(),
        if (_photoKey != null) 'photoKey': _photoKey,
      };
      final ok = await act(
        context,
        () => m == null
            ? api.post('/admin/staff', {
                ...body,
                'email': _email.text.trim(),
                'fullName': _name.text.trim(),
                'password': _password.text,
              })
            : api.patch('/admin/staff/${m['userId']}', body),
        done: l.saved,
      );
      if (ok && context.mounted) Navigator.pop(context, true);
    }

    return Scaffold(
      bottomNavigationBar: wide
          ? EditorFooter(
              save: BusyButton(label: l.save, onPressed: save),
            )
          : null,
      appBar: AppBar(
        title: Text(m == null ? l.addStaff : '${m['fullName']}'),
        actions: [
          if (m != null)
            IconButton(
              tooltip: l.removeAccess,
              icon: const Icon(Icons.person_remove),
              onPressed: () async {
                if (!await confirm(context, l.removeAccess, '${m['fullName']}') || !context.mounted) return;
                if (await act(context, () => api.delete('/admin/staff/${m['userId']}')) && context.mounted) {
                  Navigator.pop(context, true);
                }
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              StaffAvatar(
                name: m == null ? _name.text : '${m['fullName']}',
                // Saved photo; a newly picked one shows after saving.
                url: _photoKey != null && _photoKey == m?['photoKey'] ? (m!['photoUrl'] as String?) : null,
                radius: 32,
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: _pickPhoto,
                icon: const Icon(Icons.add_a_photo_outlined),
                label: Text(l.photo),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _employeeNo,
            decoration: InputDecoration(labelText: l.employeeId),
          ),
          const SizedBox(height: 8),
          if (m == null) ...[
            TextField(
              controller: _name,
              decoration: InputDecoration(labelText: l.fullName),
            ),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: l.email),
            ),
            TextField(
              controller: _password,
              decoration: InputDecoration(labelText: l.tempPassword, helperText: l.passwordHint),
            ),
          ],
          DropdownButtonFormField<String>(
            initialValue: _role,
            decoration: InputDecoration(labelText: l.role),
            items: [
              DropdownMenuItem(value: 'STAFF', child: Text(l.staffHome)),
              DropdownMenuItem(value: 'ADMIN', child: Text(l.adminHome)),
            ],
            onChanged: (v) => setState(() => _role = v!),
          ),
          DropdownButtonFormField<String>(
            initialValue: _department,
            decoration: InputDecoration(labelText: l.department),
            items: [for (final d in departments) DropdownMenuItem(value: '${d['id']}', child: Text('${d['name']}'))],
            onChanged: (v) => setState(() => _department = v),
          ),
          if (_role == 'STAFF') ...[
            const SizedBox(height: 8),
            Text(l.permissions, style: Theme.of(context).textTheme.titleSmall),
            for (final p in perms)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(p),
                value: _perms.contains(p),
                onChanged: (v) => setState(() => v == true ? _perms.add(p) : _perms.remove(p)),
              ),
          ],
          if (!wide) ...[const SizedBox(height: 16), BusyButton(label: l.save, onPressed: save)],
        ],
      ),
    );
  }
}

class _LeaveTab extends ConsumerWidget {
  const _LeaveTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    const path = '/admin/leave';
    Future<void> decide(String id, bool approve) async {
      if (await act(context, () => ref.read(apiProvider).post('$path/$id/decide', {'approve': approve}))) {
        ref.invalidate(getProvider(path));
      }
    }

    return JsonList(
      path: path,
      item: (context, r) => ListTile(
        title: Text(
          '${r['fullName']} · ${dateRange(context, DateTime.parse('${r['from']}'), DateTime.parse('${r['to']}'))}',
        ),
        subtitle: Text('${leaveTypeLabel(l, '${r['type']}')} · ${r['reason'] ?? ''}'),
        trailing: r['status'] == 'pending'
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: l.approve,
                    icon: const Icon(Icons.check),
                    onPressed: () => decide('${r['id']}', true),
                  ),
                  IconButton(
                    tooltip: l.decline,
                    icon: const Icon(Icons.close),
                    onPressed: () => decide('${r['id']}', false),
                  ),
                ],
              )
            : Chip(label: Text(leaveStatus(l, '${r['status']}'))),
      ),
    );
  }
}

class _DepartmentsTab extends ConsumerWidget {
  const _DepartmentsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    const path = '/admin/departments';
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: l.add,
        onPressed: () async {
          final n = await prompt(context, l.departments, label: l.name);
          if (n == null || n.isEmpty || !context.mounted) return;
          if (await act(context, () => ref.read(apiProvider).post(path, {'name': n}))) {
            ref.invalidate(getProvider(path));
          }
        },
        child: const Icon(Icons.add),
      ),
      body: JsonList(
        path: path,
        item: (context, d) => ListTile(title: Text('${d['name']}')),
      ),
    );
  }
}

// ───────────── A16 loyalty ─────────────

class LoyaltyAdminScreen extends ConsumerStatefulWidget {
  const LoyaltyAdminScreen({super.key});
  @override
  ConsumerState<LoyaltyAdminScreen> createState() => _LoyaltyAdminState();
}

class _LoyaltyAdminState extends ConsumerState<LoyaltyAdminScreen> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final api = ref.read(apiProvider);
    const rewardsPath = '/admin/loyalty/rewards';
    final accountsPath = '/admin/loyalty/accounts${_q.isEmpty ? '' : '?q=${Uri.encodeQueryComponent(_q)}'}';
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.loyalty),
          bottom: TabBar(
            tabs: [
              Tab(text: l.rewards),
              Tab(text: l.members),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Scaffold(
              floatingActionButton: FloatingActionButton(
                tooltip: l.add,
                onPressed: () async {
                  final name = await prompt(context, l.rewards, label: l.name);
                  if (name == null || name.isEmpty || !context.mounted) return;
                  final pts = int.tryParse(await prompt(context, l.rewards, label: l.points, number: true) ?? '');
                  if (pts == null || !context.mounted) return;
                  final value = double.tryParse(await prompt(context, l.rewards, label: l.amount, number: true) ?? '');
                  if (value == null || !context.mounted) return;
                  final ok = await act(
                    context,
                    () => api.post(rewardsPath, {
                      'name': {for (final k in supportedLanguages.keys) k: name},
                      'points': pts,
                      'value': value,
                    }),
                  );
                  if (ok) ref.invalidate(getProvider(rewardsPath));
                },
                child: const Icon(Icons.add),
              ),
              body: JsonList(
                path: rewardsPath,
                item: (context, r) => SwitchListTile(
                  title: Text(trOf(context, r['name'])),
                  subtitle: Text('${l.pointsCost('${r['points']}')} · ${money(num2(r['value']), 'PHP')}'),
                  value: r['active'] == true,
                  onChanged: (v) async {
                    final ok = await act(
                      context,
                      () => api.patch('$rewardsPath/${r['id']}', {
                        'name': r['name'],
                        'points': r['points'],
                        'value': num2(r['value']),
                        'active': v,
                      }),
                    );
                    if (ok) ref.invalidate(getProvider(rewardsPath));
                  },
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: l.searchGuest),
                    onSubmitted: (v) => setState(() => _q = v.trim()),
                  ),
                ),
                Expanded(
                  child: JsonList(
                    path: accountsPath,
                    item: (context, a) => ListTile(
                      title: Text('${a['fullName']}'),
                      subtitle: Text('${a['email'] ?? ''} · ${a['tier']}'),
                      trailing: Text('${a['balance']}'),
                      onTap: () async {
                        final pts = int.tryParse(
                          await prompt(context, l.adjustPoints, label: l.pointsPlusMinus, number: true) ?? '',
                        );
                        if (pts == null || !context.mounted) return;
                        final reason = await prompt(context, l.adjustPoints, label: l.reason);
                        if (reason == null || reason.length < 3 || !context.mounted) return;
                        final ok = await act(
                          context,
                          () =>
                              api.post('/admin/loyalty/accounts/${a['id']}/adjust', {'points': pts, 'reason': reason}),
                          done: l.saved,
                        );
                        if (ok) ref.invalidate(getProvider(accountsPath));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
