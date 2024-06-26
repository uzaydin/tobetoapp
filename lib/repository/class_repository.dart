import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tobetoapp/models/class_model.dart';

class ClassRepository {
  final FirebaseFirestore _firestore;

  ClassRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<ClassModel>> getClassesStream() {
    return _firestore.collection('classes').snapshots().map((snapshot) {
      // Future kullanilabilir.
      return snapshot.docs.map((doc) {
        return ClassModel.fromMap(doc.data());
      }).toList();
    }).handleError((error) {
      throw error;
    });
  }

  Future<List<ClassModel>> getClasses() async {
    try {
      final snapshot = await _firestore.collection('classes').get();
      //print('Fetched classes from Firestore: ${snapshot.docs.length}');
      return snapshot.docs.map((doc) {
        return ClassModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (error) {
      throw error;
    }
  }

  // Admin usermanagement sinif IDlerinin isimlerini alma
  Future<Map<String, String>> getClassNames() async {
    try {
      final snapshot = await _firestore.collection('classes').get();
      Map<String, String> classNames = {};
      for (var doc in snapshot.docs) {
        classNames[doc.id] = doc.data()['name'] ?? 'Unknown';
      }
      return classNames;
    } catch (error) {
      throw error;
    }
  }

  Future<ClassModel> getClassDetails(String classId) async {
    try {
      final doc = await _firestore.collection('classes').doc(classId).get();
      return ClassModel.fromMap(doc.data()!);
    } catch (error) {
      throw error;
    }
  }

  Future<void> addClass(ClassModel newClass) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('classes').add(newClass.toMap());
      await docRef.update(
          {'id': docRef.id}); // Belgeye otomatik oluşturulan ID'yi ekleyin
    } catch (e) {
      throw Exception('Error adding class: $e');
    }
  }

  Future<void> updateClass(ClassModel updatedClass) async {
    try {
      await _firestore
          .collection('classes')
          .doc(updatedClass.id)
          .update(updatedClass.toMap());
    } catch (e) {
      throw Exception('Error updating classes: $e');
    }
  }

  Future<void> deleteClass(String classId) {
    return _firestore
        .collection('classes')
        .doc(classId)
        .delete()
        .catchError((error) {
      throw error;
    });
  }
}
