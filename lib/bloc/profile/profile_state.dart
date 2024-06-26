import 'dart:io';
import 'package:tobetoapp/models/user_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;

  ProfileLoaded(this.user);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class CertificatePicked extends ProfileState {
  final UserModel user;
  final File file;
  final String extension;

  CertificatePicked(this.user, this.file, this.extension);
}

class ProfileImageUpdated extends ProfileState {
  final UserModel user;
  final String imageUrl;

  ProfileImageUpdated(this.user, this.imageUrl);
}
