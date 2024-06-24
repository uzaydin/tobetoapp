import 'package:flutter/material.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

// Anasayfa - giriş kısmı

class ContentHomepage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle1;
  final String subtitle2;
  const ContentHomepage(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.subtitle1,
      required this.subtitle2});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(AppConstants.paddingMedium),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.br30),
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.asset(
                imagePath,
                width: AppConstants.screenWidth * 0.9,
                height: AppConstants.screenWidth * 0.8,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: AppConstants.sizedBoxHeightLarge),
          Text(
            title,
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
          Column(
            children: [
              Text(
                subtitle1,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.w200),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppConstants.sizedBoxHeightSmall),
              Text(
                subtitle2,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.w200),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
