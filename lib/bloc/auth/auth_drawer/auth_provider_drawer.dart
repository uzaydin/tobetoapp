import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tobetoapp/widgets/drawer/common_drawer.dart';
import 'package:tobetoapp/widgets/drawer/common_user_drawer.dart';

//void main() => runApp(const MyApp());

class AuthProviderDrawer extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
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
