import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import 'auth_controller.dart';
import 'widgets.dart';

String? _validRequired(BuildContext c, String? v) =>
    (v == null || v.trim().isEmpty) ? AppLocalizations.of(c).required : null;
String? _validPassword(BuildContext c, String? v) =>
    (v == null || v.length < 8) ? AppLocalizations.of(c).passwordHint : null;

void _showError(BuildContext context, Object e) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failureText(context, e))));

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
                  textInputAction: TextInputAction.next,
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
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton(onPressed: () => context.push('/reset'), child: Text(l.forgotPassword)),
        ),
        const SizedBox(height: 12),
        BusyButton(label: l.signIn, onPressed: _submit),
        const SizedBox(height: 16),
        _SwitchPrompt(prompt: l.noAccount, action: l.signUp, onPressed: () => context.push('/signup')),
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
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                validator: (v) => _validRequired(context, v),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _login,
                decoration: InputDecoration(labelText: l.emailOrPhone, prefixIcon: const Icon(Icons.alternate_email)),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
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
                onFieldSubmitted: (_) => _submit(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        BusyButton(label: l.signUp, onPressed: _submit),
        const SizedBox(height: 16),
        _SwitchPrompt(prompt: l.haveAccount, action: l.signIn, onPressed: () => context.go('/signin')),
      ],
    );
  }
}

/// "Don't have an account? Create account" line under the main button.
class _SwitchPrompt extends StatelessWidget {
  const _SwitchPrompt({required this.prompt, required this.action, required this.onPressed});
  final String prompt;
  final String action;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      Text(prompt),
      TextButton(onPressed: onPressed, child: Text(action)),
    ],
  );
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
