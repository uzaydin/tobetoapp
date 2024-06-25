
import 'package:tobetoapp/models/announcement_model.dart';

import 'package:tobetoapp/models/user_enum.dart';

abstract class AnnouncementEvent {}

class LoadAnnouncements extends AnnouncementEvent {
  final List<String>? classIds;
  final UserRole? role;

  LoadAnnouncements(this.classIds, this.role);
}

class AddAnnouncement extends AnnouncementEvent {
  final Announcements announcement;

  AddAnnouncement(this.announcement);
}

class DeleteAnnouncement extends AnnouncementEvent {
  final List<String>? classIds;
  final String id;
  final UserRole role;

  DeleteAnnouncement(this.classIds, this.id, this.role);
}

class AnnouncementsUpdated extends AnnouncementEvent {
  final List<Announcements> announcements;

  AnnouncementsUpdated(this.announcements);
}
