import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tobetoapp/models/lesson_model.dart';

class HomeworkRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addHomework(HomeworkModel homework) async {
    try {
      final newHomeworkRef = _firestore.collection('homeworks').doc();
      final teacherDoc = await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      final teacherName =
          '${teacherDoc.data()?['firstName']} ${teacherDoc.data()?['lastName']}';

      await newHomeworkRef.set({
        'lessonId': homework.lessonId,
        'title': homework.title,
        'description': homework.description,
        'dueDate': homework.dueDate,
        'assignedDate': FieldValue.serverTimestamp(),
        'assignedBy': teacherName,
      });

      // Update lesson's homeworkIds
      await _firestore.collection('lessons').doc(homework.lessonId).update({
        'homeworkIds': FieldValue.arrayUnion([newHomeworkRef.id])
      });
    } catch (e) {
      throw Exception('Error adding homework: $e');
    }
  }

  Future<void> updateHomework(HomeworkModel homework) async {
    try {
      await _firestore.collection('homeworks').doc(homework.id).update({
        'title': homework.title,
        'description': homework.description,
        'dueDate': homework.dueDate,
      });
    } catch (e) {
      throw Exception('Error updating homework: $e');
    }
  }

  Future<void> deleteHomework(String id, String lessonId) async {
    try {
      // Remove homework from 'homeworks' collection
      await _firestore.collection('homeworks').doc(id).delete();

      // Update lesson's homeworkIds
      await _firestore.collection('lessons').doc(lessonId).update({
        'homeworkIds': FieldValue.arrayRemove([id])
      });
    } catch (e) {
      throw Exception('Error deleting homework: $e');
    }
  }

  Future<List<HomeworkModel>> getHomeworks(String lessonId) async {
    try {
      final snapshot = await _firestore
          .collection('homeworks')
          .where('lessonId', isEqualTo: lessonId)
          .get();
      return snapshot.docs
          .map((doc) => HomeworkModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error getting homeworks: $e');
    }
  }
}
