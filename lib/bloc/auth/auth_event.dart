// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthEvent {}

class AuthLogin extends AuthEvent {
  String email;
  String password;
  AuthLogin({
    required this.email,
    required this.password,
  });
}

class AuthSignUp extends AuthEvent {
  String name;
  String lastName;
  String email;
  String password;
  AuthSignUp({
    required this.name,
    required this.lastName,
    required this.email,
    required this.password,
  });
}

class AuthGoogleSignIn extends AuthEvent {}

class AuthStateChanged extends AuthEvent {
  final User? user;
  final String? role;

  AuthStateChanged({required this.user, required this.role});
}

class AuthCheckStatus extends AuthEvent {}

class AuthPasswordReset extends AuthEvent{
  final String email;

  AuthPasswordReset(this.email);
}

class AuthLogOut extends AuthEvent {}