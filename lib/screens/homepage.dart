import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:provider/provider.dart';
import 'package:tobetoapp/bloc/auth/auth_drawer/auth_provider_drawer.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/screens/auth.dart';
import 'package:tobetoapp/utils/theme/light/light_theme.dart';
import 'package:tobetoapp/widgets/common_app_bar.dart';
import 'package:tobetoapp/widgets/common_footer.dart';
import 'package:tobetoapp/widgets/guest/homepage_content.dart';
import 'package:tobetoapp/widgets/guest/animated_avatar.dart';
import 'package:tobetoapp/widgets/guest/animated_container.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late PageController _controller;
  int _currentPage = 0;

  final List<Map<String, String>> _users = [
    {
      'username': 'Zehra Temizel',
      'comment':
          'Tobeto ve İstanbul Kodluyor, kariyerim için çizmek istediğim rotayı belirlememde, harekete geçmemde ve işe başlamamda bana rehberlik etti. Programın ilk mezunlarından olarak İstanbul Kodluyor sürecinin bir parçası olmaktan mutluluk duyuyorum.'
    },
    {
      'username': 'Zeynep Aşiyan Koşun',
      'comment':
          'Tobeto ve İstanbul Kodluyor Projesi, kariyerimde ksybolmuş hissettiğim bir dönemde karşıma çıktı ve gerçek bir pusula gibi yol gösterdi. Artık hangi yöne ilerleyeceğim konusunda daha eminim. Tobeto ailesine minnettarım, benim için gerçek bir destek ve ilham kaynağı oldular. İyi ki varsınız, Tobeto ailesi.'
    },
    {
      'username': 'Hüseyin Oğuzhan Şan',
      'comment':
          'İnsanın yeterince istediği ve emek verdiği her şeyi başarabileceğine inanan bir ekibin liderliğindeki muhteşem oluşum. Üstelik paydaşları ilgili alandaki en iyi isimler ve organizasyonlar.'
    },
    {
      'username': 'Atilla Güngör',
      'comment':
          'Tobeto\'daki .NET ve React Fullstack eğitimi, yazılım dünyasında daha sağlam adım atmamı sağlayan önemli bir deneyim oldu. Bu eğitimde hem teknik bilgi hem de pratik uygulama becerileri kazandım. Ayrıca, softskill eğitimleri sayesinde iletişim ve problem çözme yeteneklerim de gelişti. Tobeto ekibi her zaman yardımcı oldu ve sorularımı cevaplamak için ellerinden geleni yaptı. Bu süreçte aldığım destek sayesinde, şimdi daha güvenli bir şekilde yazılım geliştirme yolculuğuma devam edebiliyorum. Tobeto\'daki eğitim süreci, şimdi iş dünyasına hazır olduğumu hissettiriyor. Teşekkürler Tobeto!'
    },
  ];
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = Random().nextInt(_users.length);
    _controller = PageController();
  }

  void _onAvatarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> _assetPaths = [
    "assets/logo/enocta.png",
    "assets/logo/advancity.png",
    "assets/logo/code2.png",
    "assets/logo/perculus.webp",
    "assets/logo/talent.png",
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animationControl = Provider.of<AnimationControllerExample>(context);

    return Scaffold(
      appBar: const CommonAppBar(),
      drawer: const DrawerManager(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppConstants.paddingSmall),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.br16)),
              child: SizedBox(
                height: AppConstants.screenHeight,
                child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(
                      scrollbars: false,
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: PageView.builder(
                        controller: _controller,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return index == 0
                              ? const ContentHomepage(
                                  imagePath: "assets/pictures/foto1.jpg",
                                  title:
                                      "Hayalindeki teknoloji kariyerini Tobeto ile başlat.",
                                  subtitle1:
                                      "Tobeto eğitimlerine katıl, sen de harekete geç, iş hayatında yerini al.",
                                  subtitle2: "")
                              : const ContentHomepage(
                                  imagePath: "assets/pictures/foto2.jpg",
                                  title: "Tobeto Platform",
                                  subtitle1:
                                      "Eğitim ve istihdam arasında köprü görevi görür.",
                                  subtitle2:
                                      "Eğitim, değerlendirme, istihdam süreçlerinin tek yerden yönetilebileceği dijital platform olarak hem bireylere hem kurumlara hizmet eder.");
                        })),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(2, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: _currentPage == index ? 10 : 6,
                      height: _currentPage == index ? 10 : 6,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? const Color.fromARGB(221, 68, 67, 67)
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
                SizedBox(height: AppConstants.sizedBoxHeightLarge),
                const Divider(),
                SizedBox(height: AppConstants.sizedBoxHeightLarge),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppConstants.paddingMedium),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppConstants.br16),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Birlikte ",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Color.fromARGB(255, 100, 39, 150),
                                  shadows: [
                                    Shadow(
                                      color: Colors.black45,
                                      blurRadius: 3,
                                      offset: Offset(3, 1),
                                    ),
                                  ],
                                ),
                              ),
                              TextSpan(
                                text: "Büyüyoruz!",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 100, 39, 150),
                                  shadows: [
                                    Shadow(
                                      color: Colors.black45,
                                      blurRadius: 3,
                                      offset: Offset(3, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppConstants.sizedBoxHeightLarge),
                SizedBox(
                  width: AppConstants.screenWidth * 0.9,
                  height: AppConstants.screenWidth * 0.9,
                  child: OverflowBox(
                    maxWidth: double.infinity,
                    maxHeight: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        animationControl.changeProperties();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: animationControl.color, width: 6),
                          borderRadius:
                              BorderRadius.circular(AppConstants.br20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              animationControl.icon,
                              size: AppConstants.profileImageSize,
                            ),
                            SizedBox(height: AppConstants.sizedBoxHeightMedium),
                            Text(
                              "${animationControl.number}",
                              style: TextStyle(
                                  fontSize: 40,
                                  color: animationControl.color,
                                  fontWeight: FontWeight.w900),
                            ),
                            SizedBox(height: AppConstants.sizedBoxHeightMedium),
                            Center(
                              child: Text(
                                animationControl.text,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                        color: Colors.black.withOpacity(0.5),
                                        fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppConstants.sizedBoxHeightXXLarge),
                const Divider(),
                SizedBox(height: AppConstants.sizedBoxHeightXXLarge),
                Padding(
                  padding: EdgeInsets.all(AppConstants.paddingMedium),
                  child: OutlineGradientButton(
                    strokeWidth: 3,
                    radius: Radius.circular(AppConstants.br30),
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
                    child: Padding(
                      padding: EdgeInsets.all(AppConstants.paddingMedium),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Tobeto \"İşte Başarı Modeli\"mizi Keşfet!",
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: AppConstants.sizedBoxHeightSmall),
                          Text(
                            "Üyelerimize ücretsiz sunduğumuz, iş bulma ve işte başarılı olma sürecinde gerekli 80 tane davranış ifadesinden oluşan Tobeto 'İşte Başarı Modeli' ile, profesyonellik yetkinliklerini ölç, raporunu gör.",
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: AppConstants.sizedBoxHeightLarge),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Auth()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.tobetoMoru,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppConstants.br30),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: AppConstants.screenWidth * 0.15,
                                vertical: AppConstants.screenHeight * 0.025,
                              ),
                            ),
                            child: Text(
                              "Hemen Başla",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          SizedBox(height: AppConstants.sizedBoxHeightLarge),
                          SizedBox(height: AppConstants.sizedBoxHeightLarge),
                          Image.asset("assets/gif/spider_light.gif"),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppConstants.sizedBoxHeightLarge),
                const Divider(),
                SizedBox(height: AppConstants.sizedBoxHeightLarge),
                Padding(
                  padding: EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Öğrenci Görüşleri",
                        style: Theme.of(context).textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightSmall),
                      Text(
                        "Tobeto'yu öğrencilerimizin gözünden keşfedin.",
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightLarge),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_users.length, (index) {
                            return GestureDetector(
                              onTap: () => _onAvatarTap(index),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AnimatedAvatar(
                                  isSelected: _selectedIndex == index,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightLarge),
                      if (_selectedIndex != -1)
                        Container(
                          padding: EdgeInsets.all(AppConstants.paddingMedium),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppConstants.br16),
                            gradient: LinearGradient(
                                colors: [
                                  AppColors.tobetoMoru,
                                  Colors.grey.withOpacity(0.5)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 9,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                _users[_selectedIndex]['username']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _users[_selectedIndex]['comment']!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: AppConstants.sizedBoxHeightXXLarge),
                      const Divider(),
                      SizedBox(height: AppConstants.sizedBoxHeightXXLarge),
                      Column(
                        children: [
                          Text(
                            "Çözüm Ortaklarımız",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          SizedBox(height: AppConstants.sizedBoxHeightMedium),
                          Container(
                            margin: EdgeInsets.all(AppConstants.paddingMedium),
                            padding: EdgeInsets.all(AppConstants.paddingMedium),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppConstants.br16),
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.white24,
                                  AppColors.tobetoMoru,
                                ],
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _assetPaths.length,
                                (index) => Image.asset(
                                  _assetPaths[index],
                                  width: AppConstants.screenWidth * 0.4,
                                  height: AppConstants.screenWidth * 0.3,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: AppConstants.sizedBoxHeightLarge),
                          const CommonFooter(),
                        ],
                      ),
                    ],
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
