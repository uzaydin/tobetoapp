import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/models/user_model.dart';
import 'package:tobetoapp/models/user_enum.dart';
import 'package:tobetoapp/screens/profile/formscreens/form_helpers.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

class EditLanguagesPage extends StatefulWidget {
  const EditLanguagesPage({super.key});

  @override
  _EditLanguagesPageState createState() => _EditLanguagesPageState();
}

class _EditLanguagesPageState extends State<EditLanguagesPage> {
  final _formKey = GlobalKey<FormState>();

  Language? _selectedLanguage;
  ProficiencyLevel? _selectedProficiencyLevel;
  UserModel? _currentUser;

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
        title: const Text('Yabancı Dillerim'),
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            setState(() {
              _currentUser = state.user;
            });
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
          _buildLanguagesList(),
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
          buildDropdown<Language>(
              'Dil Seç',
              _selectedLanguage,
              Language.values,
              (value) => setState(() => _selectedLanguage = value),
              (value) => value.name,
              Icons.language),
          buildDropdown<ProficiencyLevel>(
              'Seviye Seç',
              _selectedProficiencyLevel,
              ProficiencyLevel.values,
              (value) => setState(() => _selectedProficiencyLevel = value),
              (value) => value.name,
              Icons.assessment),
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveLanguage,
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

  Widget _buildLanguagesList() {
    final languages = _currentUser?.languages ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Eklenen Diller',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: languages.length,
          itemBuilder: (context, index) {
            final language = languages[index];
            return Card(
              color: Colors.purple[50],
              margin: EdgeInsets.symmetric(
                  vertical: AppConstants.verticalPaddingSmall),
              child: ListTile(
                title: Text(language.language?.name ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Seviye: ${language.level?.name ?? ''}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteLanguage(language.id),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _saveLanguage() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kullanıcı bilgileri yüklenemedi')),
        );
        return;
      }

      final newLanguage = Languages(
        language: _selectedLanguage,
        level: _selectedProficiencyLevel,
      );

      final updatedUser = _currentUser!.copyWith(
        languages: [...?_currentUser?.languages, newLanguage],
      );

      final userBloc = context.read<ProfileBloc>();
      userBloc.add(UpdateUserProfile(updatedUser));
      _clearForm();
    }
  }

  void _deleteLanguage(String languageId) {
    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kullanıcı bilgileri yüklenemedi')),
      );
      return;
    }

    final updatedUser = _currentUser!.copyWith(
      languages:
          _currentUser?.languages?.where((e) => e.id != languageId).toList(),
    );
    context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
  }

  void _clearForm() {
    setState(() {
      _selectedLanguage = null;
      _selectedProficiencyLevel = null;
    });
  }
}
