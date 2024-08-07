import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/videos/videos_event.dart';
import 'package:tobetoapp/bloc/videos/videos_state.dart';
import 'package:tobetoapp/repository/video_repository.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final VideoRepository _videoRepository;

  VideoBloc(this._videoRepository) : super(VideosLoading()) {
    on<LoadVideos>(_loadVideos);
    on<UpdateUserVideo>(_updateUserVideo);
    on<VideoSelected>(_videoSelected);
    on<UpdateSpentTime>(_updateSpentTime); 
    on<VideoCompletedEvent>(_onVideoCompleted);
  }

  Future<void> _loadVideos(LoadVideos event, Emitter<VideoState> emit) async {
    emit(VideosLoading());
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final videos = await _videoRepository.getVideos(event.videoIds);
        final userVideoStatuses = await _videoRepository.getUserVideoStatuses(userId, event.collectionId, event.videoIds);
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

 Future<void> _onVideoCompleted(VideoCompletedEvent event, Emitter<VideoState> emit) async {
    emit(VideoUpdating());
    try {
      await _videoRepository.updateVideoStatus(
        event.userId,
        event.collectionId,
        event.videoId,
        true,
        Duration.zero,
      );

      final videos = await _videoRepository.getVideos([event.videoId]);
      final userVideoStatuses = await _videoRepository.getUserVideoStatuses(
        event.userId,
        event.collectionId,
        [event.videoId],
      );

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

  Future<void> _updateUserVideo(UpdateUserVideo event, Emitter<VideoState> emit) async {
    emit(VideoUpdating());
    try {
      await _videoRepository.updateVideoStatus(event.userId, event.collectionId, event.video.id, true, event.video.spentTime ?? Duration.zero);
      final videos = await _videoRepository.getVideos(event.videoIds);
      final userVideoStatuses = await _videoRepository.getUserVideoStatuses(event.userId, event.collectionId, event.videoIds);
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

  Future<void> _updateSpentTime(UpdateSpentTime event, Emitter<VideoState> emit) async {
    try {
      await _videoRepository.updateVideoStatus(event.userId, event.collectionId, event.videoId, false, event.spentTime);
      final videos = await _videoRepository.getVideos(event.videoIds);
      final userVideoStatuses = await _videoRepository.getUserVideoStatuses(event.userId, event.collectionId, event.videoIds);
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

  Future<void> _videoSelected(VideoSelected event, Emitter<VideoState> emit) async {
    final userId = _getUserId();
    if (userId != null) {
      add(UpdateUserVideo(
        userId: userId,
        collectionId: event.collectionId,
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