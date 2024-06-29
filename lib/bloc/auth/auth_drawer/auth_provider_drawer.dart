import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tobetoapp/models/user_model.dart';

import 'package:tobetoapp/repository/user_repository.dart';

class AuthProviderDrawer extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserRepository _userRepository = UserRepository();

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
      await _loadUserDetails();
    }
    notifyListeners();
  }

  Future<void> _loadUserDetails() async {
    try {
      _userModel = await _userRepository.getUserDetails(_user!.uid);
    } catch (e) {
      print('Error loading user details: $e');
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
