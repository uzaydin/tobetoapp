// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:tobetoapp/models/lesson_model_yagmur.dart';

// class LessonRepository {
//   late List<Lesson> lessons;
//   late List<Lesson> userLessons;
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

//   Future<List<Lesson>> getLessonsByCategory() async {
//     try {
//       final querySnapshot = await _firebaseFirestore
//           .collection('lessons')
//           .orderBy(FieldPath.documentId, descending: true)
//           .get();

//       lessons = _mapLessons(querySnapshot);
//       return lessons;
//     } catch (error) {
//       _handleError(error);
//       return [];
//     }
//   }

//   Future<List<Lesson>> getLessons(List<String> userLessonList) async {
//     try {
//       if (userLessonList.isEmpty) {
//         return [];
//       }

//       final querySnapshot = await _firebaseFirestore
//           .collection('lessons') 
//           .where(FieldPath.documentId, whereIn: userLessonList)
//           .get();

//       userLessons = _mapLessons(querySnapshot);
//       return userLessons;
//     } catch (error) {
//       _handleError(error);
//       return [];
//     }
//   }

//   List<Lesson> _mapLessons(QuerySnapshot snapshot) {
//     return snapshot.docs.map((doc) => Lesson.fromFirestore(doc)).toList();
//   }

//   void _handleError(error) {
//     if (error is FirebaseException) {
//       String? errorMessage = error.message;
//       throw Exception(errorMessage);
//     } else {
//       throw Exception(error.toString());
//     }
//   }
// }
