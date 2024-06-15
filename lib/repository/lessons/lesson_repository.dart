import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tobetoapp/models/lesson_model.dart';
import 'package:tobetoapp/models/userModel.dart';

/* class LessonRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<LessonModel>> getLessons(List<String>? classIds) async {
    try {
      final snapshot = await _firestore
          .collection('lessons')
          .where('classIds', arrayContainsAny: classIds)
          .get();
      if (snapshot.docs.isEmpty) {
        return [];
      }
      return snapshot.docs
          .map((doc) => LessonModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error getting lessons: $e');
    }
  }

  Future<LessonModel> getLessonById(String lessonId) async {
    try {
      final doc = await _firestore.collection('lessons').doc(lessonId).get();
      if (doc.exists) {
        print('Lesson found: ${doc.data()}'); // Hata ayıklama mesajı
        return LessonModel.fromMap(doc.data()!);
      } else {
        print('Lesson not found: $lessonId'); // Hata ayıklama mesajı
        throw Exception('Lesson not found');
      }
    } catch (e) {
      print('Error getting lesson: $e'); // Hata ayıklama mesajı
      throw Exception('Error getting lesson: $e');
    }
  }

  Stream<List<LessonModel>> getLiveLessonsStream(List<String>? classIds) {
    return _firestore
        .collection('lessons')
        .where('classIds', arrayContainsAny: classIds)
        .where('isLive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                LessonModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> addLesson(LessonModel lesson) async {
    DocumentReference docRef =
        await _firestore.collection('lessons').add(lesson.toMap());
    await docRef.update({'id': docRef.id});
  }

  Future<void> deleteLesson(String id) async {
    await _firestore.collection('lessons').doc(id).delete();
  }
} */

class LessonRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<LessonModel>> getLessons(List<String>? classIds) async {
    try {
      final snapshot = await _firestore
          .collection('lessons')
          .where('classIds', arrayContainsAny: classIds)
          .get();
      if (snapshot.docs.isEmpty) {
        return [];
      }
      return snapshot.docs
          .map((doc) => LessonModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error getting lessons: $e');
    }
  }

  Future<LessonModel> getLessonById(String lessonId) async {
    try {
      final doc = await _firestore.collection('lessons').doc(lessonId).get();
      if (doc.exists) {
        print('Lesson found: ${doc.data()}'); // Hata ayıklama mesajı
        return LessonModel.fromMap(doc.data()!);
      } else {
        print('Lesson not found: $lessonId'); // Hata ayıklama mesajı
        throw Exception('Lesson not found');
      }
    } catch (e) {
      print('Error getting lesson: $e'); // Hata ayıklama mesajı
      throw Exception('Error getting lesson: $e');
    }
  }

  Future<void> addLesson(LessonModel lesson) async {
    DocumentReference docRef =
        await _firestore.collection('lessons').add(lesson.toMap());
    await docRef.update({'id': docRef.id});
  }

  Future<void> deleteLesson(String id) async {
    await _firestore.collection('lessons').doc(id).delete();
  }

  Future<List<LessonModel>> getLessonsByTeacherId(String teacherId) async {
    try {
      final snapshot = await _firestore
          .collection('lessons')
          .where('teacherIds', arrayContains: teacherId)
          .where('isLive',
              isEqualTo: true) // eğitmenlere sadece canlı dersler atandığı için
          .get();
      if (snapshot.docs.isEmpty) {
        return [];
      }
      return snapshot.docs
          .map((doc) => LessonModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting lessons by teacher ID: $e');
    }
  }

  Future<Map<String, String>> getTeacherNames(List<String> teacherIds) async {
    try {
      Map<String, String> teacherNames = {};
      for (String teacherId in teacherIds) {
        final teacherSnapshot =
            await _firestore.collection('users').doc(teacherId).get();
        if (teacherSnapshot.exists) {
          final data = teacherSnapshot.data();
          teacherNames[teacherId] =
              '${data?['firstName']} ${data?['lastName']}';
        }
      }
      return teacherNames;
    } catch (e) {
      throw Exception('Error getting teacher names: $e');
    }
  }

  Future<List<UserModel>> fetchStudents(LessonModel lesson) async {
    List<UserModel> students = [];
    final studentSnapshots = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'student')
        .get();

    for (var studentDoc in studentSnapshots.docs) {
      UserModel student = UserModel.fromMap(studentDoc.data());
      if (lesson.classIds != null &&
          lesson.classIds!
              .any((classId) => student.classIds?.contains(classId) ?? false)) {
        students.add(student);
      }
    }
    return students;
  }
}
