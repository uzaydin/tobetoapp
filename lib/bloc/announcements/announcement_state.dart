// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:tobetoapp/models/announcement_model.dart';

class AnnouncementState {}

class AnnouncementsLoading extends AnnouncementState {}

class AnnouncementsLoaded extends AnnouncementState {
  final List<Announcements> announcements;

  AnnouncementsLoaded(this.announcements);
}

class AnnouncementOperationSuccess extends AnnouncementState {}

class AnnouncementOperationFailure extends AnnouncementState {
  final String error;

  AnnouncementOperationFailure(this.error);
}
