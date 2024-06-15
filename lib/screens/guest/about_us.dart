import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:provider/provider.dart';
import 'package:tobetoapp/bloc/auth/auth_drawer/auth_provider_drawer.dart';
import 'package:tobetoapp/theme/constants/constants.dart';
import 'package:tobetoapp/theme/light/light_theme.dart';
import 'package:tobetoapp/widgets/common_app_bar.dart';
import 'package:tobetoapp/widgets/common_footer.dart';
import 'package:tobetoapp/widgets/guest/controls_overlay.dart';
import 'package:tobetoapp/widgets/guest/team_card.dart';
import 'package:tobetoapp/widgets/guest/tobeto_difference.dart';
import 'package:tobetoapp/widgets/validation_video_controller.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/video_player.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _HakkimizdaState();
}

class _HakkimizdaState extends State<AboutUs> {
  final commonFooter = const CommonFooter();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => VideoController('assets/video/tobeto_video.mp4'),
        ),
        ChangeNotifierProvider(
          create: (_) => SentenceProvider(),
        ),
      ],
      child: Scaffold(
        appBar: const CommonAppBar(),
        drawer: const DrawerManager(),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppConstants.paddingMedium),
                      child: OutlineGradientButton(
                        padding: EdgeInsets.all(AppConstants.paddingLarge),
                        strokeWidth: 3,
                        radius: Radius.circular(AppConstants.br16),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/logo/tobeto.png',
                                ),
                                SizedBox(
                                    width: AppConstants.sizedBoxWidthXLarge),
                                Text.rich(
                                  TextSpan(
                                    text:
                                        "Yeni Nesil\n Mesleklere,\n Yeni Nesil\n ",
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                    children: [
                                      TextSpan(
                                        text: "Platform!\" ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                color: AppColors.tobetoMoru),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            SizedBox(height: AppConstants.sizedBoxHeightXLarge),
                            Consumer<VideoController>(
                              builder: (context, videoController, child) {
                                return videoController.isInitilized
                                    ? AspectRatio(
                                        aspectRatio: videoController
                                            .controller.value.aspectRatio,
                                        child: Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            VideoPlayer(
                                                videoController.controller),
                                            const ControlsOverlay(),
                                            VideoProgressIndicator(
                                                videoController.controller,
                                                allowScrubbing: true),
                                          ],
                                        ),
                                      )
                                    : const CircularProgressIndicator();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: AppConstants.sizedBoxHeightXLarge),
                    Container(
                      padding: EdgeInsets.all(AppConstants.paddingMedium),
                      child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppConstants.br30),
                          child: Image.asset('assets/pictures/foto3.webp')),
                    ),
                    SizedBox(height: AppConstants.sizedBoxHeightMedium),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingMedium),
                      child: Text.rich(
                        TextSpan(
                          text:
                              'Yeni nesil mesleklerdeki yetenek açığının mevcut yüksek deneyim ve beceri beklentisinden uzaklaşıp yeteneği keşfederek ve onları en iyi versiyonlarına ulaştırarak çözülebileceğine inanıyoruz. Tobeto; yetenekleri potansiyellerine göre değerlendirir, onları en uygun alanlarda geliştirir ve değer yaratacak projelerle eşleştirir.',
                          style: Theme.of(context).textTheme.bodySmall,
                          children: [
                            TextSpan(
                              text: " YES (Yetiş-Eşleş-Sürdür) ",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            TextSpan(
                              text:
                                  "ilkesini benimseyen herkese Tobeto Ailesi'ne katılmaya davet ediyor.",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: AppConstants.sizedBoxHeightMedium),
                    Padding(
                      padding: EdgeInsets.all(AppConstants.paddingMedium),
                      child: Text.rich(
                        TextSpan(
                          text:
                              "Günümüzde meslek hayatında yer almak ve kariyerinde yükselmek için en önemli unsurların başında ",
                          style: Theme.of(context).textTheme.bodySmall,
                          children: [
                            TextSpan(
                              text: "dijital beceri sahibi olmak ",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            TextSpan(
                              text:
                                  "geliyor. Bu ihtiyaçların tamamını karşılamak için içeriklerimizi Tobeto Platform’da birleştirdik.",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: AppConstants.sizedBoxHeightLarge),
                    Container(
                      padding: EdgeInsets.all(AppConstants.paddingMedium),
                      child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppConstants.br30),
                          child: Image.asset('assets/pictures/foto4.jpg')),
                    ),
                    SizedBox(height: AppConstants.sizedBoxHeightLarge),
                    Container(
                      padding: EdgeInsets.all(AppConstants.paddingMedium),
                      child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppConstants.br30),
                          child: Image.asset('assets/pictures/foto1.jpg')),
                    ),
                    SizedBox(height: AppConstants.sizedBoxHeightLarge),
                    Padding(
                      padding: EdgeInsets.all(AppConstants.paddingMedium),
                      child: Text.rich(
                        TextSpan(
                            text:
                                "Öğrencilerin teoriyi anlamalarını önemsemekle beraber ",
                            style: Theme.of(context).textTheme.bodySmall,
                            children: [
                              TextSpan(
                                text: "uygulamayı merkeze alan ",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              TextSpan(
                                text:
                                    "bir öğrenme yolculuğu sunuyoruz. Öğrenciyi sürekli gelişim, geri bildirim döngüsünde tutarak yetenek ve beceri kazanımını hızlandırıyoruz.",
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            ]),
                      ),
                    ),
                    SizedBox(height: AppConstants.sizedBoxHeightXLarge),
                    Container(
                      padding: EdgeInsets.all(AppConstants.paddingMedium),
                      child: OutlineGradientButton(
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
                        padding: EdgeInsets.all(AppConstants.paddingMedium),
                        radius: Radius.circular(AppConstants.br20),
                        strokeWidth: 3,
                        child: const RotatingSentenceList(
                            title: "TOBETO FARKI\n NEDİR?"),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(AppConstants.paddingLarge),
                      margin: EdgeInsets.symmetric(
                          vertical: AppConstants.paddingLarge),
                      child: Column(
                        children: [
                          Text(
                            "EKİBİMİZ",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          SizedBox(height: AppConstants.sizedBoxHeightMedium),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const TeamCard(
                                imagePath: "assets/ekip/elif_kilic.jpeg",
                                name: "Elif Kılıç",
                                title: "Kurucu Direktör",
                                linkedInUrl:
                                    'https://www.linkedin.com/in/eliftugtan/',
                              ),
                              SizedBox(
                                  height: AppConstants.sizedBoxHeightLarge),
                              const TeamCard(
                                imagePath: "assets/ekip/kader_yavuz.jpg",
                                name: "Kader Yavuz",
                                title: "Eğitim ve Proje Koordinatörü",
                                linkedInUrl:
                                    'https://www.linkedin.com/in/kader-yavuz/',
                              ),
                              SizedBox(
                                  height: AppConstants.sizedBoxHeightLarge),
                              const TeamCard(
                                imagePath: "assets/ekip/pelin_batir.png",
                                name: "Pelin Batır",
                                title: "İş Geliştirme ve Yöneticisi",
                                linkedInUrl: '',
                              ),
                              SizedBox(
                                  height: AppConstants.sizedBoxHeightLarge),
                              const TeamCard(
                                imagePath: "assets/ekip/gurkan_ilisen.jfif",
                                name: "Gürkan İlişen",
                                title:
                                    "Eğitim Teknolojileri ve Platform Sorumlusu",
                                linkedInUrl:
                                    'https://www.linkedin.com/in/gürkanilişen/',
                              ),
                              SizedBox(
                                  height: AppConstants.sizedBoxHeightLarge),
                              const TeamCard(
                                imagePath: "assets/ekip/ali_seyhan.jpg",
                                name: "Ali Seyhan",
                                title: "Operasyon Uzman Yardımcısı",
                                linkedInUrl:
                                    'https://tr.linkedin.com/in/aliseyhnn',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppConstants.sizedBoxHeightLarge),
                    Container(
                      padding: EdgeInsets.all(AppConstants.paddingMedium),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppConstants.br16),
                        border: Border.all(
                          color: const Color.fromARGB(250, 235, 221, 221)
                              .withOpacity(0.2),
                          width: 3,
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: AppConstants.sizedBoxHeightSmall),
                          Text(
                            "Ofisimiz",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          SizedBox(height: AppConstants.sizedBoxHeightLarge),
                          Text(
                            "Kavacık, Rüzgarlıbahçe Mah. Çampınarı Sok. No:4 Smart Plaza B Blok Kat:3 34805, Beykoz,İstanbul",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(height: AppConstants.sizedBoxHeightMedium),
                        ],
                      ),
                    ),
                    SizedBox(height: AppConstants.sizedBoxHeightLarge),
                    Container(
                      padding: EdgeInsets.all(AppConstants.paddingMedium),
                      child: Container(
                        padding: EdgeInsets.all(AppConstants.paddingMedium),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppConstants.br16),
                          border: Border.all(
                            color: const Color.fromARGB(250, 235, 221, 221)
                                .withOpacity(0.2),
                            width: 3,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () =>
                                    launchUrlString(commonFooter.facebookUrl),
                                icon: FaIcon(
                                  FontAwesomeIcons.facebook,
                                  size: AppConstants.profileImageSize / 1.6,
                                  color: Colors.blue.shade800,
                                )),
                            IconButton(
                              onPressed: () =>
                                  launchUrlString(commonFooter.xUrl),
                              icon: FaIcon(
                                FontAwesomeIcons.twitter,
                                size: AppConstants.profileImageSize / 1.6,
                                color: Colors.lightBlue,
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  launchUrlString(commonFooter.linkedinUrl),
                              icon: FaIcon(
                                FontAwesomeIcons.linkedin,
                                size: AppConstants.profileImageSize / 1.6,
                                color: Colors.blue.shade900,
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  launchUrlString(commonFooter.instagramUrl),
                              icon: FaIcon(
                                FontAwesomeIcons.instagram,
                                size: AppConstants.profileImageSize / 1.6,
                                color: Colors.pink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
