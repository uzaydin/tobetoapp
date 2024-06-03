import 'package:flutter/material.dart';
import 'package:tobetoapp/screens/guest/basinda_biz.dart';
import 'package:tobetoapp/screens/guest/bireyler_icin.dart';
import 'package:tobetoapp/screens/guest/blog.dart';
import 'package:tobetoapp/screens/guest/hakkimizda.dart';
import 'package:tobetoapp/screens/guest/iletisim.dart';
import 'package:tobetoapp/screens/guest/istanbul_kodluyor.dart';
import 'package:tobetoapp/screens/guest/kurumlar_icin.dart';
import 'package:tobetoapp/screens/guest/takvim_anasayfa.dart';
import 'package:tobetoapp/screens/lessons_category_screen.dart';
import 'package:tobetoapp/screens/login_or_signup.dart';

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 100.0,
            child: DrawerHeader(
              decoration: const BoxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: 160.0,
                      child: Image.asset('assets/logo/tobetologo.PNG',
                          fit: BoxFit.contain)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 16.0),
            child: Column(
              children: [
                ListTile(
                  title: const Text("Biz Kimiz?"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Hakkimizda()));
                  },
                ),
                ListTile(
                  title: const Text("Neler Sunuyoruz?"),
                  onTap: () {},
                  trailing: PopupMenuButton<String>(
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: "bireyler",
                        child: Text("Bireyler İçin"),
                      ),
                      const PopupMenuItem<String>(
                        value: "kurumlar",
                        child: Text("Kurumlar İçin"),
                      ),
                    ],
                    onSelected: (String value) {
                      switch (value) {
                        case "bireyler":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BireylerIcin()),
                          );
                          break;
                        case "kurumlar":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const KurumlarIcin()),
                          );
                          break;
                      }
                    },
                  ),
                ),
                ListTile(
                  title: const Text("Eğitimlerimiz"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LessonsCategoryScreen()));
                  },
                ),
                ListTile(
                  title: const Text("Tobeto'da Neler Oluyor?"),
                  onTap: () {},
                  trailing: PopupMenuButton<String>(
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: "blog",
                        child: Text("Blog"),
                      ),
                      const PopupMenuItem(
                        value: "basinda",
                        child: Text("Basında Biz"),
                      ),
                      const PopupMenuItem(
                        value: "takvim",
                        child: Text("Takvim"),
                      ),
                      const PopupMenuItem(
                        value: "istKodluyor",
                        child: Text("İstanbul Kodluyor"),
                      ),
                    ],
                    onSelected: (String value) {
                      switch (value) {
                        case "blog":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Blog()),
                          );
                          break;
                        case "basinda":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BasindaBiz()),
                          );
                          break;
                        case "takvim":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Takvim()),
                          );
                          break;
                        case "istKodluyor":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const IstanbulKodluyor()),
                          );
                          break;
                      }
                    },
                  ),
                ),
                ListTile(
                  title: const Text("İletişim"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Iletisim()));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 11.0),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const LoginOrSignUp()));
                },
                child: const Text(
                  "Giriş Yap",
                  style: TextStyle(color: Colors.white),
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "© 2024 Tobeto I Her Hakkı Saklıdır.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
