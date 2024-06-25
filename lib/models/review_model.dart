import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String catalogId;
  final String userId;
  final String comment;
  final int rating;
  final DateTime date;

  Review({
    required this.catalogId,
    required this.userId,
    required this.comment,
    required this.rating,
    required this.date,
  });

  factory Review.fromMap(Map<String, dynamic> data) {
    return Review(
      catalogId: data['catalogId'] ?? '',
      userId: data['userId'] ?? '',
      comment: data['comment'] ?? '',
      rating: data['rating'] ?? 0,
      date: (data['date'] as Timestamp).toDate(), 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'catalogId': catalogId,
      'userId': userId,
      'comment': comment,
      'rating': rating,
      'date': date,
    };
  }
}
