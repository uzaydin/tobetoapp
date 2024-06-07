import 'package:flutter/material.dart';
import 'package:tobetoapp/screens/auth.dart';
import 'package:tobetoapp/screens/guest/takvim_anasayfa.dart';
import 'package:tobetoapp/screens/homepage.dart';
import 'package:tobetoapp/screens/user/degerlendirmeler.dart';
import 'package:tobetoapp/screens/user/catalog_user.dart';
import 'package:tobetoapp/screens/user/profilim.dart';

class CommonUserDrawer extends StatelessWidget {
  const CommonUserDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    void onProfileSelected(String value) {
      switch (value) {
        case "profilBilgileri":
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Profil()));
          break;
        case "oturumuKapat":
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Auth()));
          break;
      }
    }

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
                  title: const Text("Anasayfa"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Homepage()));
                  },
                ),
                ListTile(
                  title: const Text("Değerlendirmeler"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Degerlendirmeler()));
                  },
                ),
                ListTile(
                  title: const Text("Profilim"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Profil()));
                  },
                ),
                ListTile(
                  title: const Text("Katalog"),
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const CatalogUser()));
                  },
                ),
                ListTile(
                  title: const Text("Takvim"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Takvim()));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Divider(),
          Padding(
            //padding: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.only(left: 30.0, right: 16.0),

            child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Homepage()));
              },
              child: const Row(
                children: [
                  Text(
                    "Tobeto",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 5.0),
                  Icon(Icons.home),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: PopupMenuButton<String>(
              onSelected: onProfileSelected,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: "profilBilgileri",
                  child: Text("Profil Bilgileri"),
                ),
                const PopupMenuItem<String>(
                    value: "oturumuKapat", child: Text("Oturumu Kapat")),
              ],
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12.0),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 18.0,
                      child: Icon(Icons.person),
                    ),
                    SizedBox(width: 10.0),
                    Padding(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: Text(
                        "Nihan Ertuğ",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
