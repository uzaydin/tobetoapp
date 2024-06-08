import 'package:flutter/material.dart';
import 'package:tobetoapp/screens/auth.dart';
import 'package:tobetoapp/screens/guest/calendar.dart';
import 'package:tobetoapp/screens/homepage.dart';
import 'package:tobetoapp/screens/user/catalog_user.dart';
import 'package:tobetoapp/screens/user/assessment.dart';
import 'package:tobetoapp/screens/user/profile.dart';

class CommonUserDrawer extends StatefulWidget {
  const CommonUserDrawer({super.key});

  @override
  State<CommonUserDrawer> createState() => _CommonUserDrawerState();
}

class _CommonUserDrawerState extends State<CommonUserDrawer> {
  String selectedOption = "";
  bool isServicesExpanded = false;
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
                            builder: (context) => const Assessment()));
                  },
                ),
                ListTile(
                  title: const Text("Profilim"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Profile()));
                  },
                ),
                ListTile(
                  title: const Text("Katalog"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CatalogUser()));
                  },
                ),
                ListTile(
                  title: const Text("Takvim"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Calendar()));
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
          Padding(
            padding: const EdgeInsets.all(14),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isServicesExpanded = !isServicesExpanded;
                });
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                side: const BorderSide(color: Colors.grey, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 20.0,
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
          if (isServicesExpanded)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedOption = "Profil Bilgileri";
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Profile()));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 163, 77, 233),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Profil Bilgileri",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedOption = "Oturumu Kapat";
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Auth()));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 163, 77, 233),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Oturumu Kapat",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
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
