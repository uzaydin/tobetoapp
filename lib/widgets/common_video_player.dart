import 'package:flutter/material.dart';
import 'package:tobetoapp/widgets/sample_player.dart';

class CommonVideoPlayer extends StatelessWidget {
  final String? videoUrl;
  final Function() onVideoComplete;
  final Function(Duration) onTimeUpdate;

  const CommonVideoPlayer({
    Key? key,
    this.videoUrl,
    required this.onVideoComplete,
    required this.onTimeUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return videoUrl != null
        ? SamplePlayer(
            key: ValueKey(videoUrl),
            videoUrl: videoUrl!,
            onVideoComplete: onVideoComplete,
            onTimeUpdate: onTimeUpdate,
          )
        : Container();
  }
}
