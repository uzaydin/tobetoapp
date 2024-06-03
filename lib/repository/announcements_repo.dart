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


    // Duyuruları admin rolune ayrı ve sınıflara gore fıltrelıyoruz!
  Stream<List<Announcements>> getAnnouncementsStream(
      List<String>? classIds, String? role) {
    if (role == 'admin') {
      return _firestore.collection('announcements').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return Announcements.fromMap(data);
        }).toList();
      });
    } else if (classIds != null && classIds.isNotEmpty) {
      return _firestore
          .collection('announcements')
          .where('classIds', arrayContainsAny: classIds)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return Announcements.fromMap(data);
        }).toList();
      });
    } else {
      return Stream.value([]);
    }
  }
}

