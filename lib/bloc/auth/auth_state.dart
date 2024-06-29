// ignore_for_file: public_member_api_docs, sort_constructors_first.dart';

abstract class AuthState {}

class AuthAppStarted extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String? id;
  final String? role;
  AuthSuccess({
    required this.id,
    required this.role,
  });
}

class Unauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure({
    required this.message,
  });
}
