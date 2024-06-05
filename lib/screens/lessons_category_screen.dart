import 'package:flutter/material.dart';
import 'package:tobetoapp/services/firebase_firestore_services.dart';
import 'package:tobetoapp/screens/lesson_detail_screen.dart';
import 'package:tobetoapp/models/catalog_model.dart';
import 'package:tobetoapp/repository/catalog_repository.dart';

class LessonsCategoryScreen extends StatefulWidget {
  const LessonsCategoryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LessonsCategoryScreenState createState() => _LessonsCategoryScreenState();
}

class _LessonsCategoryScreenState extends State<LessonsCategoryScreen> {
  List<Catalog> filteredCatalogs = [];
  List<String> category = [];
  List<String> level = [];
  List<String> subject = [];
  List<String> language = [];
  List<String> instructor = [];
  List<String> certificationStatus = [];
  List<bool> isFree =[];

  String? selectedCategory;
  String? selectedLevel;
  String? selectedSubject;
  String? selectedLanguage;
  String? selectedInstructor;
  String? selectedCertificationStatus;
  bool selectedisFree = false;

  FirebaseFirestoreService firestoreService = FirebaseFirestoreService();

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  void _fetchDropdownData() async {
    category = await firestoreService.fetchCategories();
    level = await firestoreService.fetchLevels();
    subject = await firestoreService.fetchSubjects();
    language = await firestoreService.fetchLanguages();
    instructor = await firestoreService.fetchInstructors();
    certificationStatus = await firestoreService.fetchCertificationStatuses();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eğitimler'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: const Text('Kategori Seçin'),
              value: selectedCategory,
              items: category.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              },
            ),
            DropdownButton<String>(
              hint: const Text('Seviye Seçin'),
              value: selectedLevel,
              items: level.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedLevel = newValue;
                });
              },
            ),
            DropdownButton<String>(
              hint: const Text('Konu Seçin'),
              value: selectedSubject,
              items: subject.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSubject = newValue;
                });
              },
            ),
            DropdownButton<String>(
              hint: const Text('Yazılım Dili Seçin'),
              value: selectedLanguage,
              items: language.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedLanguage = newValue;
                });
              },
            ),
            DropdownButton<String>(
              hint: const Text('Eğitmen Seçin'),
              value: selectedInstructor,
              items: instructor.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedInstructor = newValue;
                });
              },
            ),
            DropdownButton<String>(
              hint: const Text('Sertifika Durumu Seçin'),
              value: selectedCertificationStatus,
              items: certificationStatus.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCertificationStatus = newValue;
                });
              },
            ),
SwitchListTile(
  title: const Text('Ücretsiz'),
  value: selectedisFree,
  onChanged: (value) {
            setState(() {
          selectedisFree = value;
        });
  }
),
            ElevatedButton(
              onPressed: _applyFilters,
              child: const Text('Filtrele'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredCatalogs.length,
                itemBuilder: (context, index) {
                  Catalog catalog = filteredCatalogs[index];
                  return VideoCard(
                    imageUrl: catalog.imageUrl,
                    title: catalog.title,
                    rating: catalog.rating,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LessonDetailScreen(
                            videoUrl: catalog.imageUrl,
                            videoTitle: catalog.title,
                            videoRating: catalog.rating,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyFilters() async {
    List<Catalog> catalogs = await CatalogRepository().getCatalog();

    setState(() {
      filteredCatalogs = catalogs.where((catalog) {
        return (selectedCategory == null || selectedCategory == catalog.category) &&
               (selectedLevel == null || selectedLevel == catalog.level) &&
               (selectedSubject == null || selectedSubject == catalog.subject) &&
               (selectedLanguage == null || selectedLanguage == catalog.language) &&
               (selectedInstructor == null || selectedInstructor == catalog.instructor) &&
               (selectedCertificationStatus == null || selectedCertificationStatus == catalog.certificationStatus);
      }).toList();
    });
  }
}

class VideoCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double rating;
  final VoidCallback onTap;

  const VideoCard({super.key,
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: ListTile(
          leading: Image.network(imageUrl),
          title: Text(title),
          subtitle: Text('Rating: $rating'),
        ),
      ),
    );
  }
}
