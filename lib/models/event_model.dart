import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String education;
  final String educator;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final double? price;

  Event({
    required this.id,
    required this.education,
    required this.educator,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.price,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Event(
      id: data['id'],
      education: data['education'],
      educator: data['educator'],
      date: (data['date'] as Timestamp).toDate(),
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      price: data['price'],
    );
  }
}

Future<List<Event>> fetchEvents() async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('events').get();
  return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
}
