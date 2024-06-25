import 'package:cloud_firestore/cloud_firestore.dart';

class EducatorService {
  final CollectionReference _educatorsCollection =
      FirebaseFirestore.instance.collection('educators');

  Future<List<String>> getEducators() async {
    List<String> educators = [];

    try {
      QuerySnapshot querySnapshot = await _educatorsCollection.get();
      querySnapshot.docs.forEach((doc) {
        educators.add(doc['name']);
      });
    } catch (e) {
      print("Hata: $e");
    }
    return educators;
  }
}
