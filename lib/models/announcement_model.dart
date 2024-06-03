import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Announcements {
  String? id;
  String? title;
  String? content;
  List<String>? classIds; // classIds olarak aliyoruz. Admin veya Teacher birden fazla sinifa duyuru ekleyebilir.
  DateTime? createdAt;
  String? role;

  Announcements({
    this.id,
    this.title,
    this.content,
    this.classIds,
    this.createdAt,
    this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'classIds': classIds, // classId yerine classIds
      'createdAt': createdAt?.toIso8601String(),
      'role': role,
    };
  }

  factory Announcements.fromMap(Map<String, dynamic> map) {
    return Announcements(
      id: map['id'] as String?,
      title: map['title'] as String?,
      content: map['content'] as String?,
      classIds: List<String>.from(map['classIds'] ?? []), // classId yerine classIds
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      role: map['role'] as String?,
    );
  }
}
