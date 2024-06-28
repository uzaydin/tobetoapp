import 'package:flutter/material.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppConstants.init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Başvurularım'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(AppConstants.paddingSmall),
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(left: AppConstants.paddingMedium),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppConstants.br10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(AppConstants.paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/istanbul_kodluyor.jpg', // Düzeltilen resim yolu
                              width: AppConstants.screenWidth * 0.15,
                            ),
                            SizedBox(width: AppConstants.sizedBoxWidthSmall),
                            const Text(
                              'İstanbul Kodluyor',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppConstants.paddingSmall,
                                vertical: AppConstants.paddingSmall / 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                    0xFF006400), // Kabul Edildi rengi
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(AppConstants.br10),
                                  bottomLeft:
                                      Radius.circular(AppConstants.br10),
                                ),
                              ),
                              child: const Text(
                                'Kabul Edildi',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppConstants.sizedBoxHeightSmall),
                        const Text(
                          'Bilgilendirme',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: 10,
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFF006400), // Sol taraftaki yeşil çıkıntı rengi
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppConstants.br10),
                        bottomLeft: Radius.circular(AppConstants.br10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
