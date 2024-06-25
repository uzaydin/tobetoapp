import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SamplePlayer extends StatefulWidget {
  final String videoUrl;
  final Function onVideoComplete;
  final Function(Duration) onTimeUpdate;

  const SamplePlayer({
    super.key,
    required this.videoUrl,
    required this.onVideoComplete,
    required this.onTimeUpdate,
  });

  @override
  _SamplePlayerState createState() => _SamplePlayerState();
}

class _SamplePlayerState extends State<SamplePlayer> {
  late FlickManager flickManager;
  Duration _lastReportedPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      ),
      autoPlay: false,
    );
    flickManager.flickVideoManager!.videoPlayerController!
        .addListener(_videoListener);
  }

  void _videoListener() {
    final controller = flickManager.flickVideoManager!.videoPlayerController!;
    if (controller.value.position == controller.value.duration) {
      widget.onVideoComplete();
    }

    // Her bir saniye geçtiğinde `onTimeUpdate` fonksiyonunu çağır
    if (controller.value.position - _lastReportedPosition >= const Duration(seconds: 1)) {
      _lastReportedPosition = controller.value.position;
      widget.onTimeUpdate(_lastReportedPosition);
    }
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlickVideoPlayer(flickManager: flickManager);
  }
}