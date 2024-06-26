import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tobetoapp/models/userModel.dart';
import 'package:tobetoapp/repository/auth_repo.dart';
import 'package:tobetoapp/widgets/drawer/admin_drawer.dart';
import 'package:tobetoapp/widgets/drawer/common_drawer.dart';
import 'package:tobetoapp/widgets/drawer/common_user_drawer.dart';
import 'package:tobetoapp/widgets/drawer/teacher_drawer.dart';

class AuthProviderDrawer extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  UserModel? _userModel;
  String? _userRole;

  User? get user => _user;
  UserModel? get userModel => _userModel;
  String? get userRole => _userRole;

  bool get isLoggedIn => _user != null;

  AuthProviderDrawer() {
    _user = _firebaseAuth.currentUser;
    if (_user != null) {
      _loadUserDetails();
    }
  }

  Future<void> login() async {
    _user = _firebaseAuth.currentUser;

    if (_user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(_user!.uid).get();
      if (userDoc.exists) {
        _userModel = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        _userRole = _userModel?.role.toString();
      }
    }
    notifyListeners();
  }

  Future<void> _loadUserDetails() async {
    final userDoc = await _firestore.collection('users').doc(_user!.uid).get();
    if (userDoc.exists) {
      _userModel = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      _userRole = _userModel?.role.toString();
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _user = null;
    _userModel = null;
    _userRole = null;
    notifyListeners();
  }
}

class DrawerManager extends StatelessWidget {
  const DrawerManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderDrawer>(context, listen: true);
    final authRepository = AuthRepository();
    final user = authRepository.getCurrentUser();

    return Consumer<AuthProviderDrawer>(
      builder: (context, authProvider, _) {
        if (!authProvider.isLoggedIn) {
          return const CommonDrawer();
        } else {
          return FutureBuilder<String?>(
            future: authRepository.getUserRole(user!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const CommonDrawer();
              } else if (!snapshot.hasData) {
                return const CommonDrawer();
              } else {
                final userRole = snapshot.data;
                switch (userRole) {
                  case 'teacher':
                    return const TeacherDrawer();
                  case 'admin':
                    return const AdminDrawer();
                  case 'student':
                  default:
                    return const CommonUserDrawer();
                }
              }
            },
          );
        }
      },
    );
  }
}
