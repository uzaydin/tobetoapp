import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tobetoapp/models/userModel.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails(String uid) async {
    try {
      final snapshot = await _firestore.collection('users').doc(uid).get();
      if (snapshot.exists) {
        print("User document found: ${snapshot.data()}");
        return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      print("Error getting user details: $e");
      rethrow;
    }
  }
}