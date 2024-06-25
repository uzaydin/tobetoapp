import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class CatalogModel {
  final String? catalogId;
  final String? title;
  final String? instructor;
  final String? category;
  final String? level;
  final String? subject;
  final String? language;
  final String? certificationStatus;
  final String? imageUrl;
  final double? rating;
  final bool? isFree;
  final String? content;
  final String? instructorInfo;
  List<String>? videoIds;
  Duration? estimatedTime;
  double? progress;
  DateTime? startDate;
  DateTime? endDate;

  CatalogModel({
    this.catalogId,
    this.title,
    this.instructor,
    this.category,
    this.level,
    this.subject,
    this.language,
    this.certificationStatus,
    this.imageUrl,
    this.rating,
    this.isFree,
    this.content,
    this.instructorInfo,
    this.videoIds,
    this.estimatedTime,
    this.progress = 0.0,
    this.startDate,
    this.endDate,
  });

  factory CatalogModel.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CatalogModel(
      catalogId: data['catalogId'] ?? '',
      title: data['title'] ?? '',
      instructor: data['instructor'] ?? '',
      category: data['category'] ?? '',
      level: data['level'] ?? '',
      subject: data['subject'] ?? '',
      language: data['language'] ?? '',
      certificationStatus: data['certificationStatus'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      rating: (data['rating'] is int) ? (data['rating'] as int).toDouble() : (data['rating'] as double?) ?? 0.0,
      isFree: data['isFree'] ?? false,
      content: data['content'] ?? '',
      instructorInfo: data['instructorInfo'] ?? '',
      videoIds: data['videoIds'] != null ? List<String>.from(data['videoIds']) : null,
      estimatedTime: data['estimatedTime'] != null ? Duration(seconds: data['estimatedTime']) : null,
      progress: data['progress'] != null ? data['progress'].toDouble() : 0.0,
      startDate: data['startDate'] != null
          ? (data['startDate'] as Timestamp).toDate()
          : null,
      endDate: data['endDate'] != null
          ? (data['endDate'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'catalogId': catalogId,
      'title': title,
      'instructor': instructor,
      'category': category,
      'level': level,
      'subject': subject,
      'language': language,
      'certificationStatus': certificationStatus,
      'imageUrl': imageUrl,
      'rating': rating,
      'isFree': isFree,
      'content': content,
      'instructorInfo': instructorInfo,
      'videoIds': videoIds,
      'estimatedTime': estimatedTime?.inSeconds,
      'progress': progress,
      'startDate': startDate?.toUtc(),
      'endDate': endDate?.toUtc(),
    };
  }

  factory CatalogModel.fromMap(Map<String, dynamic> map) {
    return CatalogModel(
      catalogId: map['catalogId'],
      title: map['title'],
      instructor: map['instructor'],
      category: map['category'],
      level: map['level'],
      subject: map['subject'],
      language: map['language'],
      certificationStatus: map['certificationStatus'],
      imageUrl: map['imageUrl'],
      rating: (map['rating'] is int) ? (map['rating'] as int).toDouble() : (map['rating'] as double?) ?? 0.0,
      isFree: map['isFree'],
      content: map['content'],
      instructorInfo: map['instructorInfo'],
      videoIds: map['videoIds'] != null ? List<String>.from(map['videoIds']) : null,
      estimatedTime: map['estimatedTime'] != null ? Duration(seconds: map['estimatedTime']) : null,
      progress: map['progress'] != null ? map['progress'].toDouble() : 0.0,
      startDate: (map['startDate'] as Timestamp?)?.toDate(),
      endDate: (map['endDate'] as Timestamp?)?.toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CatalogModel.fromJson(String source) => CatalogModel.fromMap(json.decode(source));
}

class Video {
  final String id;
  final String? videoTitle;
  final String? link;
  final Duration? duration;
  final Duration? spentTime;
  final bool? isCompleted;

  Video({
    required this.id,
    this.videoTitle,
    this.link,
    this.duration,
    this.spentTime,
    this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'videoTitle': videoTitle,
      'link': link,
      'duration': duration?.inMilliseconds,
      'spentTime': spentTime?.inSeconds,
      'isCompleted': isCompleted,
    };
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      id: map['id'],
      videoTitle: map['videoTitle'],
      link: map['link'],
      duration: map['duration'] != null ? Duration(milliseconds: map['duration']) : null,
      spentTime: map['spentTime'] != null ? Duration(seconds: map['spentTime']) : null,
      isCompleted: map['isCompleted'],
    );
  }

  Video copyWith({
    String? id,
    String? videoTitle,
    String? link,
    Duration? duration,
    Duration? spentTime,
    bool? isCompleted,
  }) {
    return Video(
      id: id ?? this.id,
      videoTitle: videoTitle ?? this.videoTitle,
      link: link ?? this.link,
      duration: duration ?? this.duration,
      spentTime: spentTime ?? this.spentTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
