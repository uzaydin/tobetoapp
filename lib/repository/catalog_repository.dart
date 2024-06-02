import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tobetoapp/models/catalog_model.dart';

// class CatalogRepository {
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

// Future<List<String>> fetchSubjects() async {
//   final QuerySnapshot result = await _firebaseFirestore.collection('subjects').get();
//   return result.docs.map((doc) => doc['name'] as String).toList();
// }

// Future<List<String>> fetchLanguages() async {
//   final QuerySnapshot result = await _firebaseFirestore.collection('languages').get();
//   return result.docs.map((doc) => doc['name'] as String).toList();
// }

// Future<List<String>> fetchInstructors() async {
//   final QuerySnapshot result = await _firebaseFirestore.collection('instructors').get();
//   return result.docs.map((doc) => doc['name'] as String).toList();
// }

// Future<List<String>> fetchCertificationStatuses() async {
//   final QuerySnapshot result = await _firebaseFirestore.collection('certificationStatuses').get();
//   return result.docs.map((doc) => doc['name'] as String).toList();
// }

// Future<List<String>> fetchFreeCourses() async {
//   final QuerySnapshot result = await _firebaseFirestore.collection('courses').where('isFree', isEqualTo: false).get();
//   return result.docs.map((doc) => doc['name'] as String).toList();
// }
// }

import 'package:tobetoapp/services/firebase_firestore_services.dart';

class CatalogRepository {
  final FirebaseFirestoreService _firebaseFirestoreService = FirebaseFirestoreService();

  Future<List<Catalog>> getCatalog() async {
  final querySnapshot =
      await FirebaseFirestore.instance.collection('catalog').get();
  List<Catalog> catalog = querySnapshot.docs.map((doc) => Catalog.fromMap(doc.data())).toList();
  return catalog;
  }

  Future<List<String>> fetchCategories() async {
    return await _firebaseFirestoreService.fetchCategories();
  }

  Future<List<String>> fetchLevels() async {
    return await _firebaseFirestoreService.fetchLevels();
  }

  Future<List<String>> fetchSubjects() async {
    return await _firebaseFirestoreService.fetchSubjects();
  }

  Future<List<String>> fetchLanguages() async {
    return await _firebaseFirestoreService.fetchLanguages();
  }

  Future<List<String>> fetchInstructors() async {
    return await _firebaseFirestoreService.fetchInstructors();
  }

  Future<List<String>> fetchCertificationStatuses() async {
    return await _firebaseFirestoreService.fetchCertificationStatuses();
  }

  Future<List<String>> fetchFreeCourses() async {
    return await _firebaseFirestoreService.fetchFreeCourses();
  }
}
