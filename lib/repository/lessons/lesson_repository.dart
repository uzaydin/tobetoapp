import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tobetoapp/models/lesson_model.dart';
import 'package:tobetoapp/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
        return LessonModel.fromMap(doc.data()!);
      } else {
        throw Exception('Lesson not found');
      }
    } catch (e) {
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

  Future<void> updateLesson(LessonModel lesson) async {
    try {
      await _firestore
          .collection('lessons')
          .doc(lesson.id)
          .update(lesson.toMap());
    } catch (e) {
      throw Exception('Error updating lesson: $e');
    }
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

  Future<List<UserModel>> getTeacherDetails(LessonModel lesson) async {
    try {
      List<UserModel> teachers = [];
      for (String teacherId in lesson.teacherIds ?? []) {
        final teacherSnapshot =
            await _firestore.collection('users').doc(teacherId).get();
        if (teacherSnapshot.exists) {
          final data = teacherSnapshot.data() as Map<String, dynamic>;
          teachers.add(UserModel.fromMap(data));
        }
      }
      return teachers;
    } catch (e) {
      throw Exception('Error getting teacher details: $e');
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

  // Admin, ClassManagement sayfasinda siniflara ait dersleri filtreleme icin kullaniyoruz
  Future<List<LessonModel>> getLessonsForClass(String classId) async {
    try {
      final snapshot = await _firestore
          .collection('lessons')
          .where('classIds', arrayContains: classId)
          .get();
      if (snapshot.docs.isEmpty) {
        return [];
      }
      return snapshot.docs
          .map((doc) => LessonModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error getting lessons for class: $e');
    }
  }

  Future<List<LessonModel>> getLesson() async {
    // isim degisebilir Lessons yap
    try {
      final snapshot = await _firestore.collection('lessons').get();
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

  // Admin Ders image ekleme
  Future<String> uploadLessonImage(String lessonId, XFile imageFile) async {
    try {
      final ref =
          FirebaseStorage.instance.ref().child('lesson_images/$lessonId');
      final uploadTask = ref.putFile(File(imageFile.path));
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
