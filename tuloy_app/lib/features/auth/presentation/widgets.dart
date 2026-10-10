import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme.dart';
import '../../../core/failure.dart';
import '../../../l10n/app_localizations.dart';

/// Server message when there is one (already localized), else a generic offline message.
String failureText(BuildContext context, Object e) =>
    (e is Failure ? e.message : null) ?? AppLocalizations.of(context).errorGeneric;

Widget _logo(double size) => ClipRRect(
  borderRadius: BorderRadius.circular(size * .22),
  child: Image.asset('assets/logo/tuloy_icon.png', width: size, height: size),
);

/// Auth layout: an arched "doorway" window (logo, name, tagline), a strip of hotel services, then the form.
/// Same palette and arch motif as home, different shape: you're at the door, not inside yet.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.title, required this.children});
  final String title;
  final List<Widget> children;

  static const _services = [
    Icons.king_bed_outlined,
    Icons.room_service_outlined,
    Icons.restaurant_outlined,
    Icons.spa_outlined,
    Icons.local_laundry_service_outlined,
    Icons.airport_shuttle_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    final canPop = Navigator.of(context).canPop();
    final dark = Theme.of(context).brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        appBar: canPop ? AppBar() : null,
        body: SafeArea(
          top: !canPop,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LayoutBuilder(
                      builder: (context, box) => ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(box.maxWidth / 2),
                          bottom: const Radius.circular(28),
                        ),
                        child: SizedBox(
                          height: canPop ? 200 : 280,
                          child: Stack(
                            children: [
                              const Positioned.fill(child: DuskBackdrop(rounded: false)),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _logo(canPop ? 48 : 64),
                                    const SizedBox(height: 12),
                                    Text(l.appTitle, style: text.headlineSmall?.copyWith(color: Colors.white)),
                                    const SizedBox(height: 4),
                                    Text(
                                      l.authTagline,
                                      textAlign: TextAlign.center,
                                      style: text.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: .85)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ExcludeSemantics(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (final icon in _services)
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(color: c.tertiaryContainer, shape: BoxShape.circle),
                              child: Icon(icon, size: 22, color: c.onTertiaryContainer),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Semantics(header: true, child: Text(title, style: text.headlineMedium)),
                    const SizedBox(height: 20),
                    ...children,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shown while the session restores. Logo sits where the native launch screen put it, so the hand-off is seamless.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF0F6E6E),
    body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Stack(
        children: [
          const Positioned.fill(child: DuskBackdrop(rounded: false)),
          Center(child: _logo(112)),
          Align(
            alignment: const Alignment(0, .32),
            child: Text(
              AppLocalizations.of(context).appTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
            ),
          ),
          const Align(
            alignment: Alignment(0, .8),
            child: SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFFF4B860)),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Button that disables itself and shows a spinner while [onPressed] runs.
class BusyButton extends StatefulWidget {
  const BusyButton({super.key, required this.label, required this.onPressed});
  final String label;
  final Future<void> Function() onPressed;

  @override
  State<BusyButton> createState() => _BusyButtonState();
}

class _BusyButtonState extends State<BusyButton> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: _busy
        ? null
        : () async {
            setState(() => _busy = true);
            try {
              await widget.onPressed();
            } finally {
              if (mounted) setState(() => _busy = false);
            }
          },
    child: _busy
        ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
        : Text(widget.label),
  );
}

/// Password input with a lock icon and a show/hide toggle.
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
    this.helper,
    this.autofillHints,
    this.validator,
    this.onFieldSubmitted,
  });
  final TextEditingController controller;
  final String label;
  final String? helper;
  final Iterable<String>? autofillHints;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TextFormField(
      controller: widget.controller,
      obscureText: _hidden,
      autofillHints: widget.autofillHints,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        labelText: widget.label,
        helperText: widget.helper,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          tooltip: _hidden ? l.showPassword : l.hidePassword,
          icon: Icon(_hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined),
          onPressed: () => setState(() => _hidden = !_hidden),
        ),
      ),
    );
  }
}
