import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tobetoapp/bloc/auth/auth_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_drawer/auth_provider_drawer.dart';
import 'package:tobetoapp/bloc/auth/auth_event.dart';
import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/screens/homepage.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/widgets/password_suffix_icon.dart';

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
  final _currentPasswordController = TextEditingController();

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isCurrentPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _isOldPasswordVisible = false;
    _isNewPasswordVisible = false;
    _isConfirmPasswordVisible = false;
    _isCurrentPasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.paddingMedium),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPasswordTextField(_oldPasswordController, 'Eski Şifre*',
                    Icons.lock_outline, _isOldPasswordVisible, () {
                  setState(() {
                    _isOldPasswordVisible = !_isOldPasswordVisible;
                  });
                }),
                SizedBox(height: AppConstants.sizedBoxHeightSmall),
                _buildPasswordTextField(_newPasswordController, 'Yeni Şifre*',
                    Icons.lock, _isNewPasswordVisible, () {
                  setState(() {
                    _isNewPasswordVisible = !_isNewPasswordVisible;
                  });
                }),
                SizedBox(height: AppConstants.sizedBoxHeightSmall),
                _buildPasswordTextField(
                    _confirmPasswordController,
                    'Yeni Şifre Tekrar*',
                    Icons.lock,
                    _isConfirmPasswordVisible, () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                }),
                SizedBox(height: AppConstants.sizedBoxHeightXLarge),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ProfileBloc>().add(ChangePassword(
                              _oldPasswordController.text,
                              _newPasswordController.text));
                          _clearPasswordFields();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF9933ff),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.br20),
                        ),
                      ),
                      child: const Text('Şifre Değiştir'),
                    ),
                    SizedBox(height: AppConstants.sizedBoxHeightMedium),
                    ElevatedButton(
                      onPressed: () {
                        _showDeleteAccountDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.br20),
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
                      _clearPasswordFields();
                    } else if (state is ProfileDeleted) {
                      final authProvider = Provider.of<AuthProviderDrawer>(
                          context,
                          listen: false);
                      authProvider.logout();
                      context.read<AuthBloc>().add(AuthLogOut());
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Hesap başarıyla silindi'),
                      ));
                      _clearPasswordFields();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const Homepage()));
                    }
                  },
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField(
      TextEditingController controller,
      String labelText,
      IconData icon,
      bool isPasswordVisible,
      VoidCallback onToggleVisibility) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        icon: Icon(icon),
        suffixIcon: PasswordSuffixIcon(
          isPasswordVisible: isPasswordVisible,
          onToggleVisibility: onToggleVisibility,
        ),
      ),
      obscureText: !isPasswordVisible,
      style: Theme.of(context).textTheme.labelLarge,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText gerekli';
        }
        if (labelText == 'Yeni Şifre*' && value.length < 6) {
          return 'Yeni şifre en az 6 karakter olmalı';
        }
        if (labelText == 'Yeni Şifre Tekrar*' &&
            value != _newPasswordController.text) {
          return 'Yeni şifreler eşleşmiyor';
        }
        return null;
      },
    );
  }

  void _clearPasswordFields() {
    _oldPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    _currentPasswordController.clear();
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(AppConstants.br20)),
            ),
            title: Row(
              children: [
                const Icon(Icons.warning, color: Colors.red),
                SizedBox(width: AppConstants.sizedBoxWidthSmall),
                const Text('Uyarı',
                    style: TextStyle(color: Color.fromARGB(255, 92, 37, 33))),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Üyeliğinizi sonlandırmak istediğinize emin misiniz?',
                  style: TextStyle(color: Colors.black87),
                ),
                SizedBox(height: AppConstants.sizedBoxHeightMedium),
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: false,
                  decoration: const InputDecoration(
                    labelText: 'Mevcut Şifre',
                    icon: Icon(Icons.lock_outline),
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                child: const Text(
                  'İptal',
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _clearPasswordFields();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.br20),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  final currentPassword = _currentPasswordController.text;
                  context
                      .read<ProfileBloc>()
                      .add(DeleteAccount(currentPassword));
                },
                child: const Text('Onayla'),
              ),
            ],
          ),
        );
      },
    );
  }
}
