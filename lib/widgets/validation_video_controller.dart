import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

String? validation(String? value, String errorMessage) {
  if (value == null || value.isEmpty) {
    return errorMessage;
  }
  return null;
}

// Password kontrol fonksiyonu
String? validatePasswordConfirmation(
    String? value, TextEditingController passwordController) {
  if (value == null || value.isEmpty) {
    return "Lütfen bir şifreyi doğrulayın";
  }
  if (value != passwordController.text) {
    return "Şifreler eşleşmiyor";
  }
  return null;
}

class VideoController with ChangeNotifier {
  late VideoPlayerController _controller;
  bool _isFullScreen = false;

  VideoController(String videoAsset) {
    _controller = VideoPlayerController.asset(videoAsset)
      ..initialize().then((_) {
        notifyListeners();
      });
  }

  VideoPlayerController get controller => _controller;
  bool get isInitilized => _controller.value.isInitialized;
  bool get isPlaying => _controller.value.isPlaying;
  bool get isFullScreen => _isFullScreen;

  void playPause() {
    _controller.value.isPlaying ? _controller.pause() : _controller.play();
    notifyListeners();
  }

  void toggleFullScreen() {
    _isFullScreen = !_isFullScreen;
    notifyListeners();
  }

  void toggleVolume() {
    _controller.setVolume(_controller.value.volume > 0 ? 0.0 : 1.0);
    notifyListeners();
  }

  String get durationString {
    final duration = _controller.value.duration;
    return _formatDuration(duration);
  }

  String get positionString {
    final position = _controller.value.position;
    return _formatDuration(position);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$minutes:$seconds';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
