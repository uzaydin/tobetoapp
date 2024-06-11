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
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'description': description,
      'classIds': classIds,
      'startDate': startDate?.toUtc(), // Convert to UTC
      'endDate': endDate?.toUtc(), // Convert to UTC
      'videoIds': videoIds,
      'estimatedTime': estimatedTime?.inSeconds,

      'isLive': isLive,
      'teacherIds': teacherIds,
      'homeworkIds': homeworkIds,
      'progress': progress,
    };
  }

  factory LessonModel.fromMap(Map<String, dynamic> map) {
    return LessonModel(
      id: map['id'] as String?,
      title: map['title'] as String?,
      image: map['image'] as String?,
      description: map['description'] as String?,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory LessonModel.fromJson(String source) =>
      LessonModel.fromMap(json.decode(source));
}

class HomeworkModel {
  String? id;
  String? title;
  String? description;
  List<String>? attachedFiles;
  String? assignedBy;
  List<String>? studentSubmissions;
  DateTime? dueDate;

  HomeworkModel({
    this.id,
    this.title,
    this.description,
    this.attachedFiles,
    this.assignedBy,
    this.studentSubmissions,
    this.dueDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'attachedFiles': attachedFiles,
      'assignedBy': assignedBy,
      'studentSubmissions': studentSubmissions,
      'dueDate': dueDate?.millisecondsSinceEpoch,
    };
  }

  factory HomeworkModel.fromMap(Map<String, dynamic> map) {
    return HomeworkModel(
      id: map['id'] != null ? map['id'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      attachedFiles: map['attachedFiles'] != null
          ? List<String>.from((map['attachedFiles'] as List<dynamic>))
          : null,
      assignedBy:
          map['assignedBy'] != null ? map['assignedBy'] as String : null,
      studentSubmissions: map['studentSubmissions'] != null
          ? List<String>.from((map['studentSubmissions'] as List<dynamic>))
          : null,
      dueDate: map['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dueDate'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeworkModel.fromJson(String source) =>
      HomeworkModel.fromMap(json.decode(source) as Map<String, dynamic>);
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