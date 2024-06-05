import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tobetoapp/models/blog_model.dart';

class BlogRepository {
  final FirebaseFirestore _firestore;

  BlogRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<dynamic> fetchBlogs({String? blogID}) async {
    try {
      if (blogID != null) {
        DocumentSnapshot snapshot = await _firestore.collection('blogs').doc(blogID).get();
        return Blog.fromDocument(snapshot);
      } else {
        QuerySnapshot snapshot = await _firestore.collection('blogs').orderBy('publishedDate', descending: true).get();
        return snapshot.docs.map((doc) => Blog.fromDocument(doc)).toList();
      }
    } catch (e) {
      throw Exception('Failed to fetch blogs: $e');
    }
  }
}
