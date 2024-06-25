import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tobetoapp/bloc/auth/auth_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_event.dart';
import 'package:tobetoapp/widgets/drawer/common_drawer.dart';
import 'package:tobetoapp/widgets/drawer/common_user_drawer.dart';

class AuthProviderDrawer extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  AuthProviderDrawer() {
    _loadLoginStatus();
  }

  Future<void> _loadLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  Future<void> login() async {
    _isLoggedIn = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    _isLoggedIn = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    BlocProvider.of<AuthBloc>(context).add(AuthLogOut());
    notifyListeners();
  }
}

class DrawerManager extends StatelessWidget {
  const DrawerManager({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderDrawer>(context, listen: true);
    final drawer = authProvider.isLoggedIn
        ? const CommonUserDrawer()
        : const CommonDrawer();

    return drawer;
  }
}
