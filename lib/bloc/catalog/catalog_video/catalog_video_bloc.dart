import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/catalog/catalog_video/catalog_video_event.dart';
import 'package:tobetoapp/bloc/catalog/catalog_video/catalog_video_state.dart';
import 'package:tobetoapp/repository/catalog/catalog_video_repository.dart';

class CatalogVideoBloc extends Bloc<CatalogVideoEvent, CatalogVideoState> {
  final CatalogVideoRepository _catalogVideoRepository;

  CatalogVideoBloc(this._catalogVideoRepository) : super(VideosLoading()) {
    on<LoadVideos>(_loadVideos);
    on<UpdateUserVideo>(_updateUserVideo);
    on<VideoSelected>(_videoSelected);
    on<UpdateSpentTime>(_updateSpentTime); 
  }

  Future<void> _loadVideos(LoadVideos event, Emitter<CatalogVideoState> emit) async {
    emit(VideosLoading());
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final videos = await _catalogVideoRepository.getVideos(event.videoIds);
        final userVideoStatuses = await _catalogVideoRepository.getUserVideoStatuses(userId, event.catalogId, event.videoIds);
        final videosWithStatus = videos.map((video) {
          final isCompleted = userVideoStatuses[video.id]?['isCompleted'] ?? false;
          final spentTime = userVideoStatuses[video.id]?['spentTime'] ?? Duration.zero;
          return video.copyWith(isCompleted: isCompleted, spentTime: spentTime);
        }).toList();
        emit(VideosLoaded(videosWithStatus));
      } else {
        emit(VideoOperationFailure(error: 'User not logged in'));
      }
    } catch (e) {
      emit(VideoOperationFailure(error: e.toString()));
    }
  }

  Future<void> _updateUserVideo(UpdateUserVideo event, Emitter<CatalogVideoState> emit) async {
    emit(VideoUpdating());
    try {
      await _catalogVideoRepository.updateVideoStatus(event.userId, event.catalogId, event.video.id, true, event.video.spentTime ?? Duration.zero);
      final videos = await _catalogVideoRepository.getVideos(event.videoIds);
      final userVideoStatuses = await _catalogVideoRepository.getUserVideoStatuses(event.userId, event.catalogId, event.videoIds);
      final videosWithStatus = videos.map((video) {
        final isCompleted = userVideoStatuses[video.id]?['isCompleted'] ?? false;
        final spentTime = userVideoStatuses[video.id]?['spentTime'] ?? Duration.zero;
        return video.copyWith(isCompleted: isCompleted, spentTime: spentTime);
      }).toList();
      emit(VideosLoaded(videosWithStatus));
    } catch (e) {
      emit(VideoOperationFailure(error: e.toString()));
    }
  }

  Future<void> _updateSpentTime(UpdateSpentTime event, Emitter<CatalogVideoState> emit) async {
    try {
      await _catalogVideoRepository.updateVideoStatus(event.userId, event.catalogId, event.videoId!, false, event.spentTime);
      final videos = await _catalogVideoRepository.getVideos(event.videoIds);
      final userVideoStatuses = await _catalogVideoRepository.getUserVideoStatuses(event.userId, event.catalogId, event.videoIds);
      final videosWithStatus = videos.map((video) {
        final isCompleted = userVideoStatuses[video.id]?['isCompleted'] ?? false;
        final spentTime = userVideoStatuses[video.id]?['spentTime'] ?? Duration.zero;
        return video.copyWith(isCompleted: isCompleted, spentTime: spentTime);
      }).toList();
      emit(VideosLoaded(videosWithStatus));
    } catch (e) {
      emit(VideoOperationFailure(error: e.toString()));
    }
  }

  Future<void> _videoSelected(VideoSelected event, Emitter<CatalogVideoState> emit) async {
    final userId = _getUserId();
    if (userId != null) {
      add(UpdateUserVideo(
        userId: userId,
        catalogId: event.catalogId,
        video: event.video,
        videoIds: event.videoIds,
      ));
    }
  }

  String? _getUserId() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return userId;
  }
}
