import 'package:cloud_firestore/cloud_firestore.dart';

class Catalog {
  final String id;
  final String title;
  final String instructor;
  final String category;
  final String level;
  final String subject;
  final String language;
  final String certificationStatus;
  final String imageUrl;
  final double rating;
  final bool isFree;

  Catalog({
    required this.id,
    required this.title,
    required this.instructor,
    required this.category,
    required this.level,
    required this.subject,
    required this.language,
    required this.certificationStatus,
    required this.imageUrl,
    required this.rating,
    required this.isFree,
  });

factory Catalog.fromFirestore(DocumentSnapshot doc) {
  final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  return Catalog(
    id: data['id'] ?? '',
    title: data['title'] ?? '',
    instructor: data['instructor'] ?? '',
    category: data['category'] ?? '',
    level: data['level'] ?? '',
    subject: data['subject'] ?? '',
    language: data['language'] ?? '',
    certificationStatus: data['certificationStatus'] ?? '',
    imageUrl: data['imageUrl'] ?? '', 
    rating: data['rating'] ?? 0.0,
    isFree: data['isFree'] ?? false,
  );
}
}

// import 'package:cloud_firestore/cloud_firestore.dart';

// class Catalog {
//   List<String> id;
//   List<String> title;
//   List<String> instructor;
//   List<String> category;
//   List<String> level;
//   List<String> subject;
//   List<String> language;
//   List<String> certificationStatus;
//   List<String> imageUrl;
//   List<double> rating;
//   List<bool> isFree;

//   Catalog({
//     required this.id,
//     required this.title,
//     required this.instructor,
//     required this.category,
//     required this.level,
//     required this.subject,
//     required this.language,
//     required this.certificationStatus,
//     required this.imageUrl,
//     required this.rating,
//     required this.isFree,
//   });

//   factory Catalog.fromFirestore(DocumentSnapshot doc) {
//     final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     return Catalog(
//       id: List<String>.from(data['id'] ?? []),
//       title: List<String>.from(data['title'] ?? []),
//       instructor: List<String>.from(data['instructor'] ?? []),
//       category: List<String>.from(data['category'] ?? []),
//       level: List<String>.from(data['level'] ?? []),
//       subject: List<String>.from(data['subject'] ?? []),
//       language: List<String>.from(data['language'] ?? []),
//       certificationStatus: List<String>.from(data['certificationStatus'] ?? []),
//       imageUrl: List<String>.from(data['imageUrl'] ?? []),
//       rating: List<double>.from(data['rating']?.map((x) => x.toDouble()) ?? []),
//       isFree: List<bool>.from(data['isFree'] ?? []),
//     );
//   }
// }

