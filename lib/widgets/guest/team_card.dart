import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/utils/theme/light/light_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String title;
  final String linkedInUrl;
  const TeamCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.title,
    required this.linkedInUrl,
  });

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw '$url Başlatılamadı..';
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlineGradientButton(
      onTap: () => _launchUrl(linkedInUrl),
      strokeWidth: 3,
      radius: Radius.circular(AppConstants.br30),
      gradient: const LinearGradient(
        colors: [
          AppColors.tobetoMoru,
          Color.fromARGB(209, 255, 255, 255),
          Color.fromARGB(178, 255, 255, 255),
          AppColors.tobetoMoru,
        ],
        stops: [0.0, 0.5, 0.5, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppConstants.paddingMedium),
        padding: EdgeInsets.all(AppConstants.paddingLarge),
        width: double.infinity,
        constraints:
            BoxConstraints(minHeight: AppConstants.profileImageSize + 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: AppConstants.profileImageSize,
              backgroundImage: AssetImage(imagePath),
            ),
            SizedBox(height: AppConstants.sizedBoxHeightSmall),
            Text(
              name,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppConstants.sizedBoxHeightSmall),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 151, 149, 149),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
