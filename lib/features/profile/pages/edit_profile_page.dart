import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pole_mobile/features/profile/data/profile_repository.dart';
import 'package:pole_mobile/features/profile/providers/me_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _phone;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(meProvider).asData?.value;
    _firstName = TextEditingController(text: user?.firstName ?? '');
    _lastName = TextEditingController(text: user?.lastName ?? '');
    _phone = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final user = ref.read(meProvider).asData!.value;
      final updated = await ref.read(profileRepositoryProvider).updateProfile(
        userId: user.id,
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
      );
      ref.read(meProvider.notifier).updateUser(updated);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil mis à jour.')),
      );
      Navigator.of(context).pop();
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le profil')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextFormField(
              controller: _firstName,
              decoration: const InputDecoration(labelText: 'Prénom'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastName,
              decoration: const InputDecoration(labelText: 'Nom'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phone,
              decoration: const InputDecoration(labelText: 'Téléphone'),
              keyboardType: TextInputType.phone,
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
                  : const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}