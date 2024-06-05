import 'package:cloud_firestore/cloud_firestore.dart';

class Blog {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime publishedDate;

  Blog({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.publishedDate,
  });

  factory Blog.fromDocument(DocumentSnapshot doc) {
    return Blog(
      id: doc ['id'],
      title: doc['title'],
      description: doc['description'],
      imageUrl: doc['imageUrl'],
      publishedDate: (doc['publishedDate'] as Timestamp).toDate(),
    );
  }
}
