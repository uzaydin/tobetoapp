import 'package:flutter/material.dart';
import 'package:tobetoapp/screens/competency_test_page.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

class CompetencyTestInfoDialog extends StatelessWidget {
  const CompetencyTestInfoDialog({super.key});

  final String infoText =
      "\"Tobeto İşte Başarı Modeli\" iş bulma ve bir işte başarılı olma sürecinde hayli kritik olan istihdam edilebilirlik yetkinlikleri üzerine kuruludur.\n\n"
      "Araştırmalar söylüyor ki bu yetkinlikler en az profesyonel iş yetkinlikleri kadar ve hatta bazı görüşlere göre daha önemli! Çünkü bu yetkinlikler, hangi alanda olursa olsun, bir işte sürdürülebilir başarıyı sağlayacak temel becerileri içeriyor. Dolayısıyla da şirketler, kurumlar adayların bu yetkinlikleri çok önemiyor ve çalışanlarını bu alanlarda geliştirmek için büyük yatırımlar yapıyorlar.\n\n"
      "O halde şimdi sen de kendini analiz et; yetkinlik raporun çıksın. Kendini hangi alanlarda güçlü görüyorsun öğren. Ek olarak bu yetkinlikleri geliştirmek üzere Tobeto tarafından sunulan eğitimlere ücretsiz erişimin açılsın! Unutma; bu bir öz değerlendirme. Kendini yine sen değerlendiriyor, kendi fotoğrafını çekiyorsun.\n\n"
      "Bu bir test ya da sınav değil. Güçlü ve gelişime açık yetkinliklerini belirlemen için bir araç. O yüzden kendine karşı dürüst ol, gerçekten ne isen ona göre değerlendirme yap.\n\n"
      "Testi tamamlamak çok basit. 80 tane davranış ifadesi var. Bunların her birini okuyup o davranışta kendini ne kadar başarılı ya da iyi gördüğünü aşağıdaki ölçeği dikkate alarak işaretle.\n\n"
      "Tüm maddeler için işaretleme yapmalısın.\n\n"
      "Başarılar.";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Tobeto İşte Başarı Modeli',
                  style: TextStyle(
                    color: Color(0xFF9933ff),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: AppConstants.sizedBoxHeightSmall),
              const LinearProgressIndicator(
                value: 0,
                backgroundColor: Color(0xFFD8D8D8),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9933ff)),
              ),
              SizedBox(height: AppConstants.sizedBoxHeightLarge),
              Text(
                infoText,
                style: const TextStyle(fontSize: 14),
              ),
              SizedBox(height: AppConstants.sizedBoxHeightLarge),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Bu konuda hiç ama hiç iyi değilim (--)',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Bu konuda pek iyi değilim (-)',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Bu konuda ortalama düzeydeyim, ne iyi ne kötü (0)',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Bu konuda iyiyim (+)',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Bu konuda çok ama çok iyiyim (++)',
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppConstants.sizedBoxHeightLarge),
              const Center(
                child: Text(
                  'Her bir soruya verdiğiniz cevaplar, yetkinlik düzeyinizi belirleyecek ve 5 üzerinden bir puan ile değerlendirilecektir. ',
                  style: TextStyle(
                    color: Color(0xFF9933ff),
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: AppConstants.sizedBoxHeightLarge),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9933ff),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.br20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CompetencyTestPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Değerlendirmeye Başla',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
