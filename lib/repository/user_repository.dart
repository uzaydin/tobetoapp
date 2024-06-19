import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
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

  // Admin panel grafik data 
  // PieChart
  Future<Map<String, int>> getClassDistribution() async {
    try {
      final usersSnapshot = await _firestore.collection('users').get();
      final classesSnapshot = await _firestore.collection('classes').get();
      Map<String, String> classNames = {};
      for (var doc in classesSnapshot.docs) {
        classNames[doc.id] = doc.data()['name'] ?? 'Unknown';
      }

      Map<String, int> classCounts = {};
      for (var userDoc in usersSnapshot.docs) {
        var data = userDoc.data();
        List<String> classIds = List<String>.from(data['classIds'] ?? []);
        for (var classId in classIds) {
          String className = classNames[classId] ?? 'Unknown';
          if (!classCounts.containsKey(className)) {
            classCounts[className] = 0;
          }
          classCounts[className] = classCounts[className]! + 1;
        }
      }
      return classCounts;
    } catch (error) {
      rethrow;
    }
  }

  // BarChart
  Future<List<int>> getMonthlyRegistrations() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      List<int> monthlyRegistrations = List<int>.filled(12, 0);
      for (var doc in snapshot.docs) {
        var data = doc.data();
        DateTime registrationDate =
            (data['registrationDate'] as Timestamp).toDate();
        int month = registrationDate.month - 1; // 0-indexed
        monthlyRegistrations[month] += 1;
      }
      return monthlyRegistrations;
    } catch (error) {
      throw error;
    }
  }
  
  // Admin user management islemleri

   Future<List<UserModel>> fetchUsers() async {
  try {
    final querySnapshot = await _firestore.collection('users').get();
    final users = querySnapshot.docs.map((doc) {
      try {
        return UserModel.fromFirestore(doc);
      } catch (e) {
        print('Error parsing user document ${doc.id}: $e');
        return null;
      }
    }).toList();

    // Null değerleri filtrele
    return users.whereType<UserModel>().toList();
  } catch (e) {
    throw Exception('Error getting users: $e');
  }
   }
  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());
    } catch (e) {
      print("Error updating user: $e");
      rethrow;
    }
  }


   Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      print("Error deleting user: $e");
      rethrow;
    }
  }

  // Admin ClassManagement islemleri
  // Sinif id ye gore kisileri getirme
  Future<List<UserModel>> getUsersByClass(String classId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('classIds', arrayContains: classId)
          .get();
      return snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data());
      }).toList();
    } catch (error) {
      throw error;
    }
  }

  // Admin LessonManagement sayfasında öğretmen atama işlemi için 

   Future<List<UserModel>> getTeachers() async {
    try {
      final snapshot = await _firestore.collection('users')
          .where('role', isEqualTo: 'teacher')
          .get();
      return snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
    } catch (error) {
      throw Exception('Error fetching teachers: $error');
    }
  }
}