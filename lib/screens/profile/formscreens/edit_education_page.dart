import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/models/userModel.dart';
import 'package:tobetoapp/models/user_enum.dart';
import 'package:tobetoapp/screens/profile/formscreens/form_helpers.dart';

class EditEducationPage extends StatefulWidget {
  const EditEducationPage({super.key});

  @override
  _EditEducationPageState createState() => _EditEducationPageState();
}

class _EditEducationPageState extends State<EditEducationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _degreeController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  EducationStatus? _selectedEducationStatus;
  UserModel? _currentUser;
  bool _isCurrentlyStudying = false;

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
        title: const Text('Eğitimlerim'),
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          _buildForm(),
          const SizedBox(height: 16.0),
          _buildEducationList(),
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
          buildDropdown<EducationStatus>(
              'Eğitim Durumu',
              _selectedEducationStatus,
              EducationStatus.values,
              (value) => setState(() => _selectedEducationStatus = value),
              (value) => value.name,
              Icons.school),
          buildTextFormField(
              _universityController, 'Üniversite', Icons.account_balance),
          buildTextFormField(_departmentController, 'Bölüm', Icons.book),
          buildDateFormField(
              _startDateController, 'Başlangıç Yılı', Icons.calendar_today),
          buildDateFormField(
              _endDateController, 'Mezuniyet Yılı', Icons.calendar_today,
              isDisabled: _isCurrentlyStudying),
          _buildCheckbox('Devam Ediyorum'),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveEducation,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Checkbox(
            value: _isCurrentlyStudying,
            onChanged: (value) {
              setState(() {
                _isCurrentlyStudying = value!;
                if (_isCurrentlyStudying) {
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

  Widget _buildEducationList() {
    final education = _currentUser?.education ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Eklenen Eğitimler',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: education.length,
          itemBuilder: (context, index) {
            final edu = education[index];
            return Card(
              color: Colors.purple[50],
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(edu.university ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bölüm: ${edu.department ?? ''}'),
                    Text('Eğitim Durumu: ${edu.degree?.name ?? ''}'),
                    Text(
                        'Başlangıç Yılı: ${edu.startDate != null ? DateFormat('yyyy').format(edu.startDate!) : ''}'),
                    if (edu.graduationYear != null)
                      Text(
                          'Mezuniyet Yılı: ${edu.graduationYear != null ? DateFormat('yyyy').format(edu.graduationYear!) : ''}'),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteEducation(edu.id),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _saveEducation() {
    if (_formKey.currentState?.validate() ?? false) {
      final newEducation = Education(
        degree: _selectedEducationStatus,
        university: _universityController.text,
        department: _departmentController.text,
        startDate: DateFormat('dd/MM/yyyy').parse(_startDateController.text),
        graduationYear: _isCurrentlyStudying
            ? null
            : DateFormat('dd/MM/yyyy').parse(_endDateController.text),
      );

      final updatedUser = _currentUser!.copyWith(
        education: [...?_currentUser?.education, newEducation],
      );

      final userBloc = context.read<ProfileBloc>();
      userBloc.add(UpdateUserProfile(updatedUser));
      _clearForm();
    }
  }

  void _deleteEducation(String educationId) {
    final updatedUser = _currentUser!.copyWith(
      education:
          _currentUser?.education?.where((e) => e.id != educationId).toList(),
    );
    context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
  }

  void _clearForm() {
    _degreeController.clear();
    _universityController.clear();
    _departmentController.clear();
    _startDateController.clear();
    _endDateController.clear();
    setState(() {
      _selectedEducationStatus = null;
      _isCurrentlyStudying = false;
    });
  }
}
