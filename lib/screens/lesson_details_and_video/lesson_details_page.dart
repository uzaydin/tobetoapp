import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/bloc/auth/auth_bloc.dart';
import 'package:tobetoapp/bloc/favorites/favorite_bloc.dart';
import 'package:tobetoapp/bloc/favorites/favorite_event.dart';
import 'package:tobetoapp/bloc/favorites/favorite_state.dart';
import 'package:tobetoapp/bloc/lessons/lesson_video/video_bloc.dart';
import 'package:tobetoapp/bloc/lessons/lesson_video/video_event.dart';
import 'package:tobetoapp/bloc/lessons/lesson_video/video_state.dart';
import 'package:tobetoapp/models/lesson_model.dart';
import 'package:tobetoapp/screens/lesson_details_and_video/sample_player.dart';
import 'package:tobetoapp/screens/lesson_details_and_video/video_list_widget.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

class LessonDetailsPage extends StatefulWidget {
  final LessonModel lesson;

  const LessonDetailsPage({super.key, required this.lesson});

  @override
  _LessonDetailsPageState createState() => _LessonDetailsPageState();
}

class _LessonDetailsPageState extends State<LessonDetailsPage> {
  String? _currentVideoUrl;
  Video? _currentVideo;
  Duration _totalSpentTime = Duration.zero;
  final Map<String, Duration> _videoSpentTimes = {};

  @override
  void initState() {
    super.initState();
    _loadVideos();
    initializeDateFormatting();
  }

  void _loadVideos() {
    final userId = context.read<AuthBloc>().currentUser?.id;
    if (userId != null) {
      context.read<VideoBloc>().add(
            LoadVideos(
              lessonId: widget.lesson.id!,
              videoIds: widget.lesson.videoIds ?? [],
            ),
          );
    }
  }

  void _onVideoTap(Video video) {
    setState(() {
      _currentVideoUrl = video.link;
      _currentVideo = video;
      _totalSpentTime = _videoSpentTimes[video.id] ?? Duration.zero;
    });
  }

  void _onVideoComplete() {
    if (_currentVideo != null) {
      final userId = context.read<AuthBloc>().currentUser?.id;
      if (userId != null) {
        context.read<VideoBloc>().add(
              UpdateSpentTime(
                userId: userId,
                lessonId: widget.lesson.id!,
                videoId: _currentVideo!.id,
                spentTime: _totalSpentTime,
                videoIds: widget.lesson.videoIds ?? [],
              ),
            );
      }
      context.read<VideoBloc>().add(
            VideoSelected(
              lessonId: widget.lesson.id!,
              video: _currentVideo!,
              videoIds: widget.lesson.videoIds ?? [],
            ),
          );
    }
  }

  void _onTimeUpdate(Duration spentTime) {
    setState(() {
      _totalSpentTime = spentTime;
      if (_currentVideo != null) {
        _videoSpentTimes[_currentVideo!.id] = spentTime;
      }
    });
  }

  double _calculateProgress(List<Video> videos) {
    if (videos.isEmpty) return 0.0;
    final completedVideos = videos.where((video) => video.isCompleted!).length;
    return completedVideos / videos.length;
  }

  Duration _calculateSpentTime(List<Video> videos) {
    return videos.fold(
      Duration.zero,
      (sum, video) => sum + (video.spentTime ?? Duration.zero),
    );
  }

  void _showInfoDialog(BuildContext context, List<Video> videos) {
    final spentTime = _calculateSpentTime(videos);
    final startDate = widget.lesson.startDate;
    final endDate = widget.lesson.endDate;
    final videoCount = videos.length;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Hakkında',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 8),
                  Text(
                    'Başlangıç: ${startDate != null ? DateFormat('dd MMM yyyy').format(startDate) : 'Belirtilmemiş'}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: AppConstants.sizedBoxHeightMedium),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Bitiş: ${endDate != null ? DateFormat('dd MMM yyyy').format(endDate) : 'Belirtilmemiş'}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: AppConstants.sizedBoxHeightMedium),
              Row(
                children: [
                  const Icon(
                    Icons.timer,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Geçirdiğin Süre: ${spentTime.inHours} saat ${spentTime.inMinutes.remainder(60)} dakika',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: AppConstants.sizedBoxHeightMedium),
              Row(
                children: [
                  const Icon(Icons.video_library),
                  const SizedBox(width: 8),
                  Text(
                    'Video: $videoCount',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Kapat', style: TextStyle(color: Colors.blue)),
            ),
          ],
          backgroundColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/logo/tobetologo.PNG",
          width: AppConstants.screenWidth * 0.43,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            Expanded(child: _buildVideoList(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.lesson.title ?? 'Başlık Yok',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Row(
          children: [
            BlocBuilder<FavoritesBloc, FavoritesState>(
              builder: (context, state) {
                if (state is FavoritesLoaded) {
                  final isFavorite =
                      state.favoriteLessonIds.contains(widget.lesson.id);
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                    ),
                    onPressed: () {
                      _toggleFavorite(context, isFavorite);
                    },
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                final videoBloc = context.read<VideoBloc>();
                if (videoBloc.state is VideosLoaded) {
                  final videos = (videoBloc.state as VideosLoaded).videos;
                  _showInfoDialog(context, videos);
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  void _toggleFavorite(BuildContext context, bool isFavorite) {
    if (isFavorite) {
      context
          .read<FavoritesBloc>()
          .add(RemoveFavorite(lessonId: widget.lesson.id!));
    } else {
      context
          .read<FavoritesBloc>()
          .add(AddFavorite(lessonId: widget.lesson.id!));
    }
  }

  Widget _buildVideoList(BuildContext context) {
    return BlocBuilder<VideoBloc, VideoState>(
      builder: (context, state) {
        if (state is VideosLoaded) {
          final progress = _calculateProgress(state.videos) * 100;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressIndicator(progress),
              SizedBox(height: AppConstants.sizedBoxHeightSmall),
              if (_currentVideoUrl != null)
                SamplePlayer(
                  key: ValueKey(_currentVideoUrl),
                  videoUrl: _currentVideoUrl!,
                  onVideoComplete: _onVideoComplete,
                  onTimeUpdate: _onTimeUpdate,
                ),
              SizedBox(height: AppConstants.sizedBoxHeightSmall),
              Expanded(child: VideoListWidget(onVideoTap: _onVideoTap)),
            ],
          );
        } else if (state is VideoOperationFailure) {
          return Center(child: Text('Henüz video tanımlanmamıştır.'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildProgressIndicator(double progress) {
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress == 100 ? Colors.green : Colors.blue,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text('%${progress.toStringAsFixed(0)}'),
      ],
    );
  }
}
