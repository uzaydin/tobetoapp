import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/models/userModel.dart';
import 'package:tobetoapp/screens/profile/formscreens/form_helpers.dart';

class EditCommunitiesPage extends StatefulWidget {
  const EditCommunitiesPage({super.key});

  @override
  _EditCommunitiesPageState createState() => _EditCommunitiesPageState();
}

class _EditCommunitiesPageState extends State<EditCommunitiesPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _communityNameController =
      TextEditingController();
  final TextEditingController _positionController = TextEditingController();

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
        title: const Text('Üye Topluluklar'),
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
          _buildCommunityList(),
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
              _communityNameController, 'Kulüp veya Topluluk Adı', Icons.group),
          buildTextFormField(
              _positionController, 'Ünvan veya Görev', Icons.work),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveCommunity,
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

  Widget _buildCommunityList() {
    final communities = _currentUser?.communities ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Eklenen Topluluklar',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: communities.length,
          itemBuilder: (context, index) {
            final community = communities[index];
            return Card(
              color: Colors.purple[50],
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(community.communityName ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Görev: ${community.position ?? ''}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteCommunity(community.id),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _saveCommunity() {
    if (_formKey.currentState?.validate() ?? false) {
      final newCommunity = Community(
        communityName: _communityNameController.text,
        position: _positionController.text,
      );

      final updatedUser = _currentUser!.copyWith(
        communities: [...?_currentUser?.communities, newCommunity],
      );

      final userBloc = context.read<ProfileBloc>();
      userBloc.add(UpdateUserProfile(updatedUser));
      _clearForm();
    }
  }

  void _deleteCommunity(String communityId) {
    final updatedUser = _currentUser!.copyWith(
      communities:
          _currentUser?.communities?.where((e) => e.id != communityId).toList(),
    );
    context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
  }

  void _clearForm() {
    _communityNameController.clear();
    _positionController.clear();
  }
}
