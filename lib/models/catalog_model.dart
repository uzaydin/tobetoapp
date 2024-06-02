class Catalog {
  String id;
  String title;
  String instructors;
  String categories;
  String levels;
  String subjects;
  String languages;
  String certificationStatuses;
  String imageUrl;
  double rating;

  Catalog({
    required this.id,
    required this.title,
    required this.instructors,
    required this.categories,
    required this.levels,
    required this.subjects,
    required this.languages,
    required this.certificationStatuses,
    required this.imageUrl,
    required this.rating,
  });

  factory Catalog.fromMap(Map<String, dynamic> map) {
    return Catalog(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      instructors: map['instructor'] ?? '',
      categories: map['category'] ?? '',
      levels: map['level'] ?? '',
      subjects: map['subject'] ?? '',
      languages: map['language'] ?? '',
      certificationStatuses: map['certificationStatus'] ?? '',
      imageUrl: map['imageUrl'] ?? '', 
      rating: map['rating'] ?? 0.0, 
    );
  }
}