import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/features/profile/data/profile_repository.dart';
import 'package:pole_mobile/features/profile/providers/me_provider.dart';

String? _passwordValidator(String? v) {
  if (v == null || v.length < 8) return '8 caractères minimum';
  if (!RegExp('[A-Z]').hasMatch(v)) return '1 lettre majuscule requise';
  if (!RegExp('[0-9]').hasMatch(v)) return '1 chiffre requis';
  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(v)) {
    return '1 symbole requis';
  }
  return null;
}

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() =>
      _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _old = TextEditingController();
  final _new = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;
  bool _showOld = false;
  bool _showNew = false;
  bool _showConfirm = false;
  String _newPasswordValue = '';

  @override
  void dispose() {
    _old.dispose();
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final user = ref.read(meProvider).asData!.value;
      await ref.read(profileRepositoryProvider).changePassword(
        userId: user.id,
        oldPassword: _old.text,
        newPassword: _new.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mot de passe modifié.')),
      );
      Navigator.of(context).pop();
    } on DioException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_mapChangePasswordError(e))),
      );
    } on Exception {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Impossible de modifier le mot de passe pour le moment.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _mapChangePasswordError(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;

    if (status == 405) {
      return "Méthode non autorisée. Redémarre l'app et réessaie.";
    }

    if (status == 401 || status == 403) {
      return 'Session expirée. Reconnecte-toi puis réessaie.';
    }

    if (status == 400 || status == 422) {
      if (data is Map<String, dynamic>) {
        final violations = data['violations'];
        if (violations is List && violations.isNotEmpty) {
          final first = violations.first;
          if (first is Map<String, dynamic>) {
            final message = first['message'];
            if (message is String && message.isNotEmpty) {
              return message;
            }
          }
        }

        final detail = data['detail'];
        if (detail is String && detail.isNotEmpty) {
          return detail;
        }
      }
      return 'Mot de passe actuel incorrect ou nouveau mot de passe invalide.';
    }

    return 'Erreur serveur. Réessaie dans quelques instants.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Changer le mot de passe')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextFormField(
              controller: _old,
              obscureText: !_showOld,
              decoration: InputDecoration(
                labelText: 'Mot de passe actuel',
                suffixIcon: IconButton(
                  icon: Icon(
                    _showOld ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => _showOld = !_showOld),
                ),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _new,
              obscureText: !_showNew,
              onChanged: (v) => setState(() => _newPasswordValue = v),
              decoration: InputDecoration(
                labelText: 'Nouveau mot de passe',
                suffixIcon: IconButton(
                  icon: Icon(
                    _showNew ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => _showNew = !_showNew),
                ),
              ),
              validator: _passwordValidator,
            ),
            const SizedBox(height: 8),
            _PasswordRules(password: _newPasswordValue),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirm,
              obscureText: !_showConfirm,
              decoration: InputDecoration(
                labelText: 'Confirmer le mot de passe',
                suffixIcon: IconButton(
                  icon: Icon(
                    _showConfirm
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () =>
                      setState(() => _showConfirm = !_showConfirm),
                ),
              ),
              validator: (v) => v != _new.text
                ? 'Les mots de passe ne correspondent pas'
                : null,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _loading ? null : _save,
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Modifier'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PasswordRules extends StatelessWidget {
  const _PasswordRules({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PasswordRule(
          label: '8 caractères minimum',
          valid: password.length >= 8,
          theme: theme,
        ),
        _PasswordRule(
          label: '1 lettre majuscule',
          valid: RegExp('[A-Z]').hasMatch(password),
          theme: theme,
        ),
        _PasswordRule(
          label: '1 chiffre',
          valid: RegExp('[0-9]').hasMatch(password),
          theme: theme,
        ),
        _PasswordRule(
          label: r'1 symbole (!@#$...)',
          valid: RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password),
          theme: theme,
        ),
      ],
    );
  }
}

class _PasswordRule extends StatelessWidget {
  const _PasswordRule({
    required this.label,
    required this.valid,
    required this.theme,
  });

  final String label;
  final bool valid;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            valid ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 14,
            color: valid
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: valid
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}