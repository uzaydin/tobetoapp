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
  List<String> categories = [];
  List<String> levels = [];
  List<String> subjects = [];
  List<String> languages = [];
  List<String> instructors = [];
  List<String> certificationStatuses = [];

  String? selectedCategory;
  String? selectedLevel;
  String? selectedSubject;
  String? selectedLanguage;
  String? selectedInstructor;
  String? selectedCertificationStatus;
  bool isFree = false;

  FirebaseFirestoreService firestoreService = FirebaseFirestoreService();

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  void _fetchDropdownData() async {
    categories = await firestoreService.fetchCategories();
    levels = await firestoreService.fetchLevels();
    subjects = await firestoreService.fetchSubjects();
    languages = await firestoreService.fetchLanguages();
    instructors = await firestoreService.fetchInstructors();
    certificationStatuses = await firestoreService.fetchCertificationStatuses();

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
              items: categories.map((String value) {
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
              items: levels.map((String value) {
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
              items: subjects.map((String value) {
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
              items: languages.map((String value) {
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
              items: instructors.map((String value) {
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
              items: certificationStatuses.map((String value) {
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
              value: isFree,
              onChanged: (bool value) {
                setState(() {
                  isFree = value;
                });
              },
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
        return (selectedCategory == null || selectedCategory == catalog.categories) &&
               (selectedLevel == null || selectedLevel == catalog.levels) &&
               (selectedSubject == null || selectedSubject == catalog.subjects) &&
               (selectedLanguage == null || selectedLanguage == catalog.languages) &&
               (selectedInstructor == null || selectedInstructor == catalog.instructors) &&
               (selectedCertificationStatus == null || selectedCertificationStatus == catalog.certificationStatuses);
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
