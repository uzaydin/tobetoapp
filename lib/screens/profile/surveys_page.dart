import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

class SurveysPage extends StatelessWidget {
  const SurveysPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anketlerim'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/boş_liste.svg', // Anketler için SVG dosyasının yolu
                        width: AppConstants.screenWidth *
                            0.5, // Ekran genişliğinin %50'si kadar genişlik ayarlanıyor
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightMedium),
                      const Text(
                        'Atanmış herhangi bir anketiniz bulunmamaktadır!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.purple,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
