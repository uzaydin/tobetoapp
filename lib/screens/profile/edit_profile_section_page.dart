import 'package:flutter/material.dart';
import 'package:tobetoapp/screens/profile/formscreens/edit_certificates_page.dart';
import 'package:tobetoapp/screens/profile/formscreens/edit_communities_page.dart';
import 'package:tobetoapp/screens/profile/formscreens/edit_education_page.dart';
import 'package:tobetoapp/screens/profile/formscreens/edit_experiences_page.dart';
import 'package:tobetoapp/screens/profile/formscreens/edit_languages_page.dart';
import 'package:tobetoapp/screens/profile/formscreens/edit_personal_info_page.dart';
import 'package:tobetoapp/screens/profile/formscreens/edit_projects_awards_page.dart';
import 'package:tobetoapp/screens/profile/formscreens/edit_skills_page.dart';
import 'package:tobetoapp/screens/profile/formscreens/edit_social_media_page.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

class ProfileSectionPage extends StatelessWidget {
  const ProfileSectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Düzenleme'),
        backgroundColor: Colors.purple[50],
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(AppConstants.paddingMedium),
        children: [
          _buildSectionTile(
            context,
            title: 'Kişisel Bilgilerim',
            page: const EditPersonalInfoPage(),
          ),
          _buildSectionTile(
            context,
            title: 'Deneyimlerim',
            page: const EditExperiencesPage(),
          ),
          _buildSectionTile(
            context,
            title: 'Eğitim Hayatım',
            page: const EditEducationPage(),
          ),
          _buildSectionTile(
            context,
            title: 'Yetkinliklerim',
            page: const EditSkillsPage(),
          ),
          _buildSectionTile(
            context,
            title: 'Sertifikalarım',
            page: const EditCertificatesPage(),
          ),
          _buildSectionTile(
            context,
            title: 'Üye Topluluklar',
            page: const EditCommunitiesPage(),
          ),
          _buildSectionTile(
            context,
            title: 'Projeler ve Ödüller',
            page: const EditProjectsAwardsPage(),
          ),
          _buildSectionTile(
            context,
            title: 'Medya Hesaplarım',
            page: const EditSocialMediaPage(),
          ),
          _buildSectionTile(
            context,
            title: 'Yabancı Dillerim',
            page: const EditLanguagesPage(),
          ),
          SizedBox(height: AppConstants.sizedBoxHeightXLarge),
          const Divider(thickness: 1),
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
        ],
      ),
    );
  }

  Widget _buildSectionTile(BuildContext context,
      {required String title, required Widget page}) {
    return Card(
      color: Colors.purple[50],
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.br10),
        side: BorderSide(color: Colors.purple.shade200, width: 1.5),
      ),
      child: ListTile(
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.purple),
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
