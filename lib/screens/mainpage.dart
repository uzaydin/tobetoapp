import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_event.dart';
import 'package:tobetoapp/bloc/auth/auth_state.dart';

import 'package:tobetoapp/bloc/user/user_bloc.dart';
import 'package:tobetoapp/bloc/user/user_event.dart';
import 'package:tobetoapp/bloc/user/user_state.dart';
import 'package:tobetoapp/models/user_model.dart';
import 'package:tobetoapp/models/user_enum.dart';
import 'package:tobetoapp/screens/admin/admin_panel.dart';

import 'package:tobetoapp/screens/announcement_page.dart';

import 'package:tobetoapp/screens/class_details_page.dart';
import 'package:tobetoapp/screens/favorites_page.dart';
import 'package:tobetoapp/screens/homepage.dart';

import 'package:tobetoapp/screens/profile/profile_page.dart';
import 'package:tobetoapp/screens/teacher_lesson_page.dart';
import 'package:tobetoapp/utils/theme/light/light_theme.dart';

// Bottom Navigation Bar sayfasi

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Her sayfa için bağımsız Navigator'ları saklayacak global anahtarlar
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  // Kullanıcının rolüne göre sayfa listeleri oluşturma
  List<Widget> _buildNavigators(UserModel user) {
    switch (user.role) {
      case UserRole.teacher:
        return [
          _buildNavigator(
              0,
              TeacherLessonPage(
                  teacherId: user.id!)), // Öğretmen için sınıf sayfası
          _buildNavigator(
              1,
              AnnouncementsPage(
                  role: user.role,
                  classIds: user.classIds)), // Öğretmen için duyurular sayfası
          _buildNavigator(2, const Profile()), // Öğretmen için profil sayfası
        ];
      case UserRole.student:
        return [
          _buildNavigator(
              0,
              ClassDetailPage(
                  classIds: user.classIds)), // Öğrenci için sınıf sayfası
          _buildNavigator(
              1,
              AnnouncementsPage(
                  role: user.role,
                  classIds: user.classIds)), // Öğrenci için duyurular sayfası
          _buildNavigator(
              2, const FavoritesPage()), // Öğrenci için favoriler sayfası
          _buildNavigator(3, const Profile()), // Öğrenci için profil sayfası
        ];
      case UserRole.admin:
        return [
          _buildNavigator(0, const AdminPanel()), // Admin için ana sayfa
          _buildNavigator(
              1,
              AnnouncementsPage(
                  role: user.role,
                  classIds: user.classIds)), // Admin için duyurular sayfası
          _buildNavigator(2, const Profile()), // Admin için profil sayfası
        ];
      default:
        return [];
    }
  }

  // Belirli bir index ve child widget için bağımsız bir Navigator oluşturma
  Widget _buildNavigator(int index, Widget child) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback, UI oluşturulduktan sonra çağrılır
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthSuccess) {
        context
            .read<UserBloc>()
            .add(FetchUser(authState.id!)); // Kullanıcı bilgilerini getir
      } else {
        context
            .read<AuthBloc>()
            .add(AuthCheckStatus()); // Kullanıcı oturum durumunu kontrol et
      }
    });
  }

  // BottomNavigationBar'da bir öğeye tıklandığında sayfa geçişini yapar
  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      // Aynı index'e tekrar tıklanırsa, Navigator'un en üst seviyesine kadar gider
      _navigatorKeys[index].currentState!.popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: AppColors.tobetoMoru.withOpacity(0.2),
        highlightColor: AppColors.tobetoMoru.withOpacity(0.1),
      ),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            setState(() {
              _selectedIndex = 0;
            });
          } else if (state is AuthSuccess) {
            context
                .read<UserBloc>()
                .add(FetchUser(state.id!)); // Kullanıcı bilgilerini getir
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AuthSuccess) {
            return BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
                if (userState is UserLoaded) {
                  final pages = _buildNavigators(
                      userState.user); // Sayfa listesini oluştur
                  return Scaffold(
                    body: IndexedStack(
                      index: _selectedIndex,
                      children: pages,
                    ),
                    bottomNavigationBar: _buildBottomNavigationBarForRole(
                        userState
                            .user.role!), // Rol tabanlı BottomNavigationBar
                  );
                } else if (userState is UserLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (userState is UserError) {
                  return Center(
                      child: Text(
                          'Failed to load user data: ${userState.message}'));
                } else {
                  return const Center(child: Text('Failed to load user data'));
                }
              },
            );
          } else {
            // Kullanici cikis yaptiktan sonra bottomNavigationBar iptal edildi.HomePage sayfasina yonlendiriyor direkt
            return const Scaffold(body: Homepage());
          }
        },
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBarForRole(UserRole role) {
    List<BottomNavigationBarItem> items;
    BottomNavigationBarType? type;
    switch (role) {
      case UserRole.teacher:
        items = [
          const BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'Sınıflar',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Duyurular',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profil',
          ),
        ];
        type = BottomNavigationBarType.fixed;
        break;
      case UserRole.student:
        items = [
          const BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Eğitimler',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Duyurular',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoriler',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profil',
          ),
        ];
        type = BottomNavigationBarType.fixed;
        break;
      case UserRole.admin:
        items = [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Duyurular',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profil',
          ),
        ];
        type = BottomNavigationBarType.fixed;
        break;
      default:
        items = [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Duyurular',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profil',
          ),
        ];
    }
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: type,
      onTap: _onItemTapped,
      items: items,
      selectedItemColor: Colors.purple, // Seçilen öğenin rengi
      unselectedItemColor: Colors.grey, // Seçilmeyen öğelerin rengi
      backgroundColor: Colors.white, // Arkaplan rengi
      showUnselectedLabels: false, // Seçilmeyen öğelerin etiketlerini göster
    );
  }
}
