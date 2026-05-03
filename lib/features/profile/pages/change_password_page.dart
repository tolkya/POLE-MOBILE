import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/features/profile/data/profile_repository.dart';
import 'package:pole_mobile/features/profile/providers/me_provider.dart';

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
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Changer le mot de passe')),
      body: Form(
        key: _formKey,
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
              decoration: InputDecoration(
                labelText: 'Nouveau mot de passe',
                suffixIcon: IconButton(
                  icon: Icon(
                    _showNew ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => _showNew = !_showNew),
                ),
              ),
              validator: (v) => (v == null || v.length < 8)
                  ? 'Minimum 8 caractères'
                  : null,
            ),
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