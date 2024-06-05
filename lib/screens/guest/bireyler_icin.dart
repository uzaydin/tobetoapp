import 'package:flutter/material.dart';
import 'package:tobetoapp/screens/guest/catalog_guest.dart';
import 'package:tobetoapp/widgets/common_app_bar.dart';
import 'package:tobetoapp/widgets/common_footer.dart';
import 'package:tobetoapp/widgets/guest/common_drawer.dart';

class BireylerIcin extends StatelessWidget {
  void navigateToCatalogPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const CatalogGuest()));
  }

  const BireylerIcin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(232, 255, 255, 255),
      appBar: const CommonAppBar(),
      endDrawer: const CommonDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildGradientContainer(
              context,
              const [
                TextSpan(
                  text: "Kontrol\n sende \n",
                  style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "adım at, \n",
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 163, 77, 233),
                      ),
                    ),
                    TextSpan(
                      text: "Tobeto ile\n fark yarat!",
                      style:
                          TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
              'assets/pictures/foto5.png',
              isFirst: true,
            ),
            const SizedBox(height: 40),
            buildImageContainer('assets/pictures/foto6.jpg', 30.0),
            const SizedBox(height: 20),
            buildTextSection(
              context,
              "Eğitim Yolculuğu",
              "Uzmanlaşmak istediğin alanı seç, Tobeto Platform'da 'Eğitim Yolculuğu'na şimdi başla.",
              const [
                "Videolu içerikler",
                "Canlı dersler",
                "Mentör desteği",
                "Hibrit eğitim modeli",
              ],
            ),
            const SizedBox(height: 60),
            buildTextSection(
              context,
              "Öğrenme Yolculuğu",
              "Deneyim sahibi olmak istediğin alanda \"Öğrenme Yolculuğu’na\" başla. Yazılım ekipleri ile çalış.",
              const [
                "Sektör projeleri",
                "Fasilitatör desteği",
                "Mentör desteği",
                "Hibrit eğitim modeli",
              ],
            ),
            const SizedBox(height: 40),
            buildImageContainer("assets/pictures/foto4.jpg", 30.0),
            const SizedBox(height: 40),
            buildImageContainer("assets/pictures/foto7.jpg", 30.0),
            const SizedBox(height: 60),
            buildTextSection(
              context,
              "Kariyer Yolculuğu",
              "Kariyer sahibi olmak istediğin alanda “Kariyer Yolculuğu'na” başla. Aradığın desteği Tobeto Platform'da yakala.",
              const [
                "Birebir mentör desteği",
                "CV Hazırlama desteği",
                "Mülakat simülasyonu",
                "Kariyer buluşmaları",
              ],
            ),
            const SizedBox(height: 60),
            buildGradientContainer(
              context,
              const [
                TextSpan(
                  text: "Kariyeriniz için\n en iyi\n yolculuklar",
                  style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
              null,
              child: buildImageRows(context),
            ),
            const SizedBox(height: 20),
            const CommonFooter(),
          ],
        ),
      ),
    );
  }

  Widget buildGradientContainer(
      BuildContext context, List<TextSpan> textSpans, String? imagePath,
      {Widget? child, bool isFirst = false}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isFirst ? const Color.fromARGB(255, 205, 186, 236) : null,
        gradient: isFirst
            ? null
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 85, 21, 138),
                  Color.fromARGB(255, 185, 87, 209),
                  Color.fromARGB(255, 42, 196, 162),
                  Colors.lightBlue,
                  Color.fromARGB(255, 21, 113, 189)
                ],
              ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text.rich(
              TextSpan(
                children: textSpans,
              ),
            ),
            const SizedBox(height: 30),
            if (imagePath != null) Image.asset(imagePath),
            if (child != null) child,
          ],
        ),
      ),
    );
  }

  Widget buildImageContainer(String imagePath, double borderRadius) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(imagePath),
      ),
    );
  }

  Widget buildTextSection(BuildContext context, String title,
      String description, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.left,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.map((item) => buildListItem(item)).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildListItem(String text) {
    return Padding(
      padding:
          const EdgeInsetsDirectional.symmetric(vertical: 5.0, horizontal: 7.0),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 10),
          const SizedBox(width: 7),
          Text(
            text,
            style: const TextStyle(fontSize: 17),
          ),
        ],
      ),
    );
  }

  Widget buildImageRows(BuildContext context) {
    List<List<String>> images = [
      ["assets/pictures/1ai.png", "assets/pictures/2proje.png"],
      ["assets/pictures/3fullstack.png", "assets/pictures/4analiz.png"],
      ["assets/pictures/5digital.png", "assets/pictures/6test.png"],
    ];

    return Column(
      children: images.map((imagePair) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: imagePair.map((imagePath) {
              return buildImageWithTap(imagePath, context);
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget buildImageWithTap(String imagePath, BuildContext context) {
    return GestureDetector(
        onTap: () {
          navigateToCatalogPage(context);
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4 - 15,
          height: MediaQuery.of(context).size.width * 0.4 - 15,
          margin: const EdgeInsets.symmetric(horizontal: 7.5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              imagePath,
              width: 130,
              height: 130,
            ),
          ),
        ));
  }
}
