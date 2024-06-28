import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

class WorkflowsPage extends StatelessWidget {
  const WorkflowsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İş Süreçleri'),
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
                        'assets/images/boş_liste.svg',
                        width: AppConstants.screenWidth *
                            0.5, // Ekran genişliğinin %50'si kadar genişlik ayarlanıyor
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightMedium),
                      const Text(
                        'Henüz size atanan bir mülakat bulunmamaktadır!',
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
