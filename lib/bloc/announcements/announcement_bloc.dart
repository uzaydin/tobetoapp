import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tobetoapp/bloc/announcements/announcement_event.dart';
import 'package:tobetoapp/bloc/announcements/announcement_state.dart';
import 'package:tobetoapp/models/announcement_model.dart';
import 'package:tobetoapp/models/class_model.dart';
import 'package:tobetoapp/models/user_enum.dart';
import 'package:tobetoapp/repository/announcements_repo.dart';

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  final AnnouncementRepository _announcementRepository;
  StreamSubscription<List<Announcements>>? _announcementsSubscription;

  AnnouncementBloc(this._announcementRepository)
      : super(AnnouncementsLoading()) {
    on<LoadAnnouncements>(_loadAnnouncements);
    on<AddAnnouncement>(_addAnnouncement);
    on<DeleteAnnouncement>(_deleteAnnouncement);
    on<AnnouncementsUpdated>(_onAnnouncementsUpdated);
  }

  Future<void> _loadAnnouncements(
      LoadAnnouncements event, Emitter<AnnouncementState> emit) async {
    emit(AnnouncementsLoading());
    if ((event.classModels == null || event.classModels!.isEmpty) &&
        event.role != UserRole.admin) {
      emit(AnnouncementsLoaded(
          [])); // Class ID null ve admin değilse duyurular sayfasında boş liste döndürüyoruz.
      return;
    }
    await _announcementsSubscription?.cancel();
    _announcementsSubscription = _announcementRepository
        .getAnnouncementsStream(
      event.classModels?.map((e) => e.id!).toList(),
      event.role?.toString().split('.').last,
    )
        .listen(
      (announcements) {
        add(AnnouncementsUpdated(announcements));
      },
      onError: (error) {
        emit(AnnouncementOperationFailure(error.toString()));
      },
    );
  }

  void _onAnnouncementsUpdated(
      AnnouncementsUpdated event, Emitter<AnnouncementState> emit) {
    emit(AnnouncementsLoaded(event.announcements));
  }

  Future<void> _addAnnouncement(
      AddAnnouncement event, Emitter<AnnouncementState> emit) async {
    try {
      // Duyuru oluşturulmadan önce classIds'nin boş olmadığından emin olun
      assert(
        event.announcement.classIds != null &&
            event.announcement.classIds!.isNotEmpty,
      );
      await _announcementRepository.addAnnouncement(event.announcement);

      // Burada classIds'yi classModels listesine dönüştürüyoruz
      List<ClassModel> classModels = [];
      if (event.announcement.classIds != null) {
        classModels = event.announcement.classIds!
            .map((id) => ClassModel(id: id))
            .toList();
      }

      // role alanını UserRole tipine dönüştürüyoruz
      UserRole? role;
      if (event.announcement.role != null) {
        role = UserRole.values.firstWhere(
            (e) => e.toString() == 'UserRole.' + event.announcement.role!);
      }

      add(LoadAnnouncements(classModels, role));
    } catch (e) {
      emit(AnnouncementOperationFailure(e.toString()));
    }
  }

  Future<void> _deleteAnnouncement(
      DeleteAnnouncement event, Emitter<AnnouncementState> emit) async {
    try {
      await _announcementRepository.deleteAnnouncement(event.id);
      add(LoadAnnouncements(event.classId, event.role));
    } catch (e) {
      emit(AnnouncementOperationFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _announcementsSubscription?.cancel();
    return super.close();
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
