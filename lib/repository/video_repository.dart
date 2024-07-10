import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tobetoapp/models/video_model.dart';

class VideoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Video>> getVideos(List<String> videoIds) async {
    try {
      final snapshot = await _firestore
          .collection('videos')
          .where('id', whereIn: videoIds)
          .get();

      return snapshot.docs.map((doc) => Video.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Error fetching videos: $e');
    }
  }

  Future<Map<String, dynamic>> getUserVideoStatuses(String userId, String videoId, List<String> videoIds) {
    return _getUserVideoStatuses(userId, 'userLessons/$videoId/videos', videoIds);
  }

  Future<Map<String, dynamic>> _getUserVideoStatuses(String userId, String docPath, List<String> videoIds) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection(docPath)
          .where('videoId', whereIn: videoIds)
          .get();

      return {
        for (var doc in snapshot.docs)
          doc.data()['videoId']: {
            'isCompleted': doc.data()['isCompleted'],
            'spentTime': Duration(seconds: doc.data()['spentTime']),
          }
      };
    } catch (e) {
      throw Exception('Error fetching user video statuses: $e');
    }
  }

  Future<void> updateVideoStatus(String userId, String videoIds, String videoId,
      bool isCompleted, Duration spentTime) {
    return _updateVideoStatus(userId, 'userLessons/$videoIds/videos', videoId, isCompleted, spentTime);
  }

  Future<void> _updateVideoStatus(String userId, String docPath, String videoId,
      bool isCompleted, Duration spentTime) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection(docPath)
          .doc(videoId);

      await docRef.set(
        {
          'isCompleted': isCompleted,
          'videoId': videoId,
          'spentTime': spentTime.inSeconds,
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('Error updating video status: $e');
    }
  }
}
