import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tobetoapp/bloc/announcements/announcement_event.dart';
import 'package:tobetoapp/bloc/announcements/announcement_state.dart';

import 'package:tobetoapp/models/user_enum.dart';
import 'package:tobetoapp/repository/announcements_repo.dart';

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  final AnnouncementRepository _announcementRepository;

  AnnouncementBloc(this._announcementRepository)
      : super(AnnouncementsLoading()) {
    on<LoadAnnouncements>(_loadAnnouncements);
    on<AddAnnouncement>(_addAnnouncement);
    on<DeleteAnnouncement>(_deleteAnnouncement);
    //on<AnnouncementsUpdated>(_onAnnouncementsUpdated);
  }

  Future<void> _loadAnnouncements(
      LoadAnnouncements event, Emitter<AnnouncementState> emit) async {
    emit(AnnouncementsLoading());
    if ((event.classIds == null || event.classIds!.isEmpty) &&
        event.role != UserRole.admin) {
      emit(AnnouncementsLoaded(
          [])); // Class ID null ve admin değilse duyurular sayfasında boş liste döndürüyoruz.
      return;
    }
    try {
      final announcements = await _announcementRepository.getAnnouncements(
        event.classIds,
        event.role?.toString().split('.').last,
      );
      emit(AnnouncementsLoaded(announcements));
    } catch (e) {
      emit(AnnouncementOperationFailure(e.toString()));
    }
  }

 

  // void _onAnnouncementsUpdated(
  //     AnnouncementsUpdated event, Emitter<AnnouncementState> emit) {
  //   emit(AnnouncementsLoaded(event.announcements));
  // }

  Future<void> _addAnnouncement(
      AddAnnouncement event, Emitter<AnnouncementState> emit) async {
    try {
      // Duyuru oluşturulmadan önce classIds'nin boş olmadığından emin olun
      assert(
        event.announcement.classIds != null &&
            event.announcement.classIds!.isNotEmpty,
      );
      await _announcementRepository.addAnnouncement(event.announcement);

      // role alanını UserRole tipine dönüştürüyoruz
      UserRole? role;
      if (event.announcement.role != null) {
        role = UserRole.values.firstWhere(
            (e) => e.toString() == 'UserRole.${event.announcement.role!}');
      }

      add(LoadAnnouncements(event.announcement.classIds!, role));
    } catch (e) {
      emit(AnnouncementOperationFailure(e.toString()));
    }
  }

  Future<void> _deleteAnnouncement(
      DeleteAnnouncement event, Emitter<AnnouncementState> emit) async {
    try {
      await _announcementRepository.deleteAnnouncement(event.id);
      add(LoadAnnouncements(event.classIds, event.role));
    } catch (e) {
      emit(AnnouncementOperationFailure(e.toString()));
    }
  }
}

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tobeto_app/bloc/announcements/announcement_state.dart';
// import 'package:tobeto_app/bloc/announcements/announcement_event.dart';
// import 'package:tobeto_app/repositories/announcements_repo.dart';

// class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
//   final AnnouncementRepository _announcementRepository;

//   AnnouncementBloc(this._announcementRepository)
//       : super(AnnouncementsLoading()) {
//     on<LoadAnnouncements>(_loadAnnouncements);
//     on<AddAnnouncement>(_addAnnouncement);
//     on<DeleteAnnouncement>(_deleteAnnouncement);
//   }

//   Future<void> _loadAnnouncements(
//       LoadAnnouncements event, Emitter<AnnouncementState> emit) async {
//     emit(AnnouncementsLoading());
//     try {
//       final announcements = await _announcementRepository.getAnnouncements();
//       emit(AnnouncementsLoaded(announcements));
//     } catch (e) {
//       emit(AnnouncementOperationFailure(e.toString()));
//     }
//   }

//   Future<void> _addAnnouncement(
//       AddAnnouncement event, Emitter<AnnouncementState> emit) async {
//     try {
//       await _announcementRepository.addAnnouncement(event.announcement);
//       emit(AnnouncementOperationSuccess());
//       add(LoadAnnouncements()); // Duyuruları yeniden yükle
//     } catch (e) {
//       emit(AnnouncementOperationFailure(e.toString()));
//     }
//   }

//   Future<void> _deleteAnnouncement(
//       DeleteAnnouncement event, Emitter<AnnouncementState> emit) async {
//     try {
//       await _announcementRepository.deleteAnnouncement(event.id);
//       emit(AnnouncementOperationSuccess());
//       add(LoadAnnouncements()); // Duyuruları yeniden yükle
//     } catch (e) {
//       emit(AnnouncementOperationFailure(e.toString()));
//     }
//   }
// }
