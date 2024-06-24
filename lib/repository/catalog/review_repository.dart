import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tobetoapp/models/review_model.dart';

class ReviewsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Review>> getReviewsForLesson(String catalogId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('reviews')
          .where('catalogId', isEqualTo: catalogId)
          .get();
      return snapshot.docs
          .map((doc) => Review.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching reviews: $e');
    }
  }

  Future<void> addReview(Review review) async {
    try {
      await _firestore.collection('reviews').add(review.toMap());
    } catch (e) {
      throw Exception('Error adding review: $e');
    }
  }

  Future<void> updateReview(String documentId, Review review) async {
    try {
      await _firestore.collection('reviews').doc(documentId).update(review.toMap());
    } catch (e) {
      throw Exception('Error updating review: $e');
    }
  }
}
