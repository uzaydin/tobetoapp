import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_event.dart';
import 'package:tobetoapp/bloc/auth/auth_state.dart';

import 'package:tobetoapp/bloc/user/user_bloc.dart';
import 'package:tobetoapp/bloc/user/user_event.dart';
import 'package:tobetoapp/bloc/user/user_state.dart';
import 'package:tobetoapp/models/userModel.dart';
import 'package:tobetoapp/models/user_enum.dart';

import 'package:tobetoapp/screens/announcement_page.dart';
import 'package:tobetoapp/screens/homepage.dart';

import 'package:tobetoapp/screens/login_or_signup.dart';
import 'package:tobetoapp/screens/user/profile.dart';

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
    GlobalKey<NavigatorState>(), // Admin ve student için ek bir sayfa
  ];

  // Kullanıcının rolüne göre sayfa listeleri oluşturma
  List<Widget> _buildNavigators(UserModel user) {
    switch (user.role) {
      case UserRole.teacher:
        return [
          _buildNavigator(0, Scaffold()), // Öğretmen için sınıf sayfası
          _buildNavigator(
              1,
              AnnouncementsPage(
                  role: user.role,
                  classModels:
                      user.classModels)), // Öğretmen için duyurular sayfası
          _buildNavigator(2, Profile()), // Öğretmen için profil sayfası
        ];
      case UserRole.student:
        return [
          _buildNavigator(0, Scaffold()), // Öğrenci için sınıf sayfası
          _buildNavigator(
              1,
              AnnouncementsPage(
                  role: user.role,
                  classModels:
                      user.classModels)), // Öğrenci için duyurular sayfası
          _buildNavigator(2, Scaffold()), // Öğrenci için favoriler sayfası
          _buildNavigator(3, Profile()), // Öğrenci için profil sayfası
        ];
      case UserRole.admin:
        return [
          _buildNavigator(0, Scaffold()), // Admin için ana sayfa
          _buildNavigator(
              1,
              AnnouncementsPage(
                  role: user.role,
                  classModels:
                      user.classModels)), // Admin için duyurular sayfası
          _buildNavigator(2, Profile()), // Admin için profil sayfası
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
    return BlocConsumer<AuthBloc, AuthState>(
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
                final pages =
                    _buildNavigators(userState.user); // Sayfa listesini oluştur
                return Scaffold(
                  body: IndexedStack(
                    index: _selectedIndex,
                    children: pages,
                  ),
                  bottomNavigationBar: _buildBottomNavigationBarForRole(
                      userState.user.role!), // Rol tabanlı BottomNavigationBar
                );
              } else if (userState is UserLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (userState is UserError) {
                return Center(
                    child:
                        Text('Failed to load user data: ${userState.message}'));
              } else {
                return const Center(child: Text('Failed to load user data'));
              }
            },
          );
        } else {
          // Kullanici cikis yaptiktan sonra bottomNavigationBar iptal edildi.HomePage sayfasina yonlendiriyor direkt
          return Scaffold(body: Homepage()
              // bottomNavigationBar: _buildBottomNavigationBarForNotLoggedInUser(),
              );
        }
      },
    );
  }

  Widget _buildContentForNotLoggedInUser() {
    switch (_selectedIndex) {
      case 0:
        return Scaffold(); // Giriş yapmamış kullanıcılar için ana sayfa
      case 1:
        return LoginOrSignUp(); // Bilgi sayfası
      default:
        return Scaffold();
    }
  }

  BottomNavigationBar _buildBottomNavigationBarForRole(UserRole role) {
    List<BottomNavigationBarItem> items;
    BottomNavigationBarType? type;
    switch (role) {
      case UserRole.teacher:
        items = [
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'Classes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Announcements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ];
        type = BottomNavigationBarType.fixed;
        break;
      case UserRole.student:
        items = [
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Education',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Announcements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ];
        type = BottomNavigationBarType.fixed;
        break;
      case UserRole.admin:
        items = [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Announcements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ];
        type = BottomNavigationBarType.fixed;
        break;
      default:
        items = [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Announcements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ];
    }
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: type,
      onTap: _onItemTapped,
      items: items,
    );
  }

  // BottomNavigationBar _buildBottomNavigationBarForNotLoggedInUser() {
  //   return BottomNavigationBar(
  //     currentIndex: _selectedIndex,
  //     onTap: (index) {
  //       setState(() {
  //         _selectedIndex = index;
  //       });
  //     },
  //     items: const <BottomNavigationBarItem>[
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.info),
  //         label: 'Info',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.login),
  //         label: 'Login',
  //       ),
  //     ],
  //   );
  // }
}
