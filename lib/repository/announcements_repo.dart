import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tobetoapp/models/announcement_model.dart';


class AnnouncementRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAnnouncement(Announcements announcement) async {
    DocumentReference docRef =
        await _firestore.collection('announcements').add(announcement.toMap());
    // id'yi belgeden alarak güncelleyin
    await docRef.update({'id': docRef.id});
  }

  Future<void> deleteAnnouncement(String id) async {
    await _firestore.collection('announcements').doc(id).delete();
  }

  // Duyuruları admin,öğretmen,ogrencı rolune göre  ayrı sınıflara  fıltrelıyoruz!
   Future<List<Announcements>> getAnnouncements(List<String>? classIds, String? role) async {
    try {
      QuerySnapshot snapshot;
      if (role == 'admin') {
        snapshot = await _firestore
            .collection('announcements')
            .orderBy('createdAt', descending: true) // En son eklenen duyurunun en üstte gözükmesi
            .get();
      } else if (classIds != null && classIds.isNotEmpty) {
        snapshot = await _firestore
            .collection('announcements')
            .where('classIds', arrayContainsAny: classIds)
            .orderBy('createdAt', descending: true) // En son eklenen duyurunun en üstte gözükmesi
            .get();
      } else {
        return [];
      }

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Announcements.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching announcements: $e');
    }
  }
}

