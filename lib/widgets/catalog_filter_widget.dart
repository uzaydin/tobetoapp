import 'package:flutter/material.dart';
import 'package:tobetoapp/models/catalog_model.dart';
import 'package:tobetoapp/repository/catalog/catalog_repository.dart';

class CatalogFilterWidget extends StatefulWidget {
  const CatalogFilterWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CatalogFilterWidgetState createState() => _CatalogFilterWidgetState();
}

class _CatalogFilterWidgetState extends State<CatalogFilterWidget> {
  final CatalogRepository catalogRepository = CatalogRepository();
  late Map<String, List<String>> dropdownData = {};

  String? selectedCategory;
  String? selectedLevel;
  String? selectedSubject;
  String? selectedLanguage;
  String? selectedInstructor;
  String? selectedCertificationStatus;
  bool selectedIsFree = false;

  List<CatalogModel> filteredCatalogs = [];
  bool hasFiltered = false;

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  void _fetchDropdownData() async {
    try {
      dropdownData['category'] = await catalogRepository.fetchCategories();
      dropdownData['level'] = await catalogRepository.fetchLevels();
      dropdownData['subject'] = await catalogRepository.fetchSubjects();
      dropdownData['language'] = await catalogRepository.fetchLanguages();
      dropdownData['instructor'] = await catalogRepository.fetchInstructors();
      dropdownData['certificationStatus'] =
          await catalogRepository.fetchCertificationStatuses();

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDropdown('Kategori Seçin', 'category', selectedCategory),
          const SizedBox(height: 10),
          _buildDropdown('Seviye Seçin', 'level', selectedLevel),
          const SizedBox(height: 10),
          _buildDropdown('Konu Seçin', 'subject', selectedSubject),
          const SizedBox(height: 10),
          _buildDropdown('Yazılım Dili Seçin', 'language', selectedLanguage),
          const SizedBox(height: 10),
          _buildDropdown('Eğitmen Seçin', 'instructor', selectedInstructor),
          const SizedBox(height: 10),
          _buildDropdown(
              'Sertifika Durumu Seçin', 'certificationStatus', selectedCertificationStatus),
          const SizedBox(height: 10),
          _buildDropdown('Ücretsiz', 'isFree', null),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await _applyFilters(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text(
              'Filtrele',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String hintText, String dropdownKey, String? selectedValue) {
    Set<String> dropdownValuesSet = dropdownData[dropdownKey]?.toSet() ?? {};

    if (dropdownKey == 'isFree') {
      return SwitchListTile(
        title: Text(hintText),
        value: selectedIsFree,
        onChanged: (value) {
          setState(() {
            selectedIsFree = value;
          });
        },
      );
    }

    List<String> dropdownValues = dropdownValuesSet.toList();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        underline: const SizedBox(),
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
            }
          });
        },
      ),
    );
  }

  Future<void> _applyFilters(BuildContext context) async {
    try {
      List<CatalogModel> lessoncatalog = await CatalogRepository().getCatalog('');

      final filteredList = lessoncatalog.where((catalog) {
        return (selectedCategory == null || selectedCategory == catalog.category) &&
            (selectedLevel == null || selectedLevel == catalog.level) &&
            (selectedSubject == null || selectedSubject == catalog.subject) &&
            (selectedLanguage == null || selectedLanguage == catalog.language) &&
            (selectedInstructor == null || selectedInstructor == catalog.instructor) &&
            (selectedCertificationStatus == null || selectedCertificationStatus == catalog.certificationStatus) &&
            (!selectedIsFree || catalog.isFree == true);
      }).toList();

      if (mounted) {
        Navigator.pop(context, filteredList);
      }
    } catch (e) {
    }
  }
}
