import 'package:cloud_firestore/cloud_firestore.dart';

class StudentCommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getStudentComments() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('studentComments').get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
