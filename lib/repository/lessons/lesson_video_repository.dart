import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tobetoapp/models/lesson_model.dart';

class VideoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Video>> getVideos(List<String> videoIds) async {
    try {
      final snapshot = await _firestore
          .collection('videos')
          .where('id', whereIn: videoIds) // --- otomatik id tanimlandi 
          // 'id'   -- idleri elle girdigimiz icin .where(FieldPath.documentId, whereIn: videoIds) "FieldPath.documentId" calismadi. id otomatik olusuyorsa bu kullanilir!
          .get();
      debugPrint('Fetched ${snapshot.docs.length} videos from Firestore');
      return snapshot.docs
          .map((doc) => Video.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching videos: $e');
      throw e;
    }
  }

   Future<Video?> getVideoByUrl(String videoUrl) async {
    final snapshot = await _firestore.collection('videos')
        .where('link', isEqualTo: videoUrl)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return Video.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Future<void> uploadVideo(Video video, String filePath) async {
  //   try {
  //     // Upload file to Firebase Storage
  //     final ref = _storage.ref().child('videos/${video.id}');
  //     final uploadTask = ref.putFile(File(filePath));
  //     final snapshot = await uploadTask;
  //     final downloadUrl = await snapshot.ref.getDownloadURL();

  //     // Save video details to Firestore
  //     final videoWithUrl = video.copyWith(link: downloadUrl);
  //     await _firestore.collection('videos').doc(video.id).set(videoWithUrl.toMap());
  //   } catch (error) {
  //     print('Error uploading video: $error');
  //     throw error;
  //   }
  // }

  Future<void> updateVideo(Video video) async {
    try {
      await _firestore.collection('videos').doc(video.id).update(video.toMap());
    } catch (error) {
      print('Error updating video: $error');
      throw error;
    }
  }

  // Future<void> addVideo(Video video) async {
  //   try {
  //     await _firestore.collection('videos').add(video.toMap());
  //   } catch (error) {
  //     print('Error adding video: $error');
  //     throw error;
  //   }
  // }

}