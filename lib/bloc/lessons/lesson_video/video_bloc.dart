import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/lessons/lesson_video/video_event.dart';
import 'package:tobetoapp/bloc/lessons/lesson_video/video_state.dart';
import 'package:tobetoapp/repository/lessons/lesson_video_repository.dart';


class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final VideoRepository _videoRepository;

  VideoBloc(this._videoRepository) : super(VideosLoading()) {
    on<LoadVideos>(_loadVideos);
    //on<UploadVideo>(_uploadVideo);
    on<UpdateVideo>(_updateVideo);
  }

  Future<void> _loadVideos(LoadVideos event, Emitter<VideoState> emit) async {
    emit(VideosLoading());
    try {
      final videos = await _videoRepository.getVideos(event.videoIds);
      emit(VideosLoaded(videos));
    } catch (e) {
      emit(VideoOperationFailure(e.toString()));
    }
  }

  // Future<void> _uploadVideo(UploadVideo event, Emitter<VideoState> emit) async {
  //   try {
  //     await _videoRepository.uploadVideo(event.video, event.filePath);
  //     final videos = await _videoRepository.getVideos(event.videoIds);
  //     emit(VideosLoaded(videos));
  //   } catch (e) {
  //     emit(VideoOperationFailure(e.toString()));
  //   }
  // }



   Future<void> _updateVideo(UpdateVideo event, Emitter<VideoState> emit) async {
    try {
      await _videoRepository.updateVideo(event.video);
      final videos = await _videoRepository.getVideos([event.video.id!]);
      emit(VideosLoaded(videos));
    } catch (e) {
      emit(VideoOperationFailure(e.toString()));
    }
  }

  void _onVideosUpdated(VideosUpdated event, Emitter<VideoState> emit) {
    emit(VideosLoaded(event.videos));
  }
}
