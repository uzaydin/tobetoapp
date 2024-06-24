import 'package:flutter/material.dart';
import 'package:tobetoapp/bloc/auth/auth_drawer/auth_provider_drawer.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/utils/theme/light/light_theme.dart';
import 'package:tobetoapp/widgets/common_app_bar.dart';
import 'package:tobetoapp/widgets/common_footer.dart';

class ForIndividuals extends StatelessWidget {
  void navigateToCatalogPage(BuildContext context) {
    //Navigator.push(
    //context, MaterialPageRoute(builder: (context) => const CatalogGuest()));
  }

  const ForIndividuals({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      drawer: const DrawerManager(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildGradientContainer(
              context,
              [
                TextSpan(
                  text: "Kontrol\n sende \n",
                  style: Theme.of(context).textTheme.displayLarge,
                  children: [
                    TextSpan(
                      text: "adım at, \n",
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(color: AppColors.tobetoMoru),
                    ),
                    TextSpan(
                      text: "Tobeto ile\n fark yarat!",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
              ],
              'assets/pictures/foto5.png',
              isFirst: true,
            ),
            SizedBox(height: AppConstants.sizedBoxHeightXLarge),
            buildImageContainer('assets/pictures/foto6.jpg', 30.0),
            SizedBox(height: AppConstants.sizedBoxHeightMedium),
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
            SizedBox(height: AppConstants.sizedBoxHeightXXLarge),
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
            SizedBox(height: AppConstants.sizedBoxHeightXLarge),
            buildImageContainer("assets/pictures/foto4.jpg", 30.0),
            SizedBox(height: AppConstants.sizedBoxHeightXLarge),
            buildImageContainer("assets/pictures/foto7.jpg", 30.0),
            SizedBox(height: AppConstants.sizedBoxHeightXXLarge),
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
            SizedBox(height: AppConstants.sizedBoxHeightXXLarge),
            buildGradientContainer(
              context,
              [
                TextSpan(
                  text: "Kariyeriniz için\n en iyi\n yolculuklar",
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(color: Colors.white),
                ),
              ],
              null,
              child: buildImageRows(context),
            ),
            SizedBox(height: AppConstants.sizedBoxHeightMedium),
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
        padding: EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          children: [
            Text.rich(
              TextSpan(
                children: textSpans,
              ),
            ),
            SizedBox(height: AppConstants.sizedBoxHeightLarge),
            if (imagePath != null) Image.asset(imagePath),
            if (child != null) child,
          ],
        ),
      ),
    );
  }

  Widget buildImageContainer(String imagePath, double borderRadius) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingMedium),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(imagePath),
      ),
    );
  }

  Widget buildTextSection(BuildContext context, String title,
      String description, List<String> items) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: AppConstants.sizedBoxHeightSmall),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: AppConstants.sizedBoxHeightSmall),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                items.map((item) => buildListItem(item, context)).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildListItem(String text, BuildContext context) {
    return Padding(
      padding:
          const EdgeInsetsDirectional.symmetric(vertical: 5.0, horizontal: 7.0),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 10),
          SizedBox(width: AppConstants.sizedBoxWidthSmall),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
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
          width: AppConstants.screenWidth * 0.4,
          height: AppConstants.screenWidth * 0.4,
          //margin: const EdgeInsets.symmetric(horizontal: 10),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.br8),
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
              //130,
              width: AppConstants.profileImageSize + 100,
              height: AppConstants.profileImageSize + 100,
            ),
          ),
        ));
  }
}
