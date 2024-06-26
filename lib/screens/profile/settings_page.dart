import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_event.dart';
import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 10),
              Text('Uyarı', style: TextStyle(color: Colors.red)),
            ],
          ),
          content: const Text(
              'Üyeliğinizi sonlandırmak istediğinize emin misiniz?',
              style: TextStyle(color: Colors.black87)),
          actions: [
            TextButton(
              child: const Text(
                'İptal',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<ProfileBloc>().add(DeleteAccount());
                context.read<AuthBloc>().add(AuthLogOut());
              },
              child: const Text('Onayla'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _oldPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Eski Şifre*',
                  icon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Eski şifre gerekli';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: _newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Yeni Şifre*',
                  icon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Yeni şifre gerekli';
                  }
                  if (value.length < 6) {
                    return 'Yeni şifre en az 6 karakter olmalı';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Yeni Şifre Tekrar*',
                  icon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Yeni şifre tekrar gerekli';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Yeni şifreler eşleşmiyor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ProfileBloc>().add(ChangePassword(
                            _oldPasswordController.text,
                            _newPasswordController.text));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF9933ff),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text('Şifre Değiştir'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showDeleteAccountDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text('Üyeliği Sonlandır'),
                  ),
                ],
              ),
              BlocListener<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state is ProfileError) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.message),
                    ));
                  } else if (state is ProfileLoaded) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Şifre başarıyla değiştirildi'),
                    ));
                  } else if (state is ProfileInitial) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Hesap başarıyla silindi'),
                    ));
                  }
                },
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
