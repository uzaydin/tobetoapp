import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tobetoapp/models/lesson_model.dart';

class LessonLiveRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<LiveSessionModel>> fetchLiveSessions(
      List<String> sessionIds) async {
    try {
      List<LiveSessionModel> liveSessions = [];
      for (String sessionId in sessionIds) {
        final sessionSnapshot =
            await _firestore.collection('liveSessions').doc(sessionId).get();
        if (sessionSnapshot.exists) {
          liveSessions.add(
              LiveSessionModel.fromMap(sessionSnapshot.data()!, sessionId));
        }
      }
      return liveSessions;
    } catch (e) {
      throw Exception('Error fetching live sessions: $e');
    }
  }
}
