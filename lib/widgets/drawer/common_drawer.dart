import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tobetoapp/bloc/auth/auth_drawer/auth_provider_drawer.dart';
import 'package:tobetoapp/main.dart';
import 'package:tobetoapp/screens/auth.dart';
import 'package:tobetoapp/screens/catalog/catalog_page.dart';
import 'package:tobetoapp/screens/guest/in_the_press.dart';
import 'package:tobetoapp/screens/guest/for_individuals.dart';
import 'package:tobetoapp/screens/guest/blog.dart';
import 'package:tobetoapp/screens/guest/about_us.dart';
import 'package:tobetoapp/screens/guest/contact.dart';
import 'package:tobetoapp/screens/guest/istanbul_kodluyor.dart';
import 'package:tobetoapp/screens/guest/for_institutions.dart';
import 'package:tobetoapp/screens/guest/calendar.dart';
import 'package:tobetoapp/screens/login_or_signup.dart';
import 'package:tobetoapp/theme/constants/constants.dart';
import 'package:tobetoapp/theme/theme_switcher.dart';
import 'package:tobetoapp/widgets/drawer/drawer_items.dart';

class CommonDrawer extends StatefulWidget {
  const CommonDrawer({super.key});

  @override
  State<CommonDrawer> createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {
  String selectedOption = "";
  bool _isServicesExpanded = false;
  bool _isActivitiesExpanded = false;

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
            //16
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenWidth * 0.05),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    "Biz Kimiz?",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AboutUs()));
                  },
                ),
                ExpansionPanelList(
                  elevation: 0,
                  expandedHeaderPadding: EdgeInsets.zero,
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _isServicesExpanded = !_isServicesExpanded;
                    });
                  },
                  children: [
                    ExpansionPanel(
                      canTapOnHeader: true,
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(
                            "Neler Sunuyoruz?",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      },
                      body: Column(
                        children: [
                          DrawerItem(
                            title: "Bireyler İçin",
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
                          ),
                          DrawerItem(
                            title: "Kurumlar İçin",
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
                          ),
                        ],
                      ),
                      isExpanded: _isServicesExpanded,
                    ),
                  ],
                ),
                ListTile(
                  title: Text(
                    "Eğitimlerimiz",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const CatalogPage()));
                  },
                ),
                ExpansionPanelList(
                  elevation: 0,
                  expandedHeaderPadding: EdgeInsets.zero,
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _isActivitiesExpanded = !_isActivitiesExpanded;
                    });
                  },
                  children: [
                    ExpansionPanel(
                      canTapOnHeader: true,
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(
                            "Tobeto'da Neler Oluyor?",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      },
                      body: Column(
                        children: [
                          DrawerItem(
                            title: "Blog",
                            onTap: () {
                              setState(() {
                                selectedOption = "Blog";
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Blog()));
                            },
                          ),
                          DrawerItem(
                            title: "Basında Biz",
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
                          ),
                          DrawerItem(
                            title: "Takvim",
                            onTap: () {
                              setState(() {
                                selectedOption = "Takvim";
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Calendar()));
                            },
                          ),
                          DrawerItem(
                            title: "İstanbul Kodluyor",
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
                          ),
                        ],
                      ),
                      isExpanded: _isActivitiesExpanded,
                    ),
                  ],
                ),
                ListTile(
                  title: Text(
                    "İletişim",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
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
          SizedBox(
            height: AppConstants.sizedBoxHeightMedium,
          ),
          Padding(
            padding: EdgeInsets.all(AppConstants.paddingMedium),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.screenWidth * 0.2,
                  vertical: AppConstants.screenHeight * 0.02,
                ),
              ),
              onPressed: () {
                final authProvider =
                    Provider.of<AuthProviderDrawer>(context, listen: false);
                authProvider.login();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Auth()));
              },
              child: Text(
                "Giriş Yap",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.white),
              ),
            ),
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
        ],
      ),
    );
  }
}
