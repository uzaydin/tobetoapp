import 'package:flutter/material.dart';
import 'package:tobetoapp/services/firebase_firestore_services.dart';
import 'package:tobetoapp/screens/lesson_detail_screen.dart';
import 'package:tobetoapp/models/catalog_model.dart';
import 'package:tobetoapp/repository/catalog_repository.dart';

class LessonsCategoryScreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const LessonsCategoryScreen({Key? key});

  @override
  // ignore: library_private_types_in_public_api
  _LessonsCategoryScreenState createState() => _LessonsCategoryScreenState();
}

class _LessonsCategoryScreenState extends State<LessonsCategoryScreen> {
  final FirebaseFirestoreService firestoreService = FirebaseFirestoreService();
  late Map<String, List<String>> dropdownData = {};

  String? selectedCategory;
  String? selectedLevel;
  String? selectedSubject;
  String? selectedLanguage;
  String? selectedInstructor;
  String? selectedCertificationStatus;
  bool selectedIsFree = false;

  List<Catalog> filteredCatalogs = [];

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  void _fetchDropdownData() async {
    try {
      dropdownData['category'] = await firestoreService.fetchCategories();
      dropdownData['level'] = await firestoreService.fetchLevels();
      dropdownData['subject'] = await firestoreService.fetchSubjects();
      dropdownData['language'] = await firestoreService.fetchLanguages();
      dropdownData['instructor'] = await firestoreService.fetchInstructors();
      dropdownData['certificationStatus'] =
          await firestoreService.fetchCertificationStatuses();

      setState(() {});
    } catch (e) {
      print('Error fetching dropdown data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eğitimlerimiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildDropdown('Kategori Seçin', 'category', selectedCategory),
            _buildDropdown('Seviye Seçin', 'level', selectedLevel),
            _buildDropdown('Konu Seçin', 'subject', selectedSubject),
            _buildDropdown(
                'Yazılım Dili Seçin', 'language', selectedLanguage),
            _buildDropdown('Eğitmen Seçin', 'instructor', selectedInstructor),
            _buildDropdown('Sertifika Durumu Seçin', 'certificationStatus',
                selectedCertificationStatus),
            SwitchListTile(
              title: const Text('Ücretsiz'),
              value: selectedIsFree,
              onChanged: (value) {
                setState(() {
                  selectedIsFree = value;
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
                  return GestureDetector(
                    onTap: () => _navigateToDetailScreen(catalog),
                    child: Card(
                      child: ListTile(
                        leading: Image.network(catalog.imageUrl),
                        title: Text(catalog.title),
                        subtitle: Text('Rating: ${catalog.rating}'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetailScreen(Catalog catalog) {
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
  }

Widget _buildDropdown(
    String hintText, String dropdownKey, String? selectedValue) {
  List<String> dropdownValues = dropdownData[dropdownKey] ?? [];

  dropdownValues = dropdownValues.toSet().toList(); 

  return DropdownButton<String>(
    hint: Text(hintText),
    value: selectedValue,
    items: dropdownValues.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
    onChanged: (String? newValue) {
      setState(() {
        switch (dropdownKey) {
          case 'category':
            selectedCategory = newValue;
            break;
          case 'level':
            selectedLevel = newValue;
            break;
          case 'subject':
            selectedSubject = newValue;
            break;
          case 'language':
            selectedLanguage = newValue;
            break;
          case 'instructor':
            selectedInstructor = newValue;
            break;
          case 'certificationStatus':
            selectedCertificationStatus = newValue;
            break;
          case 'isFree':
            selectedIsFree = newValue == 'Ücretsiz';
            break;
        }
      });
    },
  );
}

  void _applyFilters() async {
    try {
      List<Catalog> catalogs = await CatalogRepository().getCatalog();

      setState(() {
        filteredCatalogs = catalogs.where((catalog) {
          return (selectedCategory == null ||
                  selectedCategory == catalog.category) &&
              (selectedLevel == null || selectedLevel == catalog.level) &&
              (selectedSubject == null || selectedSubject == catalog.subject) &&
              (selectedLanguage == null ||
                  selectedLanguage == catalog.language) &&
              (selectedInstructor == null ||
                  selectedInstructor == catalog.instructor) &&
              (selectedCertificationStatus == null ||
                  selectedCertificationStatus == catalog.certificationStatus) &&
              (!selectedIsFree || catalog.isFree == true);
        }).toList();
      });
    } catch (e) {
      print('Error applying filters: $e');
    }
  }
}
