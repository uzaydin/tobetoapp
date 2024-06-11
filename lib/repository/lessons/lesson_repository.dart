import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tobetoapp/models/lesson_model.dart';

class LessonRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<LessonModel>> getLessons(List<String>? classIds) async {
    try {
      final snapshot = await _firestore
          .collection('lessons')
          .where('classIds', arrayContainsAny: classIds)
          .get();
      if (snapshot.docs.isEmpty) {
        return [];
      }
      return snapshot.docs
          .map((doc) => LessonModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error getting lessons: $e');
    }
  }

  Future<LessonModel> getLessonById(String lessonId) async {
    try {
      final doc = await _firestore.collection('lessons').doc(lessonId).get();
      if (doc.exists) {
        print('Lesson found: ${doc.data()}'); // Hata ayıklama mesajı
        return LessonModel.fromMap(doc.data()!);
      } else {
        print('Lesson not found: $lessonId'); // Hata ayıklama mesajı
        throw Exception('Lesson not found');
      }
    } catch (e) {
      print('Error getting lesson: $e'); // Hata ayıklama mesajı
      throw Exception('Error getting lesson: $e');
    }
  }

  Stream<List<LessonModel>> getLiveLessonsStream(List<String>? classIds) {
    return _firestore
        .collection('lessons')
        .where('classIds', arrayContainsAny: classIds)
        .where('isLive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                LessonModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> addLesson(LessonModel lesson) async {
    DocumentReference docRef =
        await _firestore.collection('lessons').add(lesson.toMap());
    await docRef.update({'id': docRef.id});
  }

  Future<void> deleteLesson(String id) async {
    await _firestore.collection('lessons').doc(id).delete();
  }
}
