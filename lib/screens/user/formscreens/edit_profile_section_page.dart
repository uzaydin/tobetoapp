import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/models/userModel.dart';
import 'package:tobetoapp/screens/user/formscreens/edit_certificates_page.dart';
import 'package:tobetoapp/screens/user/formscreens/edit_communities_page.dart';
import 'package:tobetoapp/screens/user/formscreens/edit_education_page.dart';
import 'package:tobetoapp/screens/user/formscreens/edit_experiences_page.dart';
import 'package:tobetoapp/screens/user/formscreens/edit_languages_page.dart';
import 'package:tobetoapp/screens/user/formscreens/edit_personal_info_page.dart';
import 'package:tobetoapp/screens/user/formscreens/edit_projects_awards_page.dart';
import 'package:tobetoapp/screens/user/formscreens/edit_skills_page.dart';
import 'package:tobetoapp/screens/user/formscreens/edit_social_media_page.dart';

class ProfileSectionPage extends StatelessWidget {
  final UserModel user;

  const ProfileSectionPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Düzenleme'),
        backgroundColor: Colors.purple[50],
        centerTitle: true,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            final user = state.user;
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildSectionTile(
                  context,
                  title: 'Kişisel Bilgilerim',
                  page: EditPersonalInfoPage(user: user),
                ),
                _buildSectionTile(
                  context,
                  title: 'Deneyimlerim',
                  page: EditExperiencesPage(user: user),
                ),
                _buildSectionTile(
                  context,
                  title: 'Eğitim Hayatım',
                  page: EditEducationPage(user: user),
                ),
                _buildSectionTile(
                  context,
                  title: 'Yetkinliklerim',
                  page: EditSkillsPage(user: user),
                ),
                _buildSectionTile(
                  context,
                  title: 'Sertifikalarım',
                  page: EditCertificatesPage(user: user),
                ),
                _buildSectionTile(
                  context,
                  title: 'Üye Topluluklar',
                  page: EditCommunitiesPage(user: user),
                ),
                _buildSectionTile(
                  context,
                  title: 'Projeler ve Ödüller',
                  page: EditProjectsAwardsPage(user: user),
                ),
                _buildSectionTile(
                  context,
                  title: 'Medya Hesaplarım',
                  page: EditSocialMediaPage(user: user),
                ),
                _buildSectionTile(
                  context,
                  title: 'Yabancı Dillerim',
                  page: EditLanguagesPage(user: user),
                ),
              ],
            );
          } else if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileError) {
            return Center(child: Text('Hata: ${state.message}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildSectionTile(BuildContext context,
      {required String title, required Widget page}) {
    return Card(
      color: Colors.purple[50],
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => page,
            ),
          );
        },
      ),
    );
  }
}
