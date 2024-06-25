import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tobetoapp/models/competency_test_question.dart';

class CompetencyTestRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CompetencyTestRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<List<CompetencyQuestion>> fetchQuestions() async {
    var snapshot = await _firestore
        .collection('questions')
        .doc('Tobeto İşte Başarı Modeli')
        .collection('questionsList')
        .get();

    return snapshot.docs
        .map((doc) => CompetencyQuestion.fromMap(doc.data()))
        .toList();
  }

  Future<void> saveResult(Map<String, double> scores) async {
    var userId = _auth.currentUser!.uid;
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('results')
        .doc('Tobeto İşte Başarı Modeli')
        .set({
      'scores': scores,
      'completionDate': FieldValue.serverTimestamp(),
    });
  }

  Future<CompetencyTestResult?> getResult() async {
    var userId = _auth.currentUser!.uid;
    var snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('results')
        .doc('Tobeto İşte Başarı Modeli')
        .get();

    if (snapshot.exists) {
      return CompetencyTestResult.fromMap(snapshot.data()!);
    }
    return null;
  }
}
