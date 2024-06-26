import 'package:flutter/material.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

class BannerWidget extends StatelessWidget {
  final String imagePath;
  final String text;

  const BannerWidget({Key? key, required this.imagePath, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(AppConstants.paddingMedium),
              child: Text(
                text,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}