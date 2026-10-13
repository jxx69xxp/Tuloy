import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/adaptive.dart';
import '../../core/config.dart';
import '../../core/format.dart';
import '../../core/http.dart';
import '../../core/find_by_id.dart';
import '../../core/ui.dart';
import '../../core/web/overlays.dart';
import '../../l10n/app_localizations.dart';

String _d(DateTime x) => x.toIso8601String().substring(0, 10);
String trOf(BuildContext context, dynamic v) {
  final m = (v as Map?) ?? const {};
  return '${m[Localizations.localeOf(context).languageCode] ?? m['en'] ?? ''}';
}

/// Wide screens: "Add" in the app bar instead of a floating button (same callback).
class _AddButton extends StatelessWidget {
  const _AddButton(this.onPressed);
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: FilledButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add),
      label: Text(AppLocalizations.of(context).add),
    ),
  );
}

// ───────────── A3/A4 rooms ─────────────

class RoomsAdminScreen extends ConsumerWidget {
  const RoomsAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    const path = '/admin/room-types';
    final api = ref.read(apiProvider);
    final wide = isWide(context);
    // Wide: go keeps this page and opens the editor as a dialog over it; narrow pushes the page as before.
    void open(String p) => wide ? context.go(p) : context.push(p);
    void add() => open('/admin/rooms/type/new');
    void edit(J t) => open('/admin/rooms/type/${t['id']}');
    void rates(J t) => context.push('/admin/rooms/${t['id']}/rates');
    // Room chips (tap toggles active) and "Add room": in the mobile card and the wide expanded row.
    Widget rooms(BuildContext context, J t) => Wrap(
      spacing: 6,
      children: [
        for (final r in jsonList(t['rooms']))
          InputChip(
            label: Text('${r['number']}'),
            selected: r['active'] != false,
            onPressed: () async {
              final ok = await act(
                context,
                () => api.patch('/admin/rooms/${r['id']}', {
                  'roomTypeId': t['id'],
                  'number': r['number'],
                  'active': r['active'] == false,
                }),
              );
              if (ok) ref.invalidate(getProvider(path));
            },
          ),
        ActionChip(
          avatar: const Icon(Icons.add, size: 16),
          label: Text(l.addRoom),
          onPressed: () async {
            final n = await prompt(context, l.addRoom, label: l.roomLabel);
            if (n == null || n.isEmpty || !context.mounted) return;
            if (await act(context, () => api.post('/admin/rooms', {'roomTypeId': t['id'], 'number': n}))) {
              ref.invalidate(getProvider(path));
            }
          },
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l.roomsAndRates),
        actions: [
          IconButton(
            tooltip: l.blocks,
            icon: const Icon(Icons.block),
            onPressed: () => context.push('/admin/rooms/blocks'),
          ),
          if (wide) _AddButton(add),
        ],
      ),
      floatingActionButton: wide
          ? null
          : FloatingActionButton(tooltip: l.add, onPressed: add, child: const Icon(Icons.add)),
      body: JsonList(
        path: path,
        table: JsonTable(
          columns: [l.name, l.maxGuests, l.basePrice, l.rooms, l.status],
          cells: (context, t) => [
            trOf(context, t['name']),
            '${t['maxGuests']}',
            money(num2(t['basePrice']), 'PHP'),
            '${jsonList(t['rooms']).length}',
            t['active'] == false ? l.inactive : l.active,
          ],
          sortKeys: [
            (t) => trOf(context, t['name']).toLowerCase(),
            (t) => num2(t['maxGuests']),
            (t) => num2(t['basePrice']),
            (t) => jsonList(t['rooms']).length,
            (t) => t['active'] == false ? 1 : 0,
          ],
          onTap: edit,
          actions: (context, t) => [
            TextButton.icon(icon: const Icon(Icons.price_change), label: Text(l.rates), onPressed: () => rates(t)),
          ],
          expanded: rooms,
        ),
        item: (context, t) => Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(trOf(context, t['name'])),
                subtitle: Text(
                  '${money(num2(t['basePrice']), 'PHP')} · ${l.guests}: ${t['maxGuests']}${t['active'] == false ? ' · ${l.inactive}' : ''}',
                ),
                trailing: const Icon(Icons.edit),
                onTap: () => edit(t),
              ),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: rooms(context, t)),
              TextButton.icon(icon: const Icon(Icons.price_change), label: Text(l.rates), onPressed: () => rates(t)),
            ],
          ),
        ),
      ),
    );
  }
}

class RoomTypeEditScreen extends ConsumerStatefulWidget {
  const RoomTypeEditScreen({super.key, this.type});
  final J? type;
  @override
  ConsumerState<RoomTypeEditScreen> createState() => _RoomTypeEditState();
}

class _RoomTypeEditState extends ConsumerState<RoomTypeEditScreen> {
  late final _name = Tr(widget.type?['name'] as Map?);
  late final _desc = Tr(widget.type?['description'] as Map?);
  late final _guests = TextEditingController(text: '${widget.type?['maxGuests'] ?? 2}');
  late final _price = TextEditingController(text: '${widget.type?['basePrice'] ?? ''}');
  late final _amenities = TextEditingController(text: ((widget.type?['amenities'] as List?) ?? const []).join(', '));
  late final List<String> _photos = [...((widget.type?['photos'] as List?) ?? const []).cast<String>()];
  late bool _active = widget.type?['active'] != false;

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _guests.dispose();
    _price.dispose();
    _amenities.dispose();
    super.dispose();
  }

  Future<void> _addPhoto() async {
    final f = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 2000, imageQuality: 85);
    if (f == null || !mounted) return;
    final ext = f.name.toLowerCase().endsWith('.png') ? 'png' : 'jpg';
    await act(context, () async {
      final key = await ref.read(apiProvider).upload('rooms', await f.readAsBytes(), ext);
      setState(() => _photos.add(key));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final id = widget.type?['id'];
    final wide = isWide(context);
    Future<void> save() async {
      final body = {
        'name': _name.value,
        'description': _desc.value,
        'maxGuests': int.tryParse(_guests.text) ?? 2,
        'basePrice': double.tryParse(_price.text) ?? 0,
        'amenities': _amenities.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
        'photos': _photos,
        'active': _active,
      };
      final api = ref.read(apiProvider);
      if (await act(
        context,
        () => id == null ? api.post('/admin/room-types', body) : api.patch('/admin/room-types/$id', body),
        done: l.saved,
      )) {
        ref.invalidate(getProvider('/admin/room-types'));
        if (context.mounted) popOr(context, '/admin/rooms');
      }
    }

    return Scaffold(
      bottomNavigationBar: wide
          ? EditorFooter(
              save: BusyButton(label: l.save, onPressed: save),
            )
          : null,
      appBar: AppBar(title: Text(l.roomTypeLabel)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._name.fields(l.name),
          ..._desc.fields(l.description, maxLines: 3),
          TextField(
            controller: _guests,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l.maxGuests),
          ),
          TextField(
            controller: _price,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: l.basePrice),
          ),
          TextField(
            controller: _amenities,
            decoration: InputDecoration(labelText: l.amenities, helperText: 'wifi, aircon, tv'),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.active),
            value: _active,
            onChanged: (v) => setState(() => _active = v),
          ),
          Text(l.photos, style: Theme.of(context).textTheme.titleSmall),
          Wrap(
            spacing: 8,
            children: [
              for (final p in _photos)
                InputChip(label: Text(p.split('/').last), onDeleted: () => setState(() => _photos.remove(p))),
              ActionChip(
                avatar: const Icon(Icons.add_a_photo, size: 16),
                label: Text(l.addPhoto),
                onPressed: _addPhoto,
              ),
            ],
          ),
          if (!wide) ...[const SizedBox(height: 16), BusyButton(label: l.save, onPressed: save)],
        ],
      ),
    );
  }
}

/// Set a price for every night in a date range (or clear back to base price).
class RatesScreen extends ConsumerStatefulWidget {
  const RatesScreen({super.key, required this.type});
  final J type;
  @override
  ConsumerState<RatesScreen> createState() => _RatesState();
}

class _RatesState extends ConsumerState<RatesScreen> {
  late DateTime _from = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final to = _from.add(const Duration(days: 30));
    final path = '/admin/room-types/${widget.type['id']}/rates?from=${_d(_from)}&to=${_d(to)}';
    return Scaffold(
      appBar: AppBar(title: Text('${l.rates} · ${trOf(context, widget.type['name'])}')),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.edit_calendar),
        label: Text(l.setRate),
        onPressed: () async {
          final range = await showDateRangePicker(
            context: context,
            firstDate: DateTime.now().subtract(const Duration(days: 1)),
            lastDate: DateTime.now().add(const Duration(days: 730)),
          );
          if (range == null || !context.mounted) return;
          final v = await prompt(context, l.setRate, label: '${l.price} (${l.emptyResets})', number: true);
          if (v == null || !context.mounted) return;
          final price = v.isEmpty ? null : double.tryParse(v);
          final days = <J>[];
          for (var d = range.start; !d.isAfter(range.end); d = d.add(const Duration(days: 1))) {
            days.add({'date': _d(d), 'price': price});
          }
          if (await act(
            context,
            () => ref.read(apiProvider).put('/admin/room-types/${widget.type['id']}/rates', {'rates': days}),
            done: l.saved,
          )) {
            ref.invalidate(getProvider(path));
          }
        },
      ),
      body: Column(
        children: [
          TextButton.icon(
            icon: const Icon(Icons.calendar_month),
            label: Text(dateRange(context, _from, to)),
            onPressed: () async {
              final d = await showDatePicker(
                context: context,
                firstDate: DateTime(2024),
                lastDate: DateTime.now().add(const Duration(days: 730)),
                initialDate: _from,
              );
              if (d != null) setState(() => _from = d);
            },
          ),
          Expanded(
            child: JsonList(
              path: path,
              item: (context, r) => ListTile(
                dense: true,
                title: Text(date(context, DateTime.parse('${r['date']}'))),
                trailing: Text(
                  money(num2(r['price']), 'PHP'),
                  style: TextStyle(fontWeight: r['override'] == true ? FontWeight.bold : null),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Inventory blocks (maintenance, owner use).
class BlocksScreen extends ConsumerWidget {
  const BlocksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final now = DateTime.now();
    final path = '/admin/blocks?from=${_d(now)}&to=${_d(now.add(const Duration(days: 365)))}';
    final api = ref.read(apiProvider);
    final wide = isWide(context);
    Future<void> edit({required bool add}) async {
      final types = jsonList(await api.get('/admin/room-types'));
      final rooms = [for (final t in types) ...jsonList(t['rooms'])];
      if (!context.mounted || rooms.isEmpty) return;
      final roomId = await showDialog<String>(
        context: context,
        builder: (c) => SimpleDialog(
          title: Text(l.roomLabel),
          children: [
            for (final r in rooms)
              SimpleDialogOption(onPressed: () => Navigator.pop(c, '${r['id']}'), child: Text('${r['number']}')),
          ],
        ),
      );
      if (roomId == null || !context.mounted) return;
      final range = await showDateRangePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (range == null || !context.mounted) return;
      final body = {'roomId': roomId, 'from': _d(range.start), 'to': _d(range.end)};
      final ok = await act(
        context,
        () => add ? api.post('/admin/blocks', {...body, 'note': 'maintenance'}) : api.delete('/admin/blocks', body),
        done: l.saved,
      );
      if (ok) ref.invalidate(getProvider(path));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.blocks),
        actions: [
          TextButton(onPressed: () => edit(add: false), child: Text(l.unblock)),
          if (wide) _AddButton(() => edit(add: true)),
        ],
      ),
      floatingActionButton: wide
          ? null
          : FloatingActionButton(tooltip: l.add, onPressed: () => edit(add: true), child: const Icon(Icons.add)),
      body: JsonList(
        path: path,
        table: JsonTable(
          columns: [l.roomLabel, l.dateLabel, l.note],
          cells: (context, b) => ['${b['room']}', date(context, DateTime.parse('${b['date']}')), '${b['note'] ?? ''}'],
          sortKeys: [(b) => '${b['room']}', (b) => DateTime.parse('${b['date']}'), (b) => '${b['note'] ?? ''}'],
        ),
        item: (context, b) => ListTile(
          dense: true,
          title: Text('${l.roomNumber('${b['room']}')} · ${date(context, DateTime.parse('${b['date']}'))}'),
          subtitle: Text('${b['note'] ?? ''}'),
        ),
      ),
    );
  }
}

// ───────────── S-1 service builder ─────────────

class ServicesAdminScreen extends StatelessWidget {
  const ServicesAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final wide = isWide(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.services),
        actions: [if (wide) _AddButton(() => context.push('/admin/services/new'))],
      ),
      floatingActionButton: wide
          ? null
          : FloatingActionButton(
              tooltip: l.add,
              onPressed: () => context.push('/admin/services/new'),
              child: const Icon(Icons.add),
            ),
      body: JsonList(
        path: '/admin/services',
        table: JsonTable(
          columns: [l.name, l.category, l.status],
          cells: (context, s) => [trOf(context, s['name']), '${s['category']}', '${s['status']}'],
          onTap: (s) => context.push('/admin/services/${s['id']}'),
          sortKeys: [(s) => trOf(context, s['name']).toLowerCase(), (s) => '${s['category']}', (s) => '${s['status']}'],
        ),
        item: (context, s) => ListTile(
          title: Text(trOf(context, s['name'])),
          subtitle: Text('${s['category']} · ${s['status']}'),
          onTap: () => context.push('/admin/services/${s['id']}'),
        ),
      ),
    );
  }
}

/// One editable form-field definition row.
class _FieldDraft {
  _FieldDraft([J? f])
    : key = TextEditingController(text: '${f?['key'] ?? ''}'),
      label = Tr(f?['label'] as Map?),
      options = TextEditingController(
        text: [for (final o in ((f?['options'] as List?) ?? const [])) '${(o as Map)['value']}'].join(', '),
      ),
      type = '${f?['type'] ?? 'text'}',
      required = f?['required'] == true;
  final TextEditingController key;
  final Tr label;
  final TextEditingController options;
  String type;
  bool required;

  J toJson() => {
    'key': key.text.trim(),
    'type': type,
    'required': required,
    'label': label.value,
    if (type == 'select')
      'options': [
        for (final v in options.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty))
          {
            'value': v,
            'label': {for (final k in supportedLanguages.keys) k: v},
          },
      ],
  };

  void dispose() {
    key.dispose();
    label.dispose();
    options.dispose();
  }
}

class _OptionDraft {
  _OptionDraft([J? o])
    : id = o?['id'] as String?,
      name = Tr(o?['name'] as Map?),
      price = TextEditingController(text: '${o?['priceDelta'] ?? 0}'),
      active = o?['active'] != false;
  final String? id;
  final Tr name;
  final TextEditingController price;
  bool active;

  J toJson() => {
    if (id != null) 'id': id,
    'name': name.value,
    'priceDelta': double.tryParse(price.text) ?? 0,
    'active': active,
  };
}

class ServiceEditScreen extends ConsumerStatefulWidget {
  const ServiceEditScreen({super.key, this.id});
  final String? id;
  @override
  ConsumerState<ServiceEditScreen> createState() => _ServiceEditState();
}

class _ServiceEditState extends ConsumerState<ServiceEditScreen> {
  J? _s;
  bool _loading = true;
  final _name = Tr(), _desc = Tr(), _cancel = Tr();
  final _category = TextEditingController(text: 'extra');
  final _price = TextEditingController();
  final _lead = TextEditingController(text: '30');
  final _eta = TextEditingController(text: '60');
  final _from = TextEditingController(text: '07:00');
  final _to = TextEditingController(text: '21:00');
  final _steps = TextEditingController(text: 'requested, accepted, in_progress, completed');
  final _days = <int>{1, 2, 3, 4, 5, 6, 7};
  final _methods = <String>{'ROOM_CHARGE'};
  final _fields = <_FieldDraft>[];
  final _options = <_OptionDraft>[];
  String _model = 'FIXED';
  String _acceptance = 'STAFF_APPROVAL';
  String? _department;
  bool _taxIncluded = true;
  bool _loyalty = false;

  @override
  void initState() {
    super.initState();
    if (widget.id == null) {
      _loading = false;
      return;
    }
    ref
        .read(apiProvider)
        .get('/admin/services/${widget.id}')
        .then((v) {
          final s = (v as Map).cast<String, dynamic>();
          if (!mounted) return;
          setState(() {
            _s = s;
            _loading = false;
            for (final e in [(_name, s['name']), (_desc, s['description']), (_cancel, s['cancellationPolicy'])]) {
              for (final k in supportedLanguages.keys) {
                e.$1.c[k]!.text = '${(e.$2 as Map?)?[k] ?? ''}';
              }
            }
            _category.text = '${s['category']}';
            _price.text = s['basePrice'] == null ? '' : '${s['basePrice']}';
            _lead.text = '${s['leadTimeMin']}';
            _eta.text = '${s['etaMin'] ?? ''}';
            final sch = (s['schedule'] as Map?) ?? {};
            _from.text = '${sch['from'] ?? '07:00'}';
            _to.text = '${sch['to'] ?? '21:00'}';
            _days
              ..clear()
              ..addAll(((sch['days'] as List?) ?? const []).cast<int>());
            _steps.text = (s['statusSteps'] as List).join(', ');
            _methods
              ..clear()
              ..addAll((s['paymentMethods'] as List).cast<String>());
            _fields.addAll(jsonList(s['fields']).map(_FieldDraft.new));
            _options.addAll(jsonList(s['options']).map(_OptionDraft.new));
            _model = '${s['priceModel']}';
            _acceptance = '${s['acceptanceMode']}';
            _department = s['departmentId'] as String?;
            _taxIncluded = s['taxIncluded'] == true;
            _loyalty = s['loyaltyEarn'] == true;
          });
        })
        .catchError((Object e) {
          if (mounted) snack(context, failureText(context, e));
        });
  }

  @override
  void dispose() {
    for (final x in [_name, _desc, _cancel]) {
      x.dispose();
    }
    for (final x in [_category, _price, _lead, _eta, _from, _to, _steps]) {
      x.dispose();
    }
    for (final f in _fields) {
      f.dispose();
    }
    super.dispose();
  }

  J _body() => {
    'category': _category.text.trim(),
    'name': _name.value,
    'description': _desc.value,
    'schedule': {'days': (_days.toList()..sort()), 'from': _from.text.trim(), 'to': _to.text.trim()},
    'leadTimeMin': int.tryParse(_lead.text) ?? 0,
    if (int.tryParse(_eta.text) != null) 'etaMin': int.parse(_eta.text),
    'blackoutDates': ((_s?['blackoutDates'] as List?) ?? const []).map((d) => '$d'.substring(0, 10)).toList(),
    'priceModel': _model,
    if (_model != 'QUOTE' && double.tryParse(_price.text) != null) 'basePrice': double.parse(_price.text),
    'currency': 'PHP',
    'taxIncluded': _taxIncluded,
    'paymentMethods': _methods.toList(),
    'fields': [for (final f in _fields) f.toJson()],
    if (_department != null) 'departmentId': _department,
    'acceptanceMode': _acceptance,
    'statusSteps': _steps.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
    'cancellationPolicy': _cancel.value,
    'loyaltyEarn': _loyalty,
    'loyaltyRedeem': false,
  };

  Future<String?> _save() async {
    final api = ref.read(apiProvider);
    final s = widget.id == null && _s == null
        ? await api.post('/admin/services', _body()) as Map
        : await api.patch('/admin/services/${_s?['id'] ?? widget.id}', _body()) as Map;
    final id = '${s['id']}';
    await api.put('/admin/services/$id/options', {
      'options': [for (final o in _options) o.toJson()],
    });
    final fresh = (await api.get('/admin/services/$id') as Map).cast<String, dynamic>();
    setState(() => _s = fresh);
    ref.invalidate(getProvider('/admin/services'));
    return id;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (_loading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final missing = ((_s?['missing'] as List?) ?? const []).cast<String>();
    final departments = jsonList(ref.watch(getProvider('/admin/departments')).valueOrNull ?? const []);
    const dayNames = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    const methods = ['ONLINE', 'ROOM_CHARGE', 'PAY_AT_OUTLET', 'FREE'];
    final wide = isWide(context);
    void publish() => act(context, () async {
      final id = await _save();
      await ref.read(apiProvider).post('/admin/services/$id/publish');
      await _save();
    }, done: l.published);
    void pause() => act(context, () async {
      await ref.read(apiProvider).post('/admin/services/${_s!['id']}/pause');
      await _save();
    }, done: l.saved);
    final saveDraft = BusyButton(
      label: l.saveDraft,
      onPressed: () => act(context, _save, done: l.saved),
    );
    return Scaffold(
      appBar: AppBar(title: Text(l.serviceBuilder)),
      // Wide: the save/publish buttons stay visible in a footer instead of at the end of the long form.
      bottomNavigationBar: wide
          ? EditorFooter(
              more: [
                if (_s?['status'] == 'PUBLISHED') TextButton(onPressed: pause, child: Text(l.pause)),
                FilledButton.tonal(onPressed: publish, child: Text(l.publish)),
              ],
              save: saveDraft,
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_s != null) Text('${l.status}: ${_s!['status']}', style: Theme.of(context).textTheme.titleSmall),
          if (missing.isNotEmpty)
            Text(
              '${l.missingToPublish}: ${missing.join(', ')}',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          const SizedBox(height: 8),
          TextField(
            controller: _category,
            decoration: InputDecoration(
              labelText: l.category,
              helperText: 'laundry, cleaning, dining, transfer, wellness, amenity, extra',
            ),
          ),
          const SizedBox(height: 8),
          ..._name.fields(l.name),
          ..._desc.fields(l.description, maxLines: 3),
          Text(l.schedule, style: Theme.of(context).textTheme.titleSmall),
          Wrap(
            spacing: 4,
            children: [
              for (var d = 1; d <= 7; d++)
                FilterChip(
                  label: Text(dayNames[d - 1]),
                  selected: _days.contains(d),
                  onSelected: (v) => setState(() => v ? _days.add(d) : _days.remove(d)),
                ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _from,
                  decoration: InputDecoration(labelText: l.opens),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _to,
                  decoration: InputDecoration(labelText: l.closes),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _lead,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: l.leadTimeMin),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _eta,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: l.etaMin),
                ),
              ),
            ],
          ),
          DropdownButtonFormField<String>(
            initialValue: _model,
            decoration: InputDecoration(labelText: l.priceModel),
            items: [
              for (final m in ['FIXED', 'PER_ITEM', 'PER_PERSON', 'PER_NIGHT', 'QUOTE'])
                DropdownMenuItem(value: m, child: Text(m)),
            ],
            onChanged: (v) => setState(() => _model = v!),
          ),
          if (_model != 'QUOTE')
            TextField(
              controller: _price,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l.basePrice),
            ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.taxIncluded),
            value: _taxIncluded,
            onChanged: (v) => setState(() => _taxIncluded = v),
          ),
          Text(l.paymentMethod, style: Theme.of(context).textTheme.titleSmall),
          Wrap(
            spacing: 4,
            children: [
              for (final m in methods)
                FilterChip(
                  label: Text(m),
                  selected: _methods.contains(m),
                  onSelected: (v) => setState(() => v ? _methods.add(m) : _methods.remove(m)),
                ),
            ],
          ),
          DropdownButtonFormField<String>(
            initialValue: _department,
            decoration: InputDecoration(labelText: l.department),
            items: [for (final d in departments) DropdownMenuItem(value: '${d['id']}', child: Text('${d['name']}'))],
            onChanged: (v) => setState(() => _department = v),
          ),
          DropdownButtonFormField<String>(
            initialValue: _acceptance,
            decoration: InputDecoration(labelText: l.acceptance),
            items: [
              DropdownMenuItem(value: 'AUTO', child: Text(l.autoAccept)),
              DropdownMenuItem(value: 'STAFF_APPROVAL', child: Text(l.staffApproval)),
            ],
            onChanged: (v) => setState(() => _acceptance = v!),
          ),
          TextField(
            controller: _steps,
            decoration: InputDecoration(labelText: l.statusSteps, helperText: 'requested, …, completed'),
          ),
          ..._cancel.fields(l.cancellationPolicy, maxLines: 2),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.earnsPoints),
            value: _loyalty,
            onChanged: (v) => setState(() => _loyalty = v),
          ),
          const Divider(),
          Text(l.options, style: Theme.of(context).textTheme.titleSmall),
          for (final o in _options)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    ...o.name.fields(l.name),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: o.price,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                            decoration: InputDecoration(labelText: l.priceDelta),
                          ),
                        ),
                        Switch(value: o.active, onChanged: (v) => setState(() => o.active = v)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          TextButton.icon(
            icon: const Icon(Icons.add),
            label: Text(l.addOption),
            onPressed: () => setState(() => _options.add(_OptionDraft())),
          ),
          const Divider(),
          Text(l.formFields, style: Theme.of(context).textTheme.titleSmall),
          for (final f in _fields)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: f.key,
                            decoration: InputDecoration(labelText: l.fieldKey, helperText: 'quantity, persons, notes…'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        DropdownButton<String>(
                          value: f.type,
                          items: [
                            for (final t in ['text', 'number', 'select', 'datetime', 'location', 'checkbox'])
                              DropdownMenuItem(value: t, child: Text(t)),
                          ],
                          onChanged: (v) => setState(() => f.type = v!),
                        ),
                      ],
                    ),
                    ...f.label.fields(l.label),
                    if (f.type == 'select')
                      TextField(
                        controller: f.options,
                        decoration: InputDecoration(labelText: l.choices, helperText: 'S, M, L'),
                      ),
                    Row(
                      children: [
                        Checkbox(value: f.required, onChanged: (v) => setState(() => f.required = v ?? false)),
                        Text(l.required),
                        const Spacer(),
                        IconButton(
                          tooltip: l.delete,
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => setState(() => _fields.remove(f)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          TextButton.icon(
            icon: const Icon(Icons.add),
            label: Text(l.addField),
            onPressed: () => setState(() => _fields.add(_FieldDraft())),
          ),
          if (!wide) ...[
            const SizedBox(height: 16),
            saveDraft,
            const SizedBox(height: 8),
            FilledButton.tonal(onPressed: publish, child: Text(l.publish)),
            if (_s?['status'] == 'PUBLISHED') TextButton(onPressed: pause, child: Text(l.pause)),
          ],
        ],
      ),
    );
  }
}

// ───────────── R-1 restaurant setup ─────────────

class RestaurantAdminScreen extends ConsumerWidget {
  const RestaurantAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    const path = '/admin/outlets';
    final api = ref.read(apiProvider);
    final wide = isWide(context);
    Future<void> add() async {
      final n = await prompt(context, l.addOutlet, label: l.name);
      if (n == null || n.isEmpty || !context.mounted) return;
      final ok = await act(
        context,
        () => api.post(path, {
          'name': {for (final k in supportedLanguages.keys) k: n},
          'schedule': {
            'days': [1, 2, 3, 4, 5, 6, 7],
            'from': '06:00',
            'to': '22:00',
          },
        }),
      );
      if (ok) ref.invalidate(getProvider(path));
    }

    void menu(J o) => context.push('/admin/restaurant/${o['id']}/menu');
    String hours(J o) {
      final h = (o['schedule'] as Map?) ?? const {};
      return '${h['from'] ?? ''}–${h['to'] ?? ''}';
    }

    // Table chips (new QR with warning) and "Add table": in the mobile card and the wide expanded row.
    Widget tables(BuildContext context, J o) => Wrap(
      spacing: 6,
      children: [
        for (final t in jsonList(o['tables']))
          ActionChip(
            avatar: const Icon(Icons.qr_code, size: 16),
            label: Text('${t['label']}'),
            onPressed: () async {
              if (!await confirm(context, l.newQr, l.newQrWarning) || !context.mounted) return;
              try {
                final r = await api.post('/admin/tables/${t['id']}/qr') as Map;
                if (!context.mounted) return;
                await showDialog<void>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: Text(l.tableLabel('${t['label']}')),
                    content: SizedBox(
                      width: 240,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          QrImageView(data: '${r['qrPayload']}', size: 220, backgroundColor: Colors.white),
                          CopyRow(l.qrCode, '${r['qrPayload']}'),
                        ],
                      ),
                    ),
                    actions: [TextButton(onPressed: () => Navigator.pop(c), child: Text(l.ok))],
                  ),
                );
              } catch (e) {
                if (context.mounted) snack(context, failureText(context, e));
              }
            },
          ),
        ActionChip(
          avatar: const Icon(Icons.add, size: 16),
          label: Text(l.addTable),
          onPressed: () async {
            final n = await prompt(context, l.addTable, label: l.label);
            if (n == null || n.isEmpty || !context.mounted) return;
            if (await act(context, () => api.post('/admin/outlets/${o['id']}/tables', {'label': n}))) {
              ref.invalidate(getProvider(path));
            }
          },
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text(l.restaurant), actions: [if (wide) _AddButton(add)]),
      floatingActionButton: wide
          ? null
          : FloatingActionButton(tooltip: l.add, onPressed: add, child: const Icon(Icons.add)),
      body: JsonList(
        path: path,
        table: JsonTable(
          columns: [l.name, l.schedule, l.tables],
          cells: (context, o) => [trOf(context, o['name']), hours(o), '${jsonList(o['tables']).length}'],
          sortKeys: [
            (o) => trOf(context, o['name']).toLowerCase(),
            (o) => '${(o['schedule'] as Map?)?['from'] ?? ''}',
            (o) => jsonList(o['tables']).length,
          ],
          actions: (context, o) => [TextButton(onPressed: () => menu(o), child: Text(l.menu))],
          expanded: tables,
        ),
        item: (context, o) => Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(trOf(context, o['name'])),
                trailing: TextButton(onPressed: () => menu(o), child: Text(l.menu)),
              ),
              Padding(padding: const EdgeInsets.fromLTRB(12, 0, 12, 12), child: tables(context, o)),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuAdminScreen extends ConsumerWidget {
  const MenuAdminScreen({super.key, required this.outlet});
  final J outlet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final path = '/admin/outlets/${outlet['id']}/menu';
    final api = ref.read(apiProvider);
    Future<void> edit([J? item]) async {
      final saved = await Navigator.of(
        context,
      ).push<bool>(editorRoute(context, _MenuItemEdit(outletId: '${outlet['id']}', item: item)));
      if (saved == true) ref.invalidate(getProvider(path));
    }

    return Scaffold(
      appBar: AppBar(title: Text('${l.menu} · ${trOf(context, outlet['name'])}')),
      floatingActionButton: FloatingActionButton(tooltip: l.add, onPressed: edit, child: const Icon(Icons.add)),
      body: JsonList(
        path: path,
        item: (context, i) => ListTile(
          title: Text(trOf(context, i['name'])),
          subtitle: Text('${trOf(context, i['category'])} · ${money(num2(i['price']), 'PHP')}'),
          trailing: Switch(
            value: i['available'] == true,
            onChanged: (v) async {
              if (await act(context, () => api.patch('/admin/menu-items/${i['id']}', {'available': v}))) {
                ref.invalidate(getProvider(path));
              }
            },
          ),
          onTap: () => edit(i),
        ),
      ),
    );
  }
}

class _MenuItemEdit extends ConsumerStatefulWidget {
  const _MenuItemEdit({required this.outletId, this.item});
  final String outletId;
  final J? item;
  @override
  ConsumerState<_MenuItemEdit> createState() => _MenuItemEditState();
}

class _MenuItemEditState extends ConsumerState<_MenuItemEdit> {
  late final _name = Tr(widget.item?['name'] as Map?);
  late final _category = Tr(widget.item?['category'] as Map?);
  late final _price = TextEditingController(text: '${widget.item?['price'] ?? ''}');
  late final _allergens = TextEditingController(text: ((widget.item?['allergens'] as List?) ?? const []).join(', '));

  @override
  void dispose() {
    _name.dispose();
    _category.dispose();
    _price.dispose();
    _allergens.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final id = widget.item?['id'];
    final wide = isWide(context);
    Future<void> save() async {
      final body = {
        'name': _name.value,
        'category': _category.value,
        'price': double.tryParse(_price.text) ?? 0,
        'allergens': _allergens.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
        'available': widget.item?['available'] ?? true,
      };
      final api = ref.read(apiProvider);
      if (await act(
            context,
            () => id == null
                ? api.post('/admin/outlets/${widget.outletId}/menu', body)
                : api.patch('/admin/menu-items/$id', body),
          ) &&
          context.mounted) {
        Navigator.pop(context, true);
      }
    }

    return Scaffold(
      bottomNavigationBar: wide
          ? EditorFooter(
              save: BusyButton(label: l.save, onPressed: save),
            )
          : null,
      appBar: AppBar(title: Text(l.menu)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._name.fields(l.name),
          ..._category.fields(l.category),
          TextField(
            controller: _price,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: l.price),
          ),
          TextField(
            controller: _allergens,
            decoration: InputDecoration(labelText: l.allergens, helperText: 'gluten, soy, nuts'),
          ),
          if (!wide) ...[const SizedBox(height: 16), BusyButton(label: l.save, onPressed: save)],
        ],
      ),
    );
  }
}
