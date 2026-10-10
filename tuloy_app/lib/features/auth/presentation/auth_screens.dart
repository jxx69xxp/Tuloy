import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config.dart';
import '../../../l10n/app_localizations.dart';
import 'auth_controller.dart';
import 'widgets.dart';

String? _validRequired(BuildContext c, String? v) =>
    (v == null || v.trim().isEmpty) ? AppLocalizations.of(c).required : null;
String? _validPassword(BuildContext c, String? v) =>
    (v == null || v.length < 8) ? AppLocalizations.of(c).passwordHint : null;

void _showError(BuildContext context, Object e) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failureText(context, e))));

/// S1 — first run, and reachable from Settings.
class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final current = ref.watch(languageProvider) ?? Localizations.localeOf(context).languageCode;
    return AuthScaffold(
      title: l.chooseLanguage,
      children: [
        for (final e in supportedLanguages.entries)
          ListTile(
            title: Text(e.value),
            trailing: e.key == current ? const Icon(Icons.check) : null,
            selected: e.key == current,
            onTap: () => ref.read(authProvider.notifier).setLanguage(e.key),
          ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () async {
            await ref.read(authProvider.notifier).setLanguage(current);
            if (context.mounted) context.go('/signin');
          },
          child: Text(l.continueLabel),
        ),
      ],
    );
  }
}

/// S2
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});
  @override
  ConsumerState<SignInScreen> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignInScreen> {
  final _form = GlobalKey<FormState>();
  final _login = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _login.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    try {
      await ref.read(authProvider.notifier).signIn(_login.text.trim(), _password.text);
    } catch (e) {
      if (mounted) _showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AuthScaffold(
      title: l.signIn,
      children: [
        Form(
          key: _form,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _login,
                  decoration: InputDecoration(labelText: l.emailOrPhone, prefixIcon: const Icon(Icons.alternate_email)),
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.username],
                  validator: (v) => _validRequired(context, v),
                ),
                const SizedBox(height: 12),
                PasswordField(
                  controller: _password,
                  label: l.password,
                  autofillHints: const [AutofillHints.password],
                  validator: (v) => _validRequired(context, v),
                  onFieldSubmitted: (_) => _submit(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        BusyButton(label: l.signIn, onPressed: _submit),
        TextButton(onPressed: () => context.push('/reset'), child: Text(l.forgotPassword)),
        TextButton(onPressed: () => context.push('/signup'), child: Text(l.noAccount)),
        TextButton(onPressed: () => context.push('/language'), child: Text(l.language)),
      ],
    );
  }
}

/// S3
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});
  @override
  ConsumerState<SignUpScreen> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUpScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _login = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _login.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    try {
      await ref
          .read(authProvider.notifier)
          .signUp(fullName: _name.text.trim(), login: _login.text.trim(), password: _password.text);
    } catch (e) {
      if (mounted) _showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AuthScaffold(
      title: l.signUp,
      children: [
        Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _name,
                decoration: InputDecoration(labelText: l.fullName, prefixIcon: const Icon(Icons.person_outline)),
                textCapitalization: TextCapitalization.words,
                autofillHints: const [AutofillHints.name],
                validator: (v) => _validRequired(context, v),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _login,
                decoration: InputDecoration(labelText: l.emailOrPhone, prefixIcon: const Icon(Icons.alternate_email)),
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.username],
                validator: (v) => _validRequired(context, v),
              ),
              const SizedBox(height: 12),
              PasswordField(
                controller: _password,
                label: l.password,
                helper: l.passwordHint,
                autofillHints: const [AutofillHints.newPassword],
                validator: (v) => _validPassword(context, v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        BusyButton(label: l.signUp, onPressed: _submit),
      ],
    );
  }
}

/// S4 — request a code, then set a new password.
class ResetScreen extends ConsumerStatefulWidget {
  const ResetScreen({super.key});
  @override
  ConsumerState<ResetScreen> createState() => _ResetState();
}

class _ResetState extends ConsumerState<ResetScreen> {
  final _form = GlobalKey<FormState>();
  final _login = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  bool _codeSent = false;

  @override
  void dispose() {
    _login.dispose();
    _code.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    final repo = ref.read(authRepositoryProvider);
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      if (!_codeSent) {
        await repo.requestReset(_login.text.trim());
        if (!mounted) return;
        setState(() => _codeSent = true);
        messenger.showSnackBar(SnackBar(content: Text(l.codeSent)));
      } else {
        await repo.resetPassword(login: _login.text.trim(), code: _code.text.trim(), newPassword: _password.text);
        messenger.showSnackBar(SnackBar(content: Text(l.passwordChanged)));
        if (mounted) context.go('/signin');
      }
    } catch (e) {
      if (mounted) _showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AuthScaffold(
      title: l.resetPassword,
      children: [
        Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _login,
                enabled: !_codeSent,
                decoration: InputDecoration(labelText: l.emailOrPhone, prefixIcon: const Icon(Icons.alternate_email)),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => _validRequired(context, v),
              ),
              if (_codeSent) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _code,
                  decoration: InputDecoration(labelText: l.code, prefixIcon: const Icon(Icons.pin_outlined)),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  validator: (v) => (v ?? '').trim().length == 6 ? null : l.code,
                ),
                PasswordField(
                  controller: _password,
                  label: l.newPassword,
                  helper: l.passwordHint,
                  autofillHints: const [AutofillHints.newPassword],
                  validator: (v) => _validPassword(context, v),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        BusyButton(label: _codeSent ? l.resetPassword : l.sendCode, onPressed: _submit),
      ],
    );
  }
}
