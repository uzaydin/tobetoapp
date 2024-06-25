import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/models/userModel.dart';
import 'package:tobetoapp/models/user_enum.dart';
import 'package:tobetoapp/widgets/user/form_fields.dart';

class EditExperiencesPage extends StatefulWidget {
  final UserModel user;

  const EditExperiencesPage({super.key, required this.user});

  @override
  _EditExperiencesPageState createState() => _EditExperiencesPageState();
}

class _EditExperiencesPageState extends State<EditExperiencesPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _institutionController;
  late TextEditingController _positionController;
  ExperienceType? _selectedExperienceType;
  late TextEditingController _sectorController;
  late TextEditingController _cityController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _descriptionController;
  bool _isStillWorking = false;

  @override
  void initState() {
    super.initState();
    _institutionController = TextEditingController();
    _positionController = TextEditingController();
    _sectorController = TextEditingController();
    _cityController = TextEditingController();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  void _clearFields() {
    _institutionController.clear();
    _positionController.clear();
    _sectorController.clear();
    _cityController.clear();
    _startDateController.clear();
    _endDateController.clear();
    _descriptionController.clear();
    _selectedExperienceType = null;
    setState(() {
      _isStillWorking = false;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final experience = Experience(
        institution: _institutionController.text,
        position: _positionController.text,
        experienceType: _selectedExperienceType,
        sector: _sectorController.text,
        city: _cityController.text,
        startDate: DateTime.parse(_startDateController.text),
        endDate: !_isStillWorking && _endDateController.text.isNotEmpty
            ? DateTime.parse(_endDateController.text)
            : null,
        description: _descriptionController.text,
      );
      final updatedUser = widget.user.copyWith(
        experiences: [...widget.user.experiences ?? [], experience],
      );
      context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
      _clearFields();
    }
  }

  void _deleteExperience(String experienceId) {
    final updatedUser = widget.user.copyWith(
      experiences:
          widget.user.experiences?.where((e) => e.id != experienceId).toList(),
    );
    context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deneyimlerim Düzenle'),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Deneyimler başarıyla güncellendi')),
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Hata: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Expanded(
                      child: ListView(
                        children: [
                          FormFields.buildTextField(
                            controller: _institutionController,
                            label: 'Kurum Adı',
                            isRequired: true,
                          ),
                          const SizedBox(height: 16),
                          FormFields.buildTextField(
                            controller: _positionController,
                            label: 'Pozisyon',
                            isRequired: true,
                          ),
                          const SizedBox(height: 16),
                          FormFields.buildDropdownField<ExperienceType>(
                            value: _selectedExperienceType,
                            label: 'Deneyim Türü',
                            items: ExperienceType.values,
                            onChanged: (value) {
                              setState(() {
                                _selectedExperienceType = value;
                              });
                            },
                            itemLabel: (item) => item.name,
                            isRequired: true,
                          ),
                          const SizedBox(height: 16),
                          FormFields.buildTextField(
                            controller: _sectorController,
                            label: 'Sektör',
                            isRequired: true,
                          ),
                          const SizedBox(height: 16),
                          FormFields.buildTextField(
                            controller: _cityController,
                            label: 'Şehir',
                            isRequired: true,
                          ),
                          const SizedBox(height: 16),
                          FormFields.buildDateField(
                            controller: _startDateController,
                            label: 'İş Başlangıcı',
                            isRequired: true,
                            context: context,
                          ),
                          const SizedBox(height: 16),
                          FormFields.buildDateField(
                            controller: _endDateController,
                            label: 'İş Bitişi',
                            context: context,
                            enabled: !_isStillWorking,
                          ),
                          const SizedBox(height: 16),
                          CheckboxListTile(
                            title: const Text('Çalışmaya Devam Ediyorum'),
                            value: _isStillWorking,
                            onChanged: (bool? value) {
                              setState(() {
                                _isStillWorking = value ?? false;
                                if (_isStillWorking) {
                                  _endDateController.clear();
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          FormFields.buildTextField(
                            controller: _descriptionController,
                            label: 'İş Açıklaması',
                            keyboardType: TextInputType.multiline,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: const Text('Kaydet'),
                          ),
                          const SizedBox(height: 16),
                          const Text('Eklenen Deneyimler',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          ...state.user.experiences
                                  ?.map((experience) => ListTile(
                                        title:
                                            Text(experience.institution ?? ''),
                                        subtitle:
                                            Text(experience.position ?? ''),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            _deleteExperience(experience.id);
                                          },
                                        ),
                                      ))
                                  .toList() ??
                              [],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
