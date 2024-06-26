import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/repository/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<FetchUserDetails>(_onFetchUserDetails);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<AddCertificate>(_onAddCertificate);
    on<RemoveCertificate>(_onRemoveCertificate);
    on<ViewCertificate>(_onViewCertificate);
    on<PickCertificate>(_onPickCertificate);
    on<PickImage>(_onPickImage);
    on<ChangePassword>(_onChangePassword);
    on<DeleteAccount>(_onDeleteAccount);
  }

  void _onFetchUserDetails(
      FetchUserDetails event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final user = await profileRepository.getCurrentUserDetails();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void _onUpdateUserProfile(
      UpdateUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      await profileRepository.updateUserProfile(event.user);
      final updatedUser = await profileRepository.getCurrentUserDetails();
      emit(ProfileLoaded(updatedUser));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onPickImage(PickImage event, Emitter<ProfileState> emit) async {
    try {
      final url = await profileRepository.pickAndUploadProfileImage();
      if (url != null) {
        final user = await profileRepository.getCurrentUserDetails();
        emit(ProfileImageUpdated(user.copyWith(profilePhotoUrl: url), url));
        emit(ProfileLoaded(user.copyWith(profilePhotoUrl: url)));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void _onAddCertificate(
      AddCertificate event, Emitter<ProfileState> emit) async {
    try {
      await profileRepository.addCertificate(event.certificate, event.file);
      final updatedUser = await profileRepository.getCurrentUserDetails();
      emit(ProfileLoaded(updatedUser));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void _onRemoveCertificate(
      RemoveCertificate event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      await profileRepository.removeCertificate(
          event.certificateId, event.fileUrl);
      final updatedUser = await profileRepository.getCurrentUserDetails();
      emit(ProfileLoaded(updatedUser));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void _onViewCertificate(
      ViewCertificate event, Emitter<ProfileState> emit) async {
    try {
      await profileRepository.viewCertificate(event.url);
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void _onPickCertificate(
      PickCertificate event, Emitter<ProfileState> emit) async {
    try {
      final result = await profileRepository.pickCertificate();
      if (result != null) {
        final user = await profileRepository.getCurrentUserDetails();
        emit(CertificatePicked(user, result['file'], result['extension']));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void _onChangePassword(
      ChangePassword event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      await profileRepository.changePassword(
          event.oldPassword, event.newPassword);
      final user = await profileRepository.getCurrentUserDetails();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void _onDeleteAccount(DeleteAccount event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      await profileRepository.deleteAccount(event.currentPassword);
      emit(ProfileDeleted());
    } catch (e) {
      emit(ProfileError('Hesap silme hatası: ${e.toString()}'));
    }
  }
}
