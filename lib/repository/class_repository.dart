import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tobetoapp/models/class_model.dart';

class ClassRepository {
  final FirebaseFirestore _firestore;

  ClassRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<ClassModel>> getClassesStream() {
    return _firestore.collection('classes').snapshots().map((snapshot) {
      print('Fetched classes from Firestore: ${snapshot.docs.length}');
      return snapshot.docs.map((doc) {
        print('Class doc data: ${doc.data()}');
        return ClassModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    }).handleError((error) {
      print('Error in getClassesStream: $error');
      throw error;
    });
  }

  Future<void> addClass(ClassModel classModel) {
    return _firestore.collection('classes').doc(classModel.id).set(classModel.toMap()).catchError((error) {
      print('Error in addClass: $error');
      throw error;
    });
  }

  Future<void> deleteClass(String id) {
    return _firestore.collection('classes').doc(id).delete().catchError((error) {
      print('Error in deleteClass: $error');
      throw error;
    });
  }
}