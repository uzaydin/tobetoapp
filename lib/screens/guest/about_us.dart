import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tobetoapp/widgets/common_app_bar.dart';
import 'package:tobetoapp/widgets/common_footer.dart';
import 'package:tobetoapp/widgets/guest/common_drawer.dart';
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
        backgroundColor: const Color.fromARGB(232, 255, 255, 255),
        appBar: const CommonAppBar(),
        endDrawer: const CommonDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                            width: 2,
                          ),
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
                                const SizedBox(width: 40),
                                const Text.rich(
                                  TextSpan(
                                    text:
                                        "Yeni Nesil\n Mesleklere,\n Yeni Nesil\n ",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Platform!\" ",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 163, 77, 233),
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
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
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset('assets/pictures/foto3.webp'),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text.rich(
                        TextSpan(
                          text:
                              'Yeni nesil mesleklerdeki yetenek açığının mevcut yüksek deneyim ve beceri beklentisinden uzaklaşıp yeteneği keşfederek ve onları en iyi versiyonlarına ulaştırarak çözülebileceğine inanıyoruz. Tobeto; yetenekleri potansiyellerine göre değerlendirir, onları en uygun alanlarda geliştirir ve değer yaratacak projelerle eşleştirir.',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: " YES (Yetiş-Eşleş-Sürdür) ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            TextSpan(
                              text:
                                  "ilkesini benimseyen herkese Tobeto Ailesi'ne katılmaya davet ediyor.",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        //textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text.rich(
                        TextSpan(
                          text:
                              "Günümüzde meslek hayatında yer almak ve kariyerinde yükselmek için en önemli unsurların başında ",
                          style: TextStyle(fontSize: 16),
                          children: [
                            TextSpan(
                              text: "dijital beceri sahibi olmak ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            TextSpan(
                              text:
                                  "geliyor. Bu ihtiyaçların tamamını karşılamak için içeriklerimizi Tobeto Platform’da birleştirdik.",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset('assets/pictures/foto4.jpg'),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset('assets/pictures/foto1.jpg'),
                    ),
                    const SizedBox(height: 30),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text.rich(
                        TextSpan(
                            text:
                                "Öğrencilerin teoriyi anlamalarını önemsemekle beraber ",
                            style: TextStyle(fontSize: 16),
                            children: [
                              TextSpan(
                                text: "uygulamayı merkeze alan ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              TextSpan(
                                text:
                                    "bir öğrenme yolculuğu sunuyoruz. Öğrenciyi sürekli gelişim, geri bildirim döngüsünde tutarak yetenek ve beceri kazanımını hızlandırıyoruz.",
                                style: TextStyle(fontSize: 16),
                              )
                            ]),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 2),
                        ),
                        child: const RotatingSentenceList(
                            title: "TOBETO FARKI\n NEDİR?"),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(30),
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      child: const Column(
                        children: [
                          Text(
                            "EKİBİMİZ",
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(height: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TeamCard(
                                imagePath: "assets/ekip/elif_kilic.jpeg",
                                name: "Elif Kılıç",
                                title: "Kurucu Direktör",
                                linkedInUrl:
                                    'https://www.linkedin.com/in/eliftugtan/',
                              ),
                              TeamCard(
                                imagePath: "assets/ekip/kader_yavuz.jpg",
                                name: "Kader Yavuz",
                                title: "Eğitim ve Proje Koordinatörü",
                                linkedInUrl:
                                    'https://www.linkedin.com/in/kader-yavuz/',
                              ),
                              TeamCard(
                                imagePath: "assets/ekip/pelin_batir.png",
                                name: "Pelin Batır",
                                title: "İş Geliştirme ve Yöneticisi",
                                linkedInUrl: '',
                              ),
                              TeamCard(
                                imagePath: "assets/ekip/gurkan_ilisen.jfif",
                                name: "Gürkan İlişen",
                                title:
                                    "Eğitim Teknolojileri ve Platform Sorumlusu",
                                linkedInUrl:
                                    'https://www.linkedin.com/in/gürkanilişen/',
                              ),
                              TeamCard(
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
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.blueGrey,
                            width: 3,
                          ),
                          color: Colors.white,
                        ),
                        child: const Column(
                          children: [
                            SizedBox(height: 10),
                            Text(
                              "Ofisimiz",
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 30),
                            Text(
                              "Kavacık, Rüzgarlıbahçe Mah. Çampınarı Sok. No:4 Smart Plaza B Blok Kat:3 34805, Beykoz,İstanbul",
                              style: TextStyle(fontSize: 17),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.blueGrey,
                            width: 3,
                          ),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () =>
                                    launchUrlString(commonFooter.facebookUrl),
                                icon: FaIcon(
                                  FontAwesomeIcons.facebook,
                                  size: 40,
                                  color: Colors.blue.shade800,
                                )),
                            IconButton(
                              onPressed: () =>
                                  launchUrlString(commonFooter.xUrl),
                              icon: const FaIcon(
                                FontAwesomeIcons.twitter,
                                size: 40,
                                color: Colors.lightBlue,
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  launchUrlString(commonFooter.linkedinUrl),
                              icon: FaIcon(
                                FontAwesomeIcons.linkedin,
                                size: 40,
                                color: Colors.blue.shade900,
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  launchUrlString(commonFooter.instagramUrl),
                              icon: const FaIcon(
                                FontAwesomeIcons.instagram,
                                size: 40,
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
