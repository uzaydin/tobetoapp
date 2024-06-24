import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tobetoapp/models/catalog_model.dart';

class CatalogVideoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Video>> getVideos(List<String> videoIds) async {
    try {
      final snapshot = await _firestore
          .collection('videos')
          .where('id', whereIn: videoIds)
          .get();

      return snapshot.docs
          .map((doc) => Video.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching videos: $e');
    }
  }

 Future<Map<String, dynamic>> getUserVideoStatuses(String userId, String catalogId, List<String> videoIds) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('catalog')
          .doc(catalogId)
          .collection('videos')
          .where('videoId', whereIn: videoIds)
          .get();

      return {
        for (var doc in snapshot.docs)
          doc.data()['videoId']: {
            'isCompleted': doc.data()['isCompleted'],
            'spentTime': Duration(seconds: doc.data()['spentTime']),
          }
      };
    } catch (e) {
      throw Exception('Error fetching user video statuses: $e');
    }
  }

  Future<void> updateVideoStatus(String userId, String catalogId, String videoId,
      bool isCompleted, Duration spentTime) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('catalog')
          .doc(catalogId)
          .collection('videos')
          .doc(videoId);

      await docRef.set(
          {
            'isCompleted': isCompleted,
            'videoId': videoId,
            'spentTime': spentTime.inSeconds,
          },
          SetOptions(
              merge:
                  true));
    } catch (e) {
      throw Exception('Error updating video status: $e');
    }
  }
 }