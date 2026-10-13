import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/adaptive.dart';
import '../../core/http.dart';
import '../../core/ui.dart';
import '../../l10n/app_localizations.dart';
import '../auth/presentation/auth_controller.dart';

/// Guest ↔ staff thread (G24/T8). Same screen for both sides.
/// Polls new messages every 3 s; messages are shown exactly as written.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.id, this.title, this.embedded = false});
  final String id;
  final String? title;

  /// Right pane of the wide inbox: a small name header instead of an app bar.
  final bool embedded;
  @override
  ConsumerState<ChatScreen> createState() => _ChatState();
}

class _ChatState extends ConsumerState<ChatScreen> {
  final _messages = <J>[];
  final _input = TextEditingController();
  final _scroll = ScrollController();
  Timer? _timer;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _load());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final after = _messages.isEmpty ? null : _messages.last['createdAt'] as String;
      final rows = jsonList(
        await ref.read(apiProvider).get('/conversations/${widget.id}/messages', {if (after != null) 'after': after}),
      );
      if (!mounted || rows.isEmpty) return;
      setState(() => _messages.addAll(rows));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) _scroll.jumpTo(_scroll.position.maxScrollExtent);
      });
    } catch (_) {} // offline: try again next tick
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    final ok = await act(
      context,
      () => ref.read(apiProvider).post('/conversations/${widget.id}/messages', {'body': text}),
    );
    if (ok) {
      _input.clear();
      await _load();
    }
    if (mounted) setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(authProvider).valueOrNull?.id;
    final scheme = Theme.of(context).colorScheme;
    final input = TextField(
      controller: _input,
      minLines: 1,
      maxLines: 4,
      textInputAction: TextInputAction.send,
      onSubmitted: (_) => _send(),
      decoration: InputDecoration(hintText: l.typeMessage),
    );
    return Scaffold(
      appBar: widget.embedded ? null : AppBar(title: Text(widget.title ?? l.chat)),
      body: Column(
        children: [
          if (widget.embedded) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  const Icon(Icons.person_outline, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.title ?? l.chat,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
          ],
          Expanded(
            child: _messages.isEmpty
                ? Center(child: Text(l.chatEmpty))
                : ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.all(12),
                    itemCount: _messages.length,
                    itemBuilder: (_, i) {
                      final m = _messages[i];
                      final mine = m['senderId'] == me;
                      return Align(
                        alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.75),
                          decoration: BoxDecoration(
                            color: mine ? scheme.primaryContainer : scheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('${m['body']}'),
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 4, 8),
              child: Row(
                children: [
                  Expanded(
                    child: isWide(context)
                        // Desktop keyboards: Enter sends, Shift+Enter falls through and adds a new line.
                        ? Focus(
                            canRequestFocus: false,
                            skipTraversal: true,
                            onKeyEvent: (_, e) {
                              if (e is! KeyDownEvent || e.logicalKey != LogicalKeyboardKey.enter) {
                                return KeyEventResult.ignored;
                              }
                              if (HardwareKeyboard.instance.isShiftPressed) return KeyEventResult.ignored;
                              _send();
                              return KeyEventResult.handled;
                            },
                            child: input,
                          )
                        : input,
                  ),
                  IconButton(tooltip: l.send, onPressed: _sending ? null : _send, icon: const Icon(Icons.send)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
