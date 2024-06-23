import 'package:flutter/material.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

class InstitutionsCard extends StatelessWidget {
  final String title;
  final String content;
  final Color backgroundColor = Colors.white;
  const InstitutionsCard(
      {super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.br10),
        color: backgroundColor,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: Colors.black),
          ),
          SizedBox(height: AppConstants.sizedBoxHeightSmall),
          Text(
            content,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.black),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}

class InstitutionsSection extends StatelessWidget {
  final String mainTitle;
  final String subtitle;
  final Color color;
  final List<Widget> cards;
  const InstitutionsSection(
      {super.key,
      required this.mainTitle,
      required this.subtitle,
      required this.cards,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.br20),
        boxShadow: [
          BoxShadow(
            color: Colors.black45.withOpacity(0.5),
            offset: const Offset(4.0, 4.0),
            blurRadius: 10.0,
            spreadRadius: 3.0,
          )
        ],
        color: color,
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              mainTitle,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppConstants.sizedBoxHeightSmall),
            Text(
              subtitle,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppConstants.sizedBoxHeightMedium),
            ...cards,
          ],
        ),
      ),
    );
  }
}
