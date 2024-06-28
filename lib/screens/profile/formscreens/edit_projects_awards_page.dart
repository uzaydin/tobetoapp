import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/models/user_model.dart';
import 'package:tobetoapp/screens/profile/formscreens/form_helpers.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

class EditProjectsAwardsPage extends StatefulWidget {
  const EditProjectsAwardsPage({super.key});

  @override
  _EditProjectsAwardsPageState createState() => _EditProjectsAwardsPageState();
}

class _EditProjectsAwardsPageState extends State<EditProjectsAwardsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

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
        title: const Text('Projeler ve Ödüller'),
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
          _buildProjectsAwardsList(),
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
              _projectNameController, 'Proje veya Ödül Adı', Icons.star),
          buildDateFormField(_dateController, 'Tarih', Icons.calendar_today,
              isOptional: true),
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveProjectAward,
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

  Widget _buildProjectsAwardsList() {
    final projectsAwards = _currentUser?.projectsAwards ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Eklenen Projeler ve Ödüller',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: projectsAwards.length,
          itemBuilder: (context, index) {
            final projectAward = projectsAwards[index];
            return Card(
              color: Colors.purple[50],
              margin: EdgeInsets.symmetric(
                  vertical: AppConstants.verticalPaddingSmall),
              child: ListTile(
                title: Text(projectAward.projectName ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: projectAward.projectDate != null
                    ? Text(
                        'Tarih: ${DateFormat('dd/MM/yyyy').format(projectAward.projectDate!)}')
                    : null,
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteProjectAward(projectAward.id),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _saveProjectAward() {
    if (_formKey.currentState?.validate() ?? false) {
      final newProjectAward = ProjectAwards(
        projectName: _projectNameController.text,
        projectDate: _dateController.text.isNotEmpty
            ? DateFormat('dd/MM/yyyy').parse(_dateController.text)
            : null,
      );

      final updatedUser = _currentUser!.copyWith(
        projectsAwards: [...?_currentUser?.projectsAwards, newProjectAward],
      );

      final userBloc = context.read<ProfileBloc>();
      userBloc.add(UpdateUserProfile(updatedUser));
      _clearForm();
    }
  }

  void _deleteProjectAward(String projectAwardId) {
    final updatedUser = _currentUser!.copyWith(
      projectsAwards: _currentUser?.projectsAwards
          ?.where((e) => e.id != projectAwardId)
          .toList(),
    );
    context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
  }

  void _clearForm() {
    _projectNameController.clear();
    _dateController.clear();
  }
}
