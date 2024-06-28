import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/models/user_model.dart';
import 'package:tobetoapp/models/user_enum.dart';
import 'package:tobetoapp/screens/profile/formscreens/form_helpers.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

class EditExperiencesPage extends StatefulWidget {
  const EditExperiencesPage({super.key});

  @override
  _EditExperiencesPageState createState() => _EditExperiencesPageState();
}

class _EditExperiencesPageState extends State<EditExperiencesPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _institutionController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _sectorController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  ExperienceType? _selectedExperienceType;
  UserModel? _currentUser;
  bool _isCurrentlyWorking = false;

  @override
  void initState() {
    super.initState();
    final userBloc = context.read<ProfileBloc>();
    userBloc.add(FetchUserDetails());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deneyimlerim'),
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            _currentUser = state.user;
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return _buildContent();
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        children: <Widget>[
          _buildForm(),
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
          _buildExperienceList(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: <Widget>[
          buildTextFormField(
              _institutionController, 'Kurum Adı', Icons.business),
          buildTextFormField(_positionController, 'Pozisyon', Icons.work),
          buildDropdown<ExperienceType>(
              'Deneyim Türü',
              _selectedExperienceType,
              ExperienceType.values,
              (value) => setState(() => _selectedExperienceType = value),
              (value) => value.name,
              Icons.category),
          buildTextFormField(
              _sectorController, 'Sektör', Icons.business_center),
          buildTextFormField(_cityController, 'Şehir', Icons.location_city),
          buildDateFormField(
              _startDateController, 'İş Başlangıcı', Icons.calendar_today),
          buildDateFormField(
              _endDateController, 'İş Bitişi', Icons.calendar_today,
              isDisabled: _isCurrentlyWorking),
          _buildCheckbox('Çalışmaya Devam Ediyorum'),
          buildTextFormField(
              _descriptionController, 'İş Açıklaması', Icons.description,
              isOptional: true),
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveExperience,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.br10),
                ),
                padding:
                    EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
              ),
              child: const Text('Ekle'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String label) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: AppConstants.verticalPaddingSmall),
      child: Row(
        children: [
          Checkbox(
            value: _isCurrentlyWorking,
            onChanged: (value) {
              setState(() {
                _isCurrentlyWorking = value!;
                if (_isCurrentlyWorking) {
                  _endDateController.clear();
                }
              });
            },
          ),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildExperienceList() {
    final experiences = _currentUser?.experiences ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Eklenen Deneyimler',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: experiences.length,
          itemBuilder: (context, index) {
            final experience = experiences[index];
            return Card(
              color: Colors.purple[50],
              margin: EdgeInsets.symmetric(
                  vertical: AppConstants.verticalPaddingSmall),
              child: ListTile(
                title: Text(experience.institution ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pozisyon: ${experience.position ?? ''}'),
                    Text(
                        'Deneyim Türü: ${experience.experienceType?.name ?? ''}'),
                    Text('Sektör: ${experience.sector ?? ''}'),
                    Text('Şehir: ${experience.city ?? ''}'),
                    Text(
                        'Başlangıç: ${DateFormat('dd/MM/yyyy').format(experience.startDate!)}'),
                    if (experience.endDate != null)
                      Text(
                          'Bitiş: ${DateFormat('dd/MM/yyyy').format(experience.endDate!)}'),
                    if (experience.description != null &&
                        experience.description!.isNotEmpty)
                      Text('Açıklama: ${experience.description}'),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteExperience(experience.id),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _saveExperience() {
    if (_formKey.currentState?.validate() ?? false) {
      final newExperience = Experience(
        institution: _institutionController.text,
        position: _positionController.text,
        experienceType: _selectedExperienceType,
        sector: _sectorController.text,
        city: _cityController.text,
        startDate: DateFormat('dd/MM/yyyy').parse(_startDateController.text),
        endDate: _isCurrentlyWorking
            ? null
            : DateFormat('dd/MM/yyyy').parse(_endDateController.text),
        description: _descriptionController.text,
      );

      final updatedUser = _currentUser!.copyWith(
        experiences: [...?_currentUser?.experiences, newExperience],
      );

      final userBloc = context.read<ProfileBloc>();
      userBloc.add(UpdateUserProfile(updatedUser));
      _clearForm();
    }
  }

  void _deleteExperience(String experienceId) {
    final updatedUser = _currentUser!.copyWith(
      experiences: _currentUser?.experiences
          ?.where((e) => e.id != experienceId)
          .toList(),
    );
    context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
  }

  void _clearForm() {
    _institutionController.clear();
    _positionController.clear();
    _sectorController.clear();
    _cityController.clear();
    _startDateController.clear();
    _endDateController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedExperienceType = null;
      _isCurrentlyWorking = false;
    });
  }
}
