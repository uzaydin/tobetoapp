import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:provider/provider.dart';
import 'package:tobetoapp/widgets/guest/animated_container.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:tobetoapp/bloc/auth/auth_drawer/drawer_manager.dart';
import 'package:tobetoapp/screens/auth.dart';
import 'package:tobetoapp/services/student_comment_service.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/utils/theme/light/light_theme.dart';
import 'package:tobetoapp/widgets/common_app_bar.dart';
import 'package:tobetoapp/widgets/common_footer.dart';
import 'package:tobetoapp/widgets/guest/animated_avatar.dart';
import 'package:tobetoapp/widgets/guest/homepage_content.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late PageController _controller;
  int _currentPage = 0;
  late WebViewController webViewController;
  bool canGoBack = false;

  final StudentCommentService _userService = StudentCommentService();
  List<Map<String, dynamic>> _users = [];
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _fetchStudentComments();

    _controller = PageController();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color.fromARGB(0, 255, 255, 255))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) async {
            canGoBack = await webViewController.canGoBack();
            setState(() {});
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://mediafiles.botpress.cloud/7df64e85-0771-427d-aa97-220335183397/webchat/bot.html'));
  }

  Future<void> _fetchStudentComments() async {
    List<Map<String, dynamic>> users = await _userService.getStudentComments();
    setState(() {
      _users = users;
      _selectedIndex = Random().nextInt(_users.length);
    });
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

  void _showChatBotPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: AppColors.tobetoMoru,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: WebViewWidget(
                      controller: webViewController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final animationControl = Provider.of<AnimationControllerExample>(context);

    return Scaffold(
      appBar: const CommonAppBar(),
      drawer: DrawerManager(),
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
                                padding:
                                    EdgeInsets.all(AppConstants.paddingSmall),
                                child: AnimatedAvatar(
                                  isSelected: _selectedIndex == index,
                                  photoUrl: _users[index]['photoUrl'],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightLarge),
                      if (_selectedIndex != -1 &&
                          _selectedIndex < _users.length)
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
                                _users[_selectedIndex]['username'],
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _users[_selectedIndex]['comment'],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showChatBotPopup(context);
        },
        backgroundColor: AppColors.tobetoMoru,
        child: const Icon(Icons.message),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
