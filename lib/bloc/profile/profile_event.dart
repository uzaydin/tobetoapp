import 'dart:io';

import 'package:tobetoapp/models/userModel.dart';

abstract class ProfileEvent {}

class FetchUserDetails extends ProfileEvent {}

class UpdateUserProfile extends ProfileEvent {
  final UserModel user;

  UpdateUserProfile(this.user);
}

class PickImage extends ProfileEvent {}

class AddCertificate extends ProfileEvent {
  final Certificate certificate;
  final File file;

  AddCertificate(this.certificate, this.file);
}

class RemoveCertificate extends ProfileEvent {
  final String certificateId;
  final String fileUrl; // Add the file URL to the event

  RemoveCertificate(this.certificateId, this.fileUrl);
}

class ViewCertificate extends ProfileEvent {
  final String url;

  ViewCertificate(this.url);
}

class PickCertificate extends ProfileEvent {}
