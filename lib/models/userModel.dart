
import 'package:tobetoapp/models/user_enum.dart';

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
  List<String>?
      classIds; // Kullanıcının bir veya birden fazla sınıfı olabilir.

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
      'role': role?.name,
      'classIds': classIds,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
  return UserModel(
    id: map['id'] as String?,
    profilePhotoUrl: map['profilePhotoUrl'],
    firstName: map['firstName'],
    lastName: map['lastName'],
    phoneNumber: map['phoneNumber'],
    birthDate:
        map['birthDate'] != null ? DateTime.parse(map['birthDate']) : null,
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
    role: map['role'] != null ? UserRoleExtension.fromName(map['role']) : null,
    classIds: map['classIds'] != null ? List<String>.from(map['classIds']) : [],
  );
}
}

class Experience {
  String? institution;
  String? position;
  ExperienceType experienceType;
  String? sector;
  String? city;
  DateTime? startDate;
  DateTime? endDate;
  String? description;

  Experience({
    this.institution,
    this.position,
    required this.experienceType,
    this.sector,
    this.city,
    this.startDate,
    this.endDate,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'institution': institution,
      'position': position,
      'experienceType': experienceType.name,
      'sector': sector,
      'city': city,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'description': description,
    };
  }

  factory Experience.fromMap(Map<String, dynamic> map) {
    return Experience(
      institution: map['institution'],
      position: map['position'],
      experienceType: map['experienceType'] != null
          ? ExperienceTypeExtension.fromName(map['experienceType'])
          : ExperienceType.Staj,
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
  EducationStatus degree;
  String? university;
  String? department;
  DateTime? startDate;
  DateTime? graduationYear;

  Education({
    required this.degree,
    this.university,
    this.department,
    this.startDate,
    this.graduationYear,
  });

  Map<String, dynamic> toMap() {
    return {
      'degree': degree.name,
      'university': university,
      'department': department,
      'startDate': startDate?.toIso8601String(),
      'graduationYear': graduationYear?.toIso8601String(),
    };
  }

  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      degree: EducationStatusExtension.fromName(map['degree']),
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
  final Skill skill;

  UserSkill({required this.skill});

  Map<String, dynamic> toMap() {
    return {
      'skill': skill.name,
    };
  }

  factory UserSkill.fromMap(Map<String, dynamic> map) {
    return UserSkill(
      skill: SkillExtension.fromName(map['skill']),
    );
  }
}

class Certificate {
  String name;
  DateTime date;

  Certificate({required this.name, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date.toIso8601String(),
    };
  }

  factory Certificate.fromMap(Map<String, dynamic> map) {
    return Certificate(
      name: map['name'],
      date: DateTime.parse(map['date']),
    );
  }
}

class Community {
  String? communityName;
  String? position;

  Community({this.communityName, this.position});

  Map<String, dynamic> toMap() {
    return {
      'communityName': communityName,
      'position': position,
    };
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      communityName: map['communityName'],
      position: map['position'],
    );
  }
}

class ProjectAwards {
  String? projectName;
  DateTime? projectDate;

  ProjectAwards({this.projectName, this.projectDate});

  Map<String, dynamic> toMap() {
    return {
      'projectName': projectName,
      'projectDate': projectDate?.toIso8601String(),
    };
  }

  factory ProjectAwards.fromMap(Map<String, dynamic> map) {
    return ProjectAwards(
      projectName: map['projectName'],
      projectDate: map['projectDate'] != null
          ? DateTime.parse(map['projectDate'])
          : null,
    );
  }
}

class SocialMedia {
  SocialMediaPlatform platform;
  String? link;

  SocialMedia({required this.platform, this.link});

  Map<String, dynamic> toMap() {
    return {
      'platform': platform.name,
      'link': link,
    };
  }

  factory SocialMedia.fromMap(Map<String, dynamic> map) {
    return SocialMedia(
      platform: SocialMediaPlatformExtension.fromName(map['platform']),
      link: map['link'],
    );
  }
}

class Languages {
  Language language;
  ProficiencyLevel level;

  Languages({required this.language, required this.level});

  Map<String, dynamic> toMap() {
    return {
      'language': language.name,
      'level': level.name,
    };
  }

  factory Languages.fromMap(Map<String, dynamic> map) {
    return Languages(
      language: LanguageExtension.fromName(map['language']),
      level: ProficiencyLevelExtension.fromName(map['level']),
    );
  }
}
