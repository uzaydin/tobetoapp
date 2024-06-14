import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tobetoapp/models/user_enum.dart';
import 'package:uuid/uuid.dart';

class UserModel {
  String? id;
  String? profilePhotoUrl;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  DateTime? birthDate;
  String? tcNo;
  String? email;
  Gender? gender;
  MilitaryStatus? militaryStatus;
  DisabilityStatus? disabilityStatus;
  String? github;
  String? country;
  String? city;
  String? district;
  String? street;
  String? about;
  List<Experience>? experiences;
  List<Education>? education;
  List<UserSkill>? skills;
  List<Certificate>? certificates;
  List<Community>? communities;
  List<ProjectAwards>? projectsAwards;
  List<SocialMedia>? socialMedia;
  List<Languages>? languages;
  UserRole? role;
  List<String>? classIds; // Kullanıcının bir veya birden fazla sınıfı olabilir.

  UserModel({
    this.id,
    this.profilePhotoUrl,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.birthDate,
    this.tcNo,
    this.email,
    this.gender,
    this.militaryStatus,
    this.disabilityStatus,
    this.github,
    this.country,
    this.city,
    this.district,
    this.street,
    this.about,
    this.experiences,
    this.education,
    this.skills,
    this.certificates,
    this.communities,
    this.projectsAwards,
    this.socialMedia,
    this.languages,
    this.role,
    this.classIds,
  });

  String getProfilePhotoUrl() {
    return profilePhotoUrl ??
        'https://tobeto.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fimages.19a45d39.png&w=384&q=75';
  }

  UserModel copyWith({
    String? id,
    String? profilePhotoUrl,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    DateTime? birthDate,
    String? tcNo,
    String? email,
    Gender? gender,
    MilitaryStatus? militaryStatus,
    DisabilityStatus? disabilityStatus,
    String? github,
    String? country,
    String? city,
    String? district,
    String? street,
    String? about,
    List<Experience>? experiences,
    List<Education>? education,
    List<UserSkill>? skills,
    List<Certificate>? certificates,
    List<Community>? communities,
    List<ProjectAwards>? projectsAwards,
    List<SocialMedia>? socialMedia,
    List<Languages>? languages,
    List<String>? classIds,
    UserRole? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      birthDate: birthDate ?? this.birthDate,
      tcNo: tcNo ?? this.tcNo,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      militaryStatus: militaryStatus ?? this.militaryStatus,
      disabilityStatus: disabilityStatus ?? this.disabilityStatus,
      github: github ?? this.github,
      country: country ?? this.country,
      city: city ?? this.city,
      district: district ?? this.district,
      street: street ?? this.street,
      about: about ?? this.about,
      experiences: experiences ?? this.experiences,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      certificates: certificates ?? this.certificates,
      communities: communities ?? this.communities,
      projectsAwards: projectsAwards ?? this.projectsAwards,
      socialMedia: socialMedia ?? this.socialMedia,
      languages: languages ?? this.languages,
      classIds: classIds ?? this.classIds,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profilePhotoUrl': profilePhotoUrl,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate?.toIso8601String(),
      'tcNo': tcNo,
      'email': email,
      'gender': gender?.name,
      'militaryStatus': militaryStatus?.name,
      'disabilityStatus': disabilityStatus?.name,
      'github': github,
      'country': country,
      'city': city,
      'district': district,
      'street': street,
      'about': about,
      'experiences': experiences?.map((e) => e.toMap()).toList(),
      'education': education?.map((e) => e.toMap()).toList(),
      'skills': skills?.map((e) => e.toMap()).toList(),
      'certificates': certificates?.map((e) => e.toMap()).toList(),
      'communities': communities?.map((e) => e.toMap()).toList(),
      'projectsAwards': projectsAwards?.map((e) => e.toMap()).toList(),
      'socialMedia': socialMedia?.map((item) => item.toMap()).toList(),
      'languages': languages?.map((item) => item.toMap()).toList(),
      'classIds': classIds,
      'role': role?.name,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String?,
      profilePhotoUrl: map['profilePhotoUrl'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
      birthDate: map['birthDate'] != null
          ? (map['birthDate'] is Timestamp
              ? (map['birthDate'] as Timestamp).toDate()
              : DateTime.parse(map['birthDate']))
          : null,
      tcNo: map['tcNo'],
      email: map['email'],
      gender: map['gender'] != null
          ? GenderExtension.fromName(map['gender'])
          : null,
      militaryStatus: map['militaryStatus'] != null
          ? MilitaryStatusExtension.fromName(map['militaryStatus'])
          : null,
      disabilityStatus: map['disabilityStatus'] != null
          ? DisabilityStatusExtension.fromName(map['disabilityStatus'])
          : null,
      github: map['github'],
      country: map['country'],
      city: map['city'],
      district: map['district'],
      street: map['street'],
      about: map['about'],
      experiences: map['experiences'] != null
          ? (map['experiences'] as List)
              .map((item) => Experience.fromMap(item))
              .toList()
          : null,
      education: map['education'] != null
          ? (map['education'] as List)
              .map((item) => Education.fromMap(item))
              .toList()
          : null,
      skills: (map['skills'] as List<dynamic>?)
          ?.map((e) => UserSkill.fromMap(e as Map<String, dynamic>))
          .toList(),
      certificates: (map['certificates'] as List<dynamic>?)
          ?.map((e) => Certificate.fromMap(e as Map<String, dynamic>))
          .toList(),
      communities: (map['communities'] as List<dynamic>?)
          ?.map((e) => Community.fromMap(e as Map<String, dynamic>))
          .toList(),
      projectsAwards: (map['projectsAwards'] as List<dynamic>?)
          ?.map((e) => ProjectAwards.fromMap(e as Map<String, dynamic>))
          .toList(),
      socialMedia: map['socialMedia'] != null
          ? List<SocialMedia>.from(map['socialMedia'].map(
              (item) => SocialMedia.fromMap(Map<String, dynamic>.from(item))))
          : null,
      languages: map['languages'] != null
          ? List<Languages>.from(map['languages'].map(
              (item) => Languages.fromMap(Map<String, dynamic>.from(item))))
          : null,
      classIds:
          map['classIds'] != null ? List<String>.from(map['classIds']) : [],
      role:
          map['role'] != null ? UserRoleExtension.fromName(map['role']) : null,
    );
  }
}

class Experience {
  String id;
  String? institution;
  String? position;
  ExperienceType? experienceType;
  String? sector;
  String? city;
  DateTime? startDate;
  DateTime? endDate;
  String? description;

  Experience({
    String? id,
    this.institution,
    this.position,
    this.experienceType,
    this.sector,
    this.city,
    this.startDate,
    this.endDate,
    this.description,
  }) : id = id ?? Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'institution': institution,
      'position': position,
      'experienceType': experienceType?.name,
      'sector': sector,
      'city': city,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'description': description,
    };
  }

  factory Experience.fromMap(Map<String, dynamic> map) {
    return Experience(
      id: map['id'],
      institution: map['institution'],
      position: map['position'],
      experienceType: map['experienceType'] != null
          ? ExperienceTypeExtension.fromName(map['experienceType'])
          : null,
      sector: map['sector'],
      city: map['city'],
      startDate:
          map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      description: map['description'],
    );
  }
}

class Education {
  String id;
  EducationStatus? degree;
  String? university;
  String? department;
  DateTime? startDate;
  DateTime? graduationYear;

  Education({
    String? id,
    this.degree,
    this.university,
    this.department,
    this.startDate,
    this.graduationYear,
  }) : id = id ?? Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'degree': degree?.name,
      'university': university,
      'department': department,
      'startDate': startDate?.toIso8601String(),
      'graduationYear': graduationYear?.toIso8601String(),
    };
  }

  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      id: map['id'],
      degree: map['degree'] != null
          ? EducationStatusExtension.fromName(map['degree'])
          : null,
      university: map['university'],
      department: map['department'],
      startDate:
          map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      graduationYear: map['graduationYear'] != null
          ? DateTime.parse(map['graduationYear'])
          : null,
    );
  }
}

class UserSkill {
  String id;
  Skill? skill;

  UserSkill({
    String? id,
    this.skill,
  }) : id = id ?? Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'skill': skill?.name,
    };
  }

  factory UserSkill.fromMap(Map<String, dynamic> map) {
    return UserSkill(
      id: map['id'],
      skill:
          map['skill'] != null ? SkillExtension.fromName(map['skill']) : null,
    );
  }
}

class Certificate {
  String id;
  final String name;
  final DateTime date;
  final String fileUrl;
  final String fileType;

  Certificate({
    String? id,
    required this.name,
    required this.date,
    required this.fileUrl,
    required this.fileType,
  }) : id = id ?? Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'fileUrl': fileUrl,
      'fileType': fileType,
    };
  }

  factory Certificate.fromMap(Map<String, dynamic> map) {
    return Certificate(
      id: map['id'],
      name: map['name'],
      date: DateTime.parse(map['date']),
      fileUrl: map['fileUrl'],
      fileType: map['fileType'],
    );
  }

  Certificate copyWith({
    String? id,
    String? name,
    DateTime? date,
    String? fileUrl,
    String? fileType,
  }) {
    return Certificate(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      fileUrl: fileUrl ?? this.fileUrl,
      fileType: fileType ?? this.fileType,
    );
  }
}

class Community {
  String id;
  String? communityName;
  String? position;

  Community({
    String? id,
    this.communityName,
    this.position,
  }) : id = id ?? Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'communityName': communityName,
      'position': position,
    };
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      id: map['id'],
      communityName: map['communityName'],
      position: map['position'],
    );
  }
}

class ProjectAwards {
  String id;
  String? projectName;
  DateTime? projectDate;

  ProjectAwards({
    String? id,
    this.projectName,
    this.projectDate,
  }) : id = id ?? Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectName': projectName,
      'projectDate': projectDate?.toIso8601String(),
    };
  }

  factory ProjectAwards.fromMap(Map<String, dynamic> map) {
    return ProjectAwards(
      id: map['id'],
      projectName: map['projectName'],
      projectDate: map['projectDate'] != null
          ? DateTime.parse(map['projectDate'])
          : null,
    );
  }
}

class SocialMedia {
  String id;
  SocialMediaPlatform? platform;
  String? link;

  SocialMedia({
    String? id,
    this.platform,
    this.link,
  }) : id = id ?? Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'platform': platform?.name,
      'link': link,
    };
  }

  factory SocialMedia.fromMap(Map<String, dynamic> map) {
    return SocialMedia(
      id: map['id'],
      platform: map['platform'] != null
          ? SocialMediaPlatformExtension.fromName(map['platform'])
          : null,
      link: map['link'],
    );
  }
}

class Languages {
  String id;
  Language? language;
  ProficiencyLevel? level;

  Languages({
    String? id,
    this.language,
    this.level,
  }) : id = id ?? Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'language': language?.name,
      'level': level?.name,
    };
  }

  factory Languages.fromMap(Map<String, dynamic> map) {
    return Languages(
      id: map['id'],
      language: map['language'] != null
          ? LanguageExtension.fromName(map['language'])
          : null,
      level: map['level'] != null
          ? ProficiencyLevelExtension.fromName(map['level'])
          : null,
    );
  }
}
