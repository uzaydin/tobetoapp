import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tobetoapp/models/news_model.dart';

class NewsRepository {
  final FirebaseFirestore _firestore;

  NewsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<dynamic> fetchNews({String? newsID}) async {
    try {
      if (newsID != null) {
        DocumentSnapshot snapshot = await _firestore.collection('news').doc(newsID).get();
        return News.fromDocument(snapshot);
      } else {
        QuerySnapshot snapshot = await _firestore.collection('news').orderBy('publishedDate', descending: true).get();
        return snapshot.docs.map((doc) => News.fromDocument(doc)).toList();
      }
    } catch (e) {
      throw Exception('Failed to fetch news: $e');
    }
  }
}