import 'package:flutter/material.dart';
import 'package:tobetoapp/screens/guest/in_the_press.dart';
import 'package:tobetoapp/screens/guest/for_individuals.dart';
import 'package:tobetoapp/screens/guest/blog.dart';
import 'package:tobetoapp/screens/guest/about_us.dart';
import 'package:tobetoapp/screens/guest/contact.dart';
import 'package:tobetoapp/screens/guest/istanbul_kodluyor.dart';
import 'package:tobetoapp/screens/guest/for_institutions.dart';
import 'package:tobetoapp/screens/guest/calendar.dart';
import 'package:tobetoapp/screens/lessons_category_screen.dart';
import 'package:tobetoapp/screens/login_or_signup.dart';

class CommonDrawer extends StatefulWidget {
  const CommonDrawer({super.key});

  @override
  State<CommonDrawer> createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {
  String selectedOption = "";
  bool isServicesExpanded = false;
  bool isActivitiesExpanded = false;
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
                            builder: (context) => const AboutUs()));
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: const Text(
                        "Neler Sunuyoruz?",
                      ),
                      onTap: () {
                        setState(() {
                          isServicesExpanded = !isServicesExpanded;
                        });
                      },
                    ),
                    if (isServicesExpanded)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedOption = "Bireyler İçin";
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForIndividuals()));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                width: 250,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 163, 77, 233),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  "Bireyler İçin",
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedOption = "Kurumlar İçin";
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForInstitutions()));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                width: 250,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 163, 77, 233),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  "Kurumlar İçin",
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                ListTile(
                  title: const Text("Eğitimlerimiz"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const LessonsCategoryScreen()));
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: const Text("Tobeto'da Neler Oluyor?"),
                      onTap: () {
                        setState(() {
                          isActivitiesExpanded = !isActivitiesExpanded;
                        });
                      },
                    ),
                    if (isActivitiesExpanded)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedOption = "Blog";
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Blog()));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                width: 250,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 163, 77, 233),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  "Blog",
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedOption = "Basında Biz";
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const InThePress()));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                width: 250,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 163, 77, 233),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  "Basında Biz",
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedOption = "Takvim";
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Calendar()));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                width: 250,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 163, 77, 233),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  "Takvim",
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedOption = "İstanbul Kodluyor";
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const IstanbulKodluyor()));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                width: 250,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 163, 77, 233),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  "İstanbul Kodluyor",
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                ListTile(
                  title: const Text("İletişim"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Contact()));
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginOrSignUp()));
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
