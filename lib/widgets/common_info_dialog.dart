import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/models/video_model.dart';

class InfoDialog extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Duration spentTime;
  final int videoCount;

  const InfoDialog({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.spentTime,
    required this.videoCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                'Başlangıç: ${startDate != null ? DateFormat('dd MMM yyyy').format(startDate!) : 'Belirtilmemiş'}',
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
          Row(
            children: [
              const Icon(Icons.calendar_today),
              const SizedBox(width: 8),
              Text(
                'Bitiş: ${endDate != null ? DateFormat('dd MMM yyyy').format(endDate!) : 'Belirtilmemiş'}',
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
          Row(
            children: [
              const Icon(Icons.timer),
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
  }
}

void showCommonInfoDialog(
  BuildContext context,
  List<Video> videos,
  DateTime? startDate,
  DateTime? endDate,
  String title,
) {
  final spentTime = videos.fold(Duration.zero, (sum, video) => sum + (video.spentTime ?? Duration.zero));
  final videoCount = videos.length;

  showDialog(
    context: context,
    builder: (context) {
      return InfoDialog(
        spentTime: spentTime,
        startDate: startDate,
        endDate: endDate,
        videoCount: videoCount,
      );
    },
  );
}
