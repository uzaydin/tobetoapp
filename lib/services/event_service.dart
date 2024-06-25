import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tobetoapp/models/event_model.dart';

class EventService {
  final CollectionReference _eventsCollection =
      FirebaseFirestore.instance.collection('events');

  Stream<List<Event>> streamEvents() {
    return _eventsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        if (doc['date'] == null ||
            doc['startTime'] == null ||
            doc['endTime'] == null) {
          throw Exception("Gerekli alanlar eksik.");
        }

        Timestamp timestamp = doc['date'] as Timestamp;
        Timestamp startTimestamp = doc['startTime'] as Timestamp;
        Timestamp endTimestamp = doc['endTime'] as Timestamp;

        return Event(
          id: doc.id,
          education: doc['education'] ?? 'Eğitim bilgisi yok',
          educator: doc['educator'] ?? 'Eğitmen bilgisi yok',
          date: timestamp.toDate(),
          startTime: startTimestamp.toDate(),
          endTime: endTimestamp.toDate(),
          price: doc['price'] != null ? (doc['price'] as num).toDouble() : null,
        );
      }).toList();
    });
  }
}
