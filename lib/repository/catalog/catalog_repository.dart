import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tobetoapp/models/catalog_model.dart';

class CatalogRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<CatalogModel>> getCatalog(catalogId) async {
    final querySnapshot = await _firebaseFirestore.collection('catalog').get();
    List<CatalogModel> lessonCatalog = querySnapshot.docs.map((doc) => CatalogModel.fromFirestore(doc)).toList();
    return lessonCatalog;
  }

  Future<List<String>> _fetchDistinctFieldValues(String field) async {
    final QuerySnapshot querySnapshot = await _firebaseFirestore.collection('catalog').get();
    return querySnapshot.docs
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return data != null ? data[field] as String? : null;
        })
        .where((value) => value != null)
        .map((value) => value!)
        .toSet()
        .toList();
  }

  Future<CatalogModel> getCatalogById(String catalogId) async {
    
      final doc = await _firebaseFirestore.collection('catalog').doc(catalogId).get();
      if (doc.exists) {
        return CatalogModel.fromMap(doc.data()!);
      } else {
        throw Exception();
      }
    } 

  Future<List<bool>> fetchFreeCourses() async {
    final QuerySnapshot querySnapshot = await _firebaseFirestore.collection('catalog').get();
    return querySnapshot.docs
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return data != null ? data['isFree'] as bool? ?? false : false;
        })
        .toList();
  }

  Future<List<String>> fetchCategories() async => _fetchDistinctFieldValues('category');
  Future<List<String>> fetchLevels() async => _fetchDistinctFieldValues('level');
  Future<List<String>> fetchSubjects() async => _fetchDistinctFieldValues('subject');
  Future<List<String>> fetchLanguages() async => _fetchDistinctFieldValues('language');
  Future<List<String>> fetchInstructors() async => _fetchDistinctFieldValues('instructor');
  Future<List<String>> fetchCertificationStatuses() async => _fetchDistinctFieldValues('certificationStatus');

    Future<void> addCatalog(CatalogModel catalog) async {
    DocumentReference docRef =
        await _firebaseFirestore.collection('catalog').add(catalog.toMap());
    await docRef.update({'catalogId': docRef.id});
  }

  Future<void> deleteCatalog(String id) async {
    await _firebaseFirestore.collection('catalog').doc(id).delete();
  }
  Future<void> updateCatalog(CatalogModel catalog) async {
    try {
      await _firebaseFirestore
          .collection('catalog')
          .doc(catalog.catalogId)
          .update(catalog.toMap());
    } catch (e) {
      throw Exception('Error updating lesson: $e');
    }
  }

  Future<String> uploadCatalogImage(String catalogId, XFile imageFile) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('catalog_images/$catalogId');
      final uploadTask = ref.putFile(File(imageFile.path));
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}

