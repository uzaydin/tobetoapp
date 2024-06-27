import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:provider/provider.dart';
import 'package:tobetoapp/bloc/auth/auth_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_drawer/auth_provider_drawer.dart';
import 'package:tobetoapp/bloc/auth/auth_event.dart';
import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/screens/admin/admin_panel.dart';
import 'package:tobetoapp/screens/calendar/calendar_page.dart';
import 'package:tobetoapp/screens/homepage.dart';
import 'package:tobetoapp/screens/profile/profile_page.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/utils/theme/light/light_theme.dart';
import 'package:tobetoapp/utils/theme/theme_switcher.dart';

class AdminDrawer extends StatefulWidget {
  const AdminDrawer({super.key});

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(FetchUserDetails());
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildDrawerHeader(),
          _buildDrawerItems(),
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
          const Divider(),
          _buildHomepageButton(),
          const Divider(),
          _buildThemeSwitcher(),
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
          _buildProfileButton(),
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
          _buildLogoutButton(),
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
          _buildCopyRightText(),
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return SizedBox(
      height: AppConstants.screenHeight * 0.18,
      child: DrawerHeader(
        decoration: const BoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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

  Widget _buildDrawerItems() {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: AppConstants.screenWidth * 0.05),
      child: Column(
        children: [
          _buildDrawerItem("Admin Panel", const AdminPanel()),
          _buildDrawerItem("Profilim", const Profile()),
          _buildDrawerItem("Takvim", const CalendarPage()),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, Widget destination) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }

  Widget _buildHomepageButton() {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: AppConstants.screenWidth * 0.05),
      child: TextButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Homepage()));
        },
        child: Row(
          children: [
            Text(
              "Tobeto",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(width: 5.0),
            const Icon(Icons.home),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSwitcher() {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: AppConstants.screenWidth * 0.05),
      child: ListTile(
        title: Text(
          "Tema Değiştir",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: const ThemeSwitcher(),
      ),
    );
  }

  Widget _buildProfileButton() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileInitial || state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProfileLoaded) {
          final user = state.user;
          return Container(
            margin: EdgeInsets.all(AppConstants.paddingSmall),
            child: OutlineGradientButton(
              padding: EdgeInsets.all(AppConstants.paddingMedium),
              strokeWidth: 3,
              radius: Radius.circular(AppConstants.br30),
              gradient: const LinearGradient(
                colors: [
                  AppColors.tobetoMoru,
                  Color.fromARGB(209, 255, 255, 255),
                  Color.fromARGB(178, 255, 255, 255),
                  AppColors.tobetoMoru,
                ],
                stops: [0.0, 0.5, 0.5, 1.0],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: user.profilePhotoUrl.toString().isNotEmpty
                        ? NetworkImage(user.profilePhotoUrl.toString())
                        : null,
                    child: user.profilePhotoUrl.toString().isEmpty
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  SizedBox(height: AppConstants.sizedBoxHeightMedium),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '${user.firstName ?? ''} ${user.lastName ?? ''}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(
              child: Text('Profil bilgileri yüklenirken hata oluştu.'));
        }
      },
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: AppConstants.screenWidth * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Çıkış Yap",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(width: 5),
          IconButton(
            onPressed: () async {
              final authProvider =
                  Provider.of<AuthProviderDrawer>(context, listen: false);
              authProvider.logout();
              context.read<AuthBloc>().add(AuthLogOut());
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Homepage()));
            },
            icon: const Icon(Icons.logout),
            color: AppColors.tobetoMoru,
          ),
        ],
      ),
    );
  }

  Widget _buildCopyRightText() {
    return Text(
      "© 2024 Tobeto I Her Hakkı Saklıdır.",
      style: Theme.of(context)
          .textTheme
          .labelLarge!
          .copyWith(fontWeight: FontWeight.w300),
      textAlign: TextAlign.center,
    );
  }
}
