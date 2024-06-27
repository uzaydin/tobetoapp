import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tobetoapp/models/catalog_model.dart';
import 'package:tobetoapp/screens/auth.dart';
import 'package:tobetoapp/screens/catalog/catalog_lesson_page.dart';

import 'package:tobetoapp/utils/theme/light/light_theme.dart';
import 'package:tobetoapp/widgets/review_section.dart';

class CatalogDetailPage extends StatelessWidget {
  final CatalogModel catalogId;

  const CatalogDetailPage({super.key, required this.catalogId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eğitim Detayı', textAlign: TextAlign.center),
        backgroundColor: AppColors.tobetoMoru,
      ),
      resizeToAvoidBottomInset: true,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('catalog').doc(catalogId.catalogId).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.tobetoMoru));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Ders bulunamadı!'));
          }

          var catalogData = CatalogModel.fromFirestore(snapshot.data!);

          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (catalogData.imageUrl != null)
                  Image.network(
                    catalogData.imageUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                else
                  const Placeholder(
                    fallbackHeight: 200,
                    color: Colors.grey,
                  ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: Text(
                      catalogData.title ?? 'Ders Adı Bulunamadı!',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.tobetoMoru),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Divider(color: AppColors.tobetoMoru),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CatalogInfo(catalog: catalogData),
                ),
                const Divider(color: AppColors.tobetoMoru),
                const SectionTitle(title: 'Eğitim İçeriği'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    catalogData.content ?? 'İçerik bulunamadı!',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const Divider(color: AppColors.tobetoMoru),
                const SectionTitle(title: 'Eğitmen Bilgisi'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    catalogData.instructorInfo ?? 'Eğitici bilgisi bulunamadı!',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const Divider(color: AppColors.tobetoMoru),
                FirebaseAuth.instance.currentUser == null
                    ? Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.tobetoMoru,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Auth()),
                            );
                          },
                          child: const Text('Giriş Yap', style: TextStyle(color: Colors.white)),
                        ),
                      )
                    : Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.tobetoMoru,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CatalogLessonPage(catalogId: catalogId)),
                            );
                          },
                          child: const Text('Eğitime Git', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                const Divider(color: AppColors.tobetoMoru),
                const SectionTitle(title: 'Öğrenci Yorumları'),
                FirebaseAuth.instance.currentUser == null
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Center(child: Text('Yorumları görmek için giriş yapmalısınız.')),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ReviewsSection(documentId: catalogId.catalogId!),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CatalogInfo extends StatelessWidget {
  final CatalogModel catalog;

  const CatalogInfo({super.key, required this.catalog});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: catalog.isFree! ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: Text(
                catalog.isFree! ? 'Ücretsiz Eğitim' : 'Ücretli Eğitim',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(color: AppColors.tobetoMoru),
          const SizedBox(height: 10),
          InfoRow(label: 'Sertifika', value: catalog.certificationStatus!),
          const SizedBox(height: 5),
          InfoRow(label: 'Dil', value: catalog.language!),
          const SizedBox(height: 5),
          InfoRow(label: 'Eğitmen', value: catalog.instructor!),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.tobetoMoru),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.headlineMedium?.color),
          ),
        ),
      ],
    );
  }
}


class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.tobetoMoru),
      ),
    );
  }
}