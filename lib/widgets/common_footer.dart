import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/utils/theme/light/light_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonFooter extends StatelessWidget {
  const CommonFooter({super.key});

  final String facebookUrl = 'https://www.facebook.com/tobetoplatform/';
  final String instagramUrl = 'https://www.instagram.com/tobeto_official/';
  final String xUrl = 'https://x.com/tobeto_platform';
  final String linkedinUrl = 'https://tr.linkedin.com/company/tobeto';

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw '$url Başlatılamadı..';
    }
  }

  @override
  Widget build(BuildContext context) {
    Color iconColor = AppColors.tobetoMoru;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: AppConstants.sizedBoxHeightMedium),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.tobetoMoru, width: 2.0),
            ),
          ),
        ),
        SizedBox(height: AppConstants.sizedBoxHeightMedium),
        SizedBox(
          width: AppConstants.screenWidth * 0.4,
          child: Image.asset(
            'assets/logo/tobetologo.PNG',
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: AppConstants.sizedBoxHeightMedium),
        Text(
          "© 2024 Tobeto I Her Hakkı Saklıdır.",
          style: Theme.of(context).textTheme.labelLarge,
        ),
        SizedBox(height: AppConstants.sizedBoxHeightMedium),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => _launchUrl(facebookUrl),
              icon: const FaIcon(FontAwesomeIcons.facebook),
              color: iconColor,
            ),
            IconButton(
              onPressed: () => _launchUrl(xUrl),
              icon: const FaIcon(FontAwesomeIcons.twitter),
              color: iconColor,
            ),
            IconButton(
              onPressed: () => _launchUrl(instagramUrl),
              icon: const FaIcon(FontAwesomeIcons.instagram),
              color: iconColor,
            ),
            IconButton(
              onPressed: () => _launchUrl(linkedinUrl),
              icon: const FaIcon(FontAwesomeIcons.linkedin),
              color: iconColor,
            ),
          ],
        ),
      ],
    );
  }
}
