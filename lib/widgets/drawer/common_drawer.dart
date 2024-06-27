import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tobetoapp/bloc/auth/auth_drawer/auth_provider_drawer.dart';
import 'package:tobetoapp/screens/auth.dart';
import 'package:tobetoapp/screens/calendar/calendar_page.dart';
import 'package:tobetoapp/screens/catalog/catalog_page.dart';
import 'package:tobetoapp/screens/guest/in_the_press.dart';
import 'package:tobetoapp/screens/guest/for_individuals.dart';
import 'package:tobetoapp/screens/guest/blog.dart';
import 'package:tobetoapp/screens/guest/about_us.dart';
import 'package:tobetoapp/screens/guest/contact.dart';
import 'package:tobetoapp/screens/guest/for_institutions.dart';
import 'package:tobetoapp/screens/guest/istanbul_kodluyor.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/utils/theme/theme_switcher.dart';
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
        children: [
          _buildDrawerHeader(context),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenWidth * 0.05),
            child: Column(
              children: _buildDrawerItems(context),
            ),
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenWidth * 0.05),
            child: ListTile(
              title: Text("Tema Değiştir",
                  style: Theme.of(context).textTheme.bodySmall),
              trailing: const ThemeSwitcher(),
            ),
          ),
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
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
                _navigateTo(context, const Auth());
              },
              child: Text(
                "Giriş Yap",
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
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

  Widget _buildDrawerHeader(BuildContext context) {
    return SizedBox(
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
    );
  }

  List<Widget> _buildDrawerItems(BuildContext context) {
    final TextStyle? drawerTextStyle = Theme.of(context).textTheme.bodySmall;
    return [
      ListTile(
        title: Text("Biz Kimiz?", style: drawerTextStyle),
        onTap: () => _navigateTo(context, const AboutUs()),
      ),
      _buildExpansionPanel(
        context: context,
        title: "Neler Sunuyoruz?",
        isExpanded: _isServicesExpanded,
        onExpansionChanged: (isExpanded) =>
            setState(() => _isServicesExpanded = !_isServicesExpanded),
        items: [
          _buildDrawerItem(context, "Bireyler İçin", const ForIndividuals()),
          _buildDrawerItem(context, "Kurumlar İçin", const ForInstitutions()),
        ],
      ),
      ListTile(
        title: Text("Eğitimlerimiz", style: drawerTextStyle),
        onTap: () => _navigateTo(context, const CatalogPage()),
      ),
      _buildExpansionPanel(
        context: context,
        title: "Tobeto'da Neler Oluyor?",
        isExpanded: _isActivitiesExpanded,
        onExpansionChanged: (isExpanded) =>
            setState(() => _isActivitiesExpanded = !_isActivitiesExpanded),
        items: [
          _buildDrawerItem(context, "Blog", const Blog()),
          _buildDrawerItem(context, "Basında Biz", const InThePress()),
          _buildDrawerItem(context, "Takvim", const CalendarPage()),
          _buildDrawerItem(
              context, "İstanbul Kodluyor", const IstanbulKodluyor()),
        ],
      ),
      ListTile(
        title: Text("İletişim", style: drawerTextStyle),
        onTap: () => _navigateTo(context, const Contact()),
      ),
    ];
  }

  Widget _buildExpansionPanel({
    required BuildContext context,
    required String title,
    required bool isExpanded,
    required ValueChanged<bool> onExpansionChanged,
    required List<Widget> items,
  }) {
    return ExpansionPanelList(
      elevation: 0,
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (int index, bool isExpanded) =>
          onExpansionChanged(isExpanded),
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(title, style: Theme.of(context).textTheme.bodySmall),
            );
          },
          body: Column(children: items),
          isExpanded: isExpanded,
        ),
      ],
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, String title, Widget destination) {
    return DrawerItem(
      title: title,
      onTap: () {
        setState(() {
          selectedOption = title;
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => destination));
      },
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
