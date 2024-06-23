import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:tobetoapp/bloc/auth/auth_drawer/auth_provider_drawer.dart';
import 'package:tobetoapp/screens/guest/contact.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/utils/theme/light/light_theme.dart';
import 'package:tobetoapp/widgets/common_app_bar.dart';
import 'package:tobetoapp/widgets/common_footer.dart';
import 'package:tobetoapp/widgets/guest/institutions_card.dart';

class ForInstitutions extends StatelessWidget {
  const ForInstitutions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      drawer: const DrawerManager(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            children: [
              Text(
                "Tobeto; yetenekleri keşfeder, geliştirir ve yeni işine hazırlar.",
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: const Color.fromARGB(255, 50, 4, 58)),
              ),
              SizedBox(height: AppConstants.sizedBoxHeightLarge),
              ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.br30),
                  child: Image.asset('assets/pictures/foto2.jpg')),
              SizedBox(height: AppConstants.sizedBoxHeightXLarge),
              Column(
                children: [
                  InstitutionsSection(
                    mainTitle: "Doğru yeteneğe ulaşmak için",
                    subtitle:
                        "Kurumların değişen yetenek ihtiyaçları için istihdama hazır adaylar yetiştirir.",
                    color: const Color.fromARGB(255, 108, 43, 161),
                    cards: [
                      const InstitutionsCard(
                        title: "DEĞERLENDİRME",
                        content:
                            "Değerlendirilmiş ve yetişmiş geniş yetenek havuzuna erişim olanağı ve ölçme, değerlendirme, seçme ve raporlama hizmeti.",
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightLarge),
                      const InstitutionsCard(
                        title: "BOOTCAMP",
                        content:
                            "Değerlendirilmiş ve yetişmiş geniş yetenek havuzuna erişim olanağı ve ölçme, değerlendirme, seçme ve raporlama hizmeti.",
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightLarge),
                      const InstitutionsCard(
                        title: "EŞLEŞTİRME",
                        content:
                            "Esnek, uzaktan, tam zamanlı iş gücü için doğru ve hızlı işe alım.",
                      ),
                    ],
                  ),
                  SizedBox(height: AppConstants.sizedBoxHeightXLarge),
                  SizedBox(height: AppConstants.sizedBoxHeightXLarge),
                  InstitutionsSection(
                    mainTitle: "Çalışanlarınız için Tobeto",
                    subtitle:
                        "Çalışanların ihtiyaçları doğrultusunda, mevcut becerilerini güncellemelerine veya yeni beceriler kazanmalarına destek olur.",
                    color: const Color.fromARGB(255, 28, 30, 150),
                    cards: [
                      const InstitutionsCard(
                        title: "ÖLÇME ARAÇLARI",
                        content:
                            "Uzmanlaşmak için yeni beceriler kazanmak (reskill) veya yeni bir role başlamak (upskill) isteyen adaylar için, teknik ve yetkinlik ölçme araçları.",
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightLarge),
                      const InstitutionsCard(
                        title: "EĞİTİM",
                        content:
                            "Yeni uzmanlık becerileri ve yeni bir rol için gerekli yetkinlik kazınımı ihtiyaçlarına bağlı olarak açılan eğitimlere katılım ve kuruma özel sınıf açma olanakları.",
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightLarge),
                      const InstitutionsCard(
                        title: "GELİŞİM",
                        content:
                            "Kurumsal hedefler doğrultusunda mevcut yetenek gücünün gelişimi ve konumlandırılmasına destek.",
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: AppConstants.sizedBoxHeightXLarge),
              SizedBox(height: AppConstants.sizedBoxHeightXXLarge),
              OutlineGradientButton(
                padding: EdgeInsets.all(AppConstants.paddingLarge),

                strokeWidth: 3,
                radius: Radius.circular(AppConstants.br30), //40
                gradient: const LinearGradient(
                  colors: [
                    AppColors.tobetoMoru,
                    Colors.white30,
                    AppColors.tobetoMoru,
                    Colors.white30
                  ],
                  stops: [0.0, 0.5, 0.5, 1.0],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Kurumlara özel eğitim paketleri ve bootcamp programları için bizimle iletişime geçin.",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppConstants.sizedBoxHeightMedium),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.tobetoMoru,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.screenWidth * 0.1,
                          vertical: AppConstants.screenHeight * 0.02,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Contact()));
                      },
                      child: Text(
                        "Bize Ulaşın",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppConstants.sizedBoxHeightXXLarge),
              const CommonFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
