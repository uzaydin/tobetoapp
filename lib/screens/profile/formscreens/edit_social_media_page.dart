import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/models/user_model.dart';
import 'package:tobetoapp/models/user_enum.dart';
import 'package:tobetoapp/screens/profile/formscreens/form_helpers.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

class EditSocialMediaPage extends StatefulWidget {
  const EditSocialMediaPage({super.key});

  @override
  _EditSocialMediaPageState createState() => _EditSocialMediaPageState();
}

class _EditSocialMediaPageState extends State<EditSocialMediaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _linkController = TextEditingController();

  SocialMediaPlatform? _selectedPlatform;
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
        title: const Text('Sosyal Medya Hesapları'),
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
          _buildSocialMediaList(),
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
          buildDropdown<SocialMediaPlatform>(
              'Hesap Seç',
              _selectedPlatform,
              SocialMediaPlatform.values,
              (value) => setState(() => _selectedPlatform = value),
              (value) => value.name,
              Icons.account_circle),
          buildTextFormField(_linkController, 'Link', Icons.link),
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveSocialMedia,
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

  Widget _buildSocialMediaList() {
    final socialMedia = _currentUser?.socialMedia ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Eklenen Sosyal Medya Hesapları',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: socialMedia.length,
          itemBuilder: (context, index) {
            final social = socialMedia[index];
            return Card(
              color: Colors.purple[50],
              margin: EdgeInsets.symmetric(
                  vertical: AppConstants.verticalPaddingSmall),
              child: ListTile(
                title: Text(social.platform?.name ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(social.link ?? ''),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteSocialMedia(social.id),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _saveSocialMedia() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kullanıcı bilgileri yüklenemedi')),
        );
        return;
      }

      final newSocialMedia = SocialMedia(
        platform: _selectedPlatform,
        link: _linkController.text,
      );

      final updatedUser = _currentUser!.copyWith(
        socialMedia: [...?_currentUser?.socialMedia, newSocialMedia],
      );

      final userBloc = context.read<ProfileBloc>();
      userBloc.add(UpdateUserProfile(updatedUser));
      _clearForm();
    }
  }

  void _deleteSocialMedia(String socialMediaId) {
    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kullanıcı bilgileri yüklenemedi')),
      );
      return;
    }

    final updatedUser = _currentUser!.copyWith(
      socialMedia: _currentUser?.socialMedia
          ?.where((e) => e.id != socialMediaId)
          .toList(),
    );
    context.read<ProfileBloc>().add(UpdateUserProfile(updatedUser));
  }

  void _clearForm() {
    _linkController.clear();
    setState(() {
      _selectedPlatform = null;
    });
  }
}
