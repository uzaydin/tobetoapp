// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class LessonModel {
  String? id;
  String? title;
  String? image;
  String? description;
  String? category;
  List<String>? classIds;
  DateTime? startDate;
  DateTime? endDate;
  List<String>? videoIds;
  Duration? estimatedTime;

  bool? isLive; // canli ders ise true olacak ve yonlendirme yapicak.
  List<String>?
      teacherIds; // Öğretmenlerin ID'leri dersler ID lere gore fıltrelenecek!
  List<String>? homeworkIds; // Ödevlerin ID'leri
  double? progress;
  List<String>? liveSessions;

  LessonModel({
    this.id,
    this.title,
    this.image,
    this.description,
    this.category,
    this.classIds,
    this.startDate,
    this.endDate,
    this.videoIds,
    this.estimatedTime,
    this.isLive,
    this.teacherIds,
    this.homeworkIds,
    this.progress = 0.0,
    this.liveSessions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'description': description,
      'category': category,
      'classIds': classIds,
      'startDate': startDate?.toUtc(), // Convert to UTC
      'endDate': endDate?.toUtc(), // Convert to UTC
      'videoIds': videoIds,
      'estimatedTime': estimatedTime?.inSeconds,

      'isLive': isLive,
      'teacherIds': teacherIds,
      'homeworkIds': homeworkIds,
      'progress': progress,
      'liveSessions': liveSessions,
    };
  }

  factory LessonModel.fromMap(Map<String, dynamic> map) {
    return LessonModel(
      id: map['id'] as String?,
      title: map['title'] as String?,
      image: map['image'] as String?,
      description: map['description'] as String?,
      category: map['category'] as String?,
      classIds:
          map['classIds'] != null ? List<String>.from(map['classIds']) : null,
      startDate: (map['startDate'] as Timestamp?)?.toDate(),
      endDate: (map['endDate'] as Timestamp?)?.toDate(),
      videoIds:
          map['videoIds'] != null ? List<String>.from(map['videoIds']) : null,
      estimatedTime: map['estimatedTime'] != null
          ? Duration(seconds: map['estimatedTime'])
          : null,
      isLive: map['isLive'] as bool?,
      teacherIds: map['teacherIds'] != null
          ? List<String>.from((map['teacherIds'] as List<dynamic>))
          : null,
      homeworkIds: map['homeworkIds'] != null
          ? List<String>.from((map['homeworkIds'] as List<dynamic>))
          : null,
      progress: map['progress'] != null ? map['progress'].toDouble() : 0.0,
      liveSessions: List<String>.from(map['liveSessions'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory LessonModel.fromJson(String source) =>
      LessonModel.fromMap(json.decode(source));

  LessonModel copyWith({
    String? id,
    String? title,
    String? image,
    String? description,
    String? category,
    List<String>? classIds,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? videoIds,
    Duration? estimatedTime,
    bool? isLive,
    List<String>? teacherIds,
    List<String>? homeworkIds,
    double? progress,
    List<String>? liveSessions,
  }) {
    return LessonModel(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      description: description ?? this.description,
      category: category ?? this.category,
      classIds: classIds ?? this.classIds,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      videoIds: videoIds ?? this.videoIds,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      isLive: isLive ?? this.isLive,
      teacherIds: teacherIds ?? this.teacherIds,
      homeworkIds: homeworkIds ?? this.homeworkIds,
      progress: progress ?? this.progress,
      liveSessions: liveSessions ?? this.liveSessions,
    );
  }
}

class HomeworkModel {
  String? lessonId;
  String? id;
  String? title;
  String? description;
  List<String>? attachedFiles;
  String? assignedBy;
  List<Map<String, dynamic>>? studentSubmissions;
  DateTime? assignedDate;
  DateTime? dueDate;

  HomeworkModel({
    this.lessonId,
    this.id,
    this.title,
    this.description,
    this.attachedFiles,
    this.assignedBy,
    this.studentSubmissions,
    this.assignedDate,
    this.dueDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'lessonId': lessonId,
      'id': id,
      'title': title,
      'description': description,
      'attachedFiles': attachedFiles,
      'assignedBy': assignedBy,
      'studentSubmissions': studentSubmissions,
      'assignedDate': assignedDate?.toUtc(),
      'dueDate': dueDate?.toUtc(),
    };
  }

  factory HomeworkModel.fromMap(Map<String, dynamic> map, String documentId) {
    return HomeworkModel(
      lessonId: map['lessonId'],
      id: documentId,
      title: map['title'],
      description: map['description'],
      attachedFiles: List<String>.from(map['attachedFiles'] ?? []),
      assignedBy: map['assignedBy'],
      studentSubmissions: (map['studentSubmissions'] as List<dynamic>?)
          ?.map((e) => Map<String, dynamic>.from(e))
          .toList(),
      assignedDate:
          map['assignedDate'] != null && map['assignedDate'] is Timestamp
              ? (map['assignedDate'] as Timestamp).toDate().toUtc()
              : null,
      dueDate: map['dueDate'] != null && map['dueDate'] is Timestamp
          ? (map['dueDate'] as Timestamp).toDate().toUtc()
          : null,
    );
  }
}

class Video {
  String id;
  String? videoTitle;
  String? link;
  Duration? duration;
  Duration? spentTime;
  bool? isCompleted;
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
      duration: map['duration'] != null
          ? Duration(milliseconds: map['duration'])
          : null,
      isCompleted: map['isCompleted'],
      spentTime:
          map['spentTime'] != null ? Duration(seconds: map['spentTime']) : null,
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
        isCompleted: isCompleted ?? this.isCompleted,
        spentTime: spentTime ?? this.spentTime);
  }
}

class LiveSessionModel {
  String? id;
  String? title;
  DateTime? startDate;
  DateTime? endDate;

  LiveSessionModel({
    this.id,
    this.title,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'startDate': startDate?.toUtc(),
      'endDate': endDate?.toUtc(),
    };
  }

  factory LiveSessionModel.fromMap(
      Map<String, dynamic> map, String documentId) {
    return LiveSessionModel(
      id: documentId,
      title: map['title'],
      startDate: (map['startDate'] as Timestamp).toDate().toUtc(),
      endDate: (map['endDate'] as Timestamp).toDate().toUtc(),
    );
  }
}

/*
 LessonModel({this.id, this.title, this.description, this.videoUrl, this.classIds});



  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'classIds': classIds,
    };
  }

  factory LessonModel.fromMap(Map<String, dynamic> map) {
    return LessonModel(
      id: map['id'] != null ? map['id'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      videoUrl: map['videoUrl'] != null ? map['videoUrl'] as String : null,
      classIds: List<String>.from(map['classIds'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory LessonModel.fromJson(String source) => LessonModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

*/