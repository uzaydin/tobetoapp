import 'package:flutter/material.dart';
import 'package:tobetoapp/screens/auth.dart';
import 'package:tobetoapp/screens/guest/calendar.dart';
import 'package:tobetoapp/screens/homepage.dart';
import 'package:tobetoapp/screens/user/catalog_user.dart';
import 'package:tobetoapp/screens/user/assessment.dart';
import 'package:tobetoapp/screens/user/profile.dart';
import 'package:tobetoapp/theme/constants/constants.dart';
import 'package:tobetoapp/theme/theme_switcher.dart';
import 'package:tobetoapp/widgets/common_drawer/drawer_items.dart';

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
            height: AppConstants.screenHeight * 0.18,
            child: DrawerHeader(
              decoration: const BoxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: AppConstants.screenWidth * 0.5,
                    child: Image.asset('assets/logo/tobetologo.PNG',
                        fit: BoxFit.contain),
                  ),
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
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenWidth * 0.05),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    "Anasayfa",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Homepage()));
                  },
                ),
                ListTile(
                  title: Text(
                    "Değerlendirmeler",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Assessment()));
                  },
                ),
                ListTile(
                  title: Text(
                    "Profilim",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Profile()));
                  },
                ),
                ListTile(
                  title: Text(
                    "Katalog",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CatalogUser()));
                  },
                ),
                ListTile(
                  title: Text(
                    "Takvim",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
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
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
          const Divider(),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenWidth * 0.05),
            child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Homepage()));
              },
              child: Row(
                children: [
                  Text(
                    "Tobeto",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 5.0),
                  const Icon(Icons.home),
                ],
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenWidth * 0.05),
            child: ListTile(
              title: Text(
                "Tema Değiştir",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: const ThemeSwitcher(),
            ),
          ),
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
          ExpansionPanelList(
            elevation: 0,
            expandedHeaderPadding: EdgeInsets.zero,
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                isServicesExpanded = !isServicesExpanded;
              });
            },
            children: [
              ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return Padding(
                    padding: EdgeInsets.all(AppConstants.paddingMedium),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.person),
                        ),
                        SizedBox(width: AppConstants.sizedBoxWidthMedium),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Nihan Ertuğ",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                body: Column(
                  children: [
                    DrawerItem(
                      title: "Profil Bilgileri",
                      onTap: () {
                        setState(() {
                          selectedOption = "Profil Bilgileri";
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Profile()));
                      },
                    ),
                    DrawerItem(
                      title: "Oturumu Kapat",
                      onTap: () {
                        setState(() {
                          selectedOption = "Oturumu Kapat";
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Auth()));
                      },
                    ),
                  ],
                ),
                isExpanded: isServicesExpanded,
              ),
            ],
          ),
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
          Text(
            "© 2024 Tobeto I Her Hakkı Saklıdır.",
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(fontWeight: FontWeight.w300),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
        ],
      ),
    );
  }
}
