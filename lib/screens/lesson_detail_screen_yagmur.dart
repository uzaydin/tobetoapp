//appbar; ders adı 

//body (column); 
//cw1: ilgili ders görseli
//cw2: ücretli-ücretsiz??/sertifika/dil/eğitmen tanıtımı??
//cw3: eğitim içeriği
//cw4: eğitmen bilgisi
//cw5: eğitime git yönlendirmesi (daha üst kısımlarda da olabilir)
//cw6: öğrenci görüşleri (yorum-puanlama)

//bottombar; sosyal medyada paylaş butonu
//*eğitime git kısmı bottombar bölümünde de olabilir mi?*

// import 'package:flutter/material.dart';
// import 'package:tobetoapp/screens/lesson_screen.dart';

// class LessonDetailScreen extends StatelessWidget {
//   final String videoUrl;
//   final String videoTitle;
//   final double videoRating;

//   const LessonDetailScreen({super.key, required this.videoTitle, required this.videoUrl, required this.videoRating});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(videoTitle),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Ders Görseli
//             Image.network(
//               'https://via.placeholder.com/350x150',
//               width: double.infinity,
//               height: 200,
//               fit: BoxFit.cover,
//             ),
//             const SizedBox(height: 10),
//             // Ücretli/Ücretsiz, Sertifika, Dil, Eğitmen Tanıtımı
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Ücretsiz',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     'Sertifika: Var',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     'Dil: Türkçe',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     'Eğitmen: Ahmet Yılmaz',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//             const Divider(),
//             // Eğitim İçeriği
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text(
//                 'Eğitim İçeriği',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text(
//                 'Bu eğitimde Flutter ile mobil uygulama geliştirme üzerine detaylı bilgi edineceksiniz.',
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//             const Divider(),
//             // Eğitmen Bilgisi
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text(
//                 'Eğitmen Bilgisi',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text(
//                 'Ahmet Yılmaz, 10 yıllık yazılım geliştirme deneyimine sahip ve 5 yıldır Flutter üzerine çalışıyor.',
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//             const Divider(),
//             // Eğitime Git Yönlendirmesi
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const LessonScreen()),
//                   );
//                 },
//                 child: const Text('Eğitime Git'),
//               ),
//             ),
//             const Divider(),
//             // Öğrenci Görüşleri (Yorum - Puanlama)
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text(
//                 'Öğrenci Görüşleri',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   ListTile(
//                     title: Text('Mehmet'),
//                     subtitle: Text('Çok faydalı bir eğitimdi.'),
//                     trailing: Icon(Icons.star, color: Colors.amber),
//                   ),
//                   ListTile(
//                     title: Text('Ayşe'),
//                     subtitle: Text('Eğitmen çok iyi anlatıyor.'),
//                     trailing: Icon(Icons.star, color: Colors.amber),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ElevatedButton(
//             onPressed: () {
//               // Paylaşma işlemi
//             },
//             child: const Text('Sosyal Medyada Paylaş'),
//           ),
//         ),
//       ),
//     );
//   }
// }