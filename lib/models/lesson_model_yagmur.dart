// import 'package:cloud_firestore/cloud_firestore.dart';

// class Lesson {
//   String id;
//   String title;
//   String imageUrl;
//   double rating;
//   String category;
//   String level;
//   String topic;
//   String language;
//   String instructor;
//   bool hasCertificate;
//   bool hasPrice;

//   Lesson({
//     required this.id,
//     required this.title,
//     required this.imageUrl,
//     required this.rating,
//     required this.category,
//     required this.level,
//     required this.topic,
//     required this.language,
//     required this.instructor,
//     required this.hasCertificate,
//     required this.hasPrice,
//   });

//   factory Lesson.fromFirestore(DocumentSnapshot doc) {
//     final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     return Lesson(
//       id: doc.id,
//       title: data['title'] ?? '',
//       imageUrl: data['imageUrl'] ?? '',
//       rating: (data['rating'] ?? 0.0).toDouble(),
//       category: data['category'] ?? '',
//       level: data['level'] ?? '',
//       topic: data['topic'] ?? '',
//       language: data['language'] ?? '',
//       instructor: data['instructor'] ?? '',
//       hasCertificate: data['hasCertificate'] ?? false,
//       hasPrice: data['hasPrice'] ?? false,
//     );
//   }
// }
