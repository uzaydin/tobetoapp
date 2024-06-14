import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tobetoapp/models/question.dart';

class ExamRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ExamRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<List<Question>> loadQuestions(String subject) async {
    QuerySnapshot snapshot = await _firestore
        .collection('questions')
        .doc(subject)
        .collection('questions')
        .get();

    return snapshot.docs.map((doc) => Question.fromDocument(doc)).toList();
  }

  Future<void> saveResult({
    required String subject,
    required int correctAnswers,
    required int wrongAnswers,
    required int score,
  }) async {
    String userId = _auth.currentUser!.uid;
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('results')
        .doc(subject)
        .set({
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'score': score,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot> fetchResults(String subject) async {
    String userId = _auth.currentUser!.uid;
    return await _firestore
        .collection('users')
        .doc(userId)
        .collection('results')
        .doc(subject)
        .get();
  }

  Future<bool> hasCompletedExam(String subject) async {
    String userId = _auth.currentUser!.uid;
    var doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('results')
        .doc(subject)
        .get();
    return doc.exists;
  }
}
