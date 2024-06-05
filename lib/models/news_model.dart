import 'package:cloud_firestore/cloud_firestore.dart';

class News {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime publishedDate;

  News({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.publishedDate,
  });

  factory News.fromDocument(DocumentSnapshot doc) {
    return News(
      id: doc ['id'],
      title: doc['title'],
      description: doc['description'],
      imageUrl: doc['imageUrl'],
      publishedDate: (doc['publishedDate'] as Timestamp).toDate(),
    );
  }
}
