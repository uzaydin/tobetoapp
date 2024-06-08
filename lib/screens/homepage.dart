import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tobetoapp/screens/auth.dart';
import 'package:tobetoapp/widgets/common_app_bar.dart';
import 'package:tobetoapp/widgets/common_footer.dart';
import 'package:tobetoapp/widgets/guest/homepage_contentdart';
import 'package:tobetoapp/widgets/guest/animated_avatar.dart';
import 'package:tobetoapp/widgets/guest/animated_container.dart';
import 'package:tobetoapp/widgets/guest/common_drawer.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Homepage> {
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
    "assets/logo/advancity.jpg",
    "assets/logo/code2.png",
    "assets/logo/perculus.jpg",
    "assets/logo/talent.png",
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final animationControl = Provider.of<AnimationControllerExample>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(),
      drawer: const CommonDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: SizedBox(
                height: screenHeight,
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
                          return index == 0 ? buildPage1() : buildPage2();
                        })),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(2, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: _currentPage == index ? 10 : 6,
                      height: _currentPage == index ? 10 : 6,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.black87
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
                const Divider(),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
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
                                  fontSize: 28,
                                  color: Color.fromARGB(255, 100, 39, 150),
                                ),
                              ),
                              TextSpan(
                                text: "Büyüyoruz!",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 100, 39, 150),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: OverflowBox(
                    maxWidth: double.infinity,
                    maxHeight: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        animationControl.changeProperties();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        width: animationControl.width,
                        height: animationControl.height,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: animationControl.color, width: 5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              animationControl.icon,
                              size: 50,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "${animationControl.number}",
                              style: TextStyle(
                                  fontSize: 35,
                                  color: animationControl.color,
                                  fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Text(
                                animationControl.text,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Tobeto \"İşte Başarı Modeli\"mizi Keşfet!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Üyelerimize ücretsiz sunduğumuz, iş bulma ve işte başarılı olma sürecinde gerekli 80 tane davranış ifadesinden oluşan Tobeto 'İşte Başarı Modeli' ile, profesyonellik yetkinliklerini ölç, raporunu gör.",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Auth()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 163, 77, 233),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50.0,
                            vertical: 15.0,
                          ),
                        ),
                        child: const Text(
                          "Hemen Başla",
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Image.asset("assets/gif/spider_light.gif"),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Öğrenci Görüşleri",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Tobeto'yu öğrencilerimizin gözünden keşfedin.",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
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
                      const SizedBox(height: 30),
                      if (_selectedIndex != -1)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: //const Color.fromARGB(255, 108, 32, 170)
                                    Colors.grey.withOpacity(0.5),
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
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _users[_selectedIndex]['comment']!,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 30),
                      const Divider(),
                      const SizedBox(height: 30),
                      Column(
                        children: [
                          const Text(
                            "Çözüm Ortaklarımız",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            margin:
                                const EdgeInsets.all(10), // Dış boşluk ayarla
                            padding:
                                const EdgeInsets.all(10), // İç boşluk ayarla
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _assetPaths.length,
                                (index) => Image.asset(
                                  _assetPaths[index],
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
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
