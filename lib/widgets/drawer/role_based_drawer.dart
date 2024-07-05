import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:tobetoapp/bloc/auth/auth_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_event.dart';
import 'package:tobetoapp/bloc/auth/auth_state.dart';
import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/screens/calendar/calendar_page.dart';
import 'package:tobetoapp/screens/homepage.dart';
import 'package:tobetoapp/screens/profile/profile_page.dart';
import 'package:tobetoapp/screens/user/assessment.dart';
import 'package:tobetoapp/screens/user/catalog_user.dart';
import 'package:tobetoapp/screens/teacher/teacher_lesson_page.dart';
import 'package:tobetoapp/screens/admin/admin_panel.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/utils/theme/light/light_theme.dart';
import 'package:tobetoapp/utils/theme/theme_switcher.dart';
import 'package:tobetoapp/widgets/bottom_navigation.dart';

class RoleBasedDrawer extends StatefulWidget {
  @override
  State<RoleBasedDrawer> createState() => _RoleBasedDrawerState();
}

class _RoleBasedDrawerState extends State<RoleBasedDrawer> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(FetchUserDetails());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                _buildDrawerHeader(context),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: _buildDrawerItems(context, state.role.toString()),
                  ),
                ),
                SizedBox(height: AppConstants.sizedBoxHeightMedium),
                const Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.screenWidth * 0.05),
                  child: TextButton(
                    onPressed: () => _navigateToHomepage(context),
                    child: Row(
                      children: [
                        Text("Tobeto",
                            style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(width: 5.0),
                        const Icon(Icons.home),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListTile(
                    title: Text("Tema Değiştir",
                        style: Theme.of(context).textTheme.bodySmall),
                    trailing: const ThemeSwitcher(),
                  ),
                ),
                SizedBox(height: AppConstants.sizedBoxHeightMedium),
                _buildProfileBloc(context),
                SizedBox(height: AppConstants.sizedBoxHeightMedium),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Çıkış Yap",
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(width: 5),
                      IconButton(
                        onPressed: () => _logout(context),
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
        } else {
          return SizedBox.shrink();
        }
      },
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

  List<Widget> _buildDrawerItems(BuildContext context, String role) {
    switch (role) {
      case 'student':
        return [
          _buildListTile(context, "Platform", const BottomNavigation()),
          _buildListTile(context, "Değerlendirmeler", const Assessment()),
          _buildListTile(context, "Profilim", const Profile()),
          _buildListTile(context, "Katalog", const CatalogUser()),
          _buildListTile(context, "Takvim", const CalendarPage()),
        ];
      case 'teacher':
        return [
          _buildListTile(
              context, "Eğitmen Panel", const TeacherLessonPage(teacherId: '')),
          _buildListTile(context, "Profilim", const Profile()),
          _buildListTile(context, "Takvim", const CalendarPage()),
        ];
      case 'admin':
        return [
          _buildListTile(context, "Admin Panel", const AdminPanel()),
          _buildListTile(context, "Profilim", const Profile()),
          _buildListTile(context, "Takvim", const CalendarPage()),
        ];
      default:
        return [];
    }
  }

  Widget _buildListTile(
      BuildContext context, String title, Widget destination) {
    return ListTile(
      title: Text(title, style: Theme.of(context).textTheme.bodySmall),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }

  Widget _buildProfileBloc(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is AuthSuccess) {
          final currentUser = context.read<AuthBloc>().currentUser;
          if (currentUser != null) {
            return BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, profileState) {
                if (profileState is ProfileInitial ||
                    profileState is ProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (profileState is ProfileLoaded) {
                  final user = profileState.user;
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
                            backgroundImage:
                                user.getProfilePhotoUrl().isNotEmpty
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
                    child: Text('Profil bilgileri yüklenirken hata oluştu.'),
                  );
                }
              },
            );
          } else {
            // Kullanıcı bilgisi null ise burada bir şeyler yapabilirsiniz
            return const Center(
              child: Text('Kullanıcı bilgisi bulunamadı.'),
            );
          }
        } else {
          // Oturum açılmamış veya hata varsa burada bir şeyler yapabilirsiniz
          return const Center(
            child: Text('Oturum açılmamış veya hata oluştu.'),
          );
        }
      },
    );
  }

  void _navigateToHomepage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Homepage()));
  }

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(AuthLogOut());
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Homepage()));
  }
}
