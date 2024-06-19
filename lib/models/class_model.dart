// ignore_for_file: public_member_api_docs, sort_constructors_first
class ClassModel {
  String? id;
  String? name;

  ClassModel({this.id, this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      id: map['id'] as String?,
      name: map['name'] as String?,
    );
  }

  ClassModel copyWith({
    String? id,
    String? name,
  }) {
    return ClassModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
