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
import 'package:tobetoapp/screens/calendar/calendar_page.dart';
import 'package:tobetoapp/screens/homepage.dart';
import 'package:tobetoapp/screens/profile/profile_page.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/utils/theme/light/light_theme.dart';
import 'package:tobetoapp/utils/theme/theme_switcher.dart';

class TeacherAdminDrawer extends StatefulWidget {
  const TeacherAdminDrawer({super.key});

  @override
  State<TeacherAdminDrawer> createState() => _TeacherAdminDrawerState();
}

class _TeacherAdminDrawerState extends State<TeacherAdminDrawer> {
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
          SizedBox(
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
                    "Profilim",
                    style: Theme.of(context).textTheme.bodyLarge,
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
                    "Takvim",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CalendarPage()));
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
                    style: Theme.of(context).textTheme.bodyLarge,
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
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: const ThemeSwitcher(),
            ),
          ),
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
          BlocBuilder<ProfileBloc, ProfileState>(
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
                          backgroundImage: user.getProfilePhotoUrl().isNotEmpty
                              ? NetworkImage(user.getProfilePhotoUrl())
                              : null,
                          child: user.getProfilePhotoUrl().isEmpty
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
                                style: Theme.of(context).textTheme.bodyMedium,
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
          ),
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenWidth * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Çıkış Yap",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 5),
                IconButton(
                  onPressed: () async {
                    final authProvider =
                        Provider.of<AuthProviderDrawer>(context, listen: false);
                    authProvider.logout();
                    context.read<AuthBloc>().add(AuthLogOut());
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Homepage()));
                  },
                  icon: const Icon(Icons.logout),
                  color: AppColors.tobetoMoru,
                ),
              ],
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
          SizedBox(height: AppConstants.sizedBoxHeightMedium),
        ],
      ),
    );
  }
}
