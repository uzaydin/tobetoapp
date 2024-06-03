import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_state.dart';
import 'package:tobetoapp/bloc/catalog/catalog_bloc.dart';
import 'package:tobetoapp/bloc/lesson/lesson_bloc.dart';
import 'package:tobetoapp/repository/auth_repo.dart';
import 'package:tobetoapp/repository/catalog_repository.dart';
import 'package:tobetoapp/repository/lesson_repository.dart';
import 'package:tobetoapp/screens/homepage.dart';
import 'package:tobetoapp/screens/lessons_category_screen.dart';
import 'package:tobetoapp/screens/user/profilim.dart';

// Bottom Navigation Bar sayfasi 

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider<AuthBloc>(
        //   create: (context) => AuthBloc(AuthRepository()),
        // ),
        BlocProvider<CatalogBloc>(
          create: (context) => CatalogBloc(catalogRepository: CatalogRepository()),
),
        BlocProvider<LessonBloc>(
          create: (context) => LessonBloc(lessonRepository: LessonRepository()),
        ),
      ],
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Homepage(),));
          } else if (state is AuthSuccess) {
            setState(() {
              _selectedIndex = 0; // Ana sayfaya yönlendirme
            });
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AuthSuccess) {
            return Scaffold(
              body: _buildContentForLoggedInUser(state.role!),
              bottomNavigationBar: _buildBottomNavigationBarForRole(state.role!),
            );
          } else {
            return Scaffold(
              body: _buildContentForNotLoggedInUser(),
              bottomNavigationBar: _buildBottomNavigationBarForNotLoggedInUser(),
            );
          }
        },
      ),
    );
  }

  Widget _buildContentForLoggedInUser(String role) {
    switch (role) {
      case 'teacher':
        return _buildTeacherContent(role);
      case 'student':
        return _buildStudentContent(role);
      case 'admin':
        return _buildAdminContent(role);
      default:
        return const Scaffold();
    }
  }

  Widget _buildTeacherContent(String role) {
    switch (_selectedIndex) {
      case 0:
        return const Scaffold(); // Öğretmen için sınıflar sayfası
      case 1:
        return const Scaffold(); // Öğretmen için duyurular sayfası
      case 2:
        return const Profil(); // Profil sayfası
      default:
        return const Scaffold();
    }
  }

  Widget _buildStudentContent(String role) {
    switch (_selectedIndex) {
      case 0:
        return const LessonsCategoryScreen(); // Öğrenci için eğitim sayfası
      case 1:
        return const Scaffold(); // Öğrenci için duyurular sayfası
      case 2:
        return const Scaffold(); // Öğrenci için favoriler sayfası
      case 3:
        return const Profil(); // Profil sayfası
      default:
        return const Scaffold();
    }
  }

  Widget _buildAdminContent(String role) {
    switch (_selectedIndex) {
      case 0:
        return const Scaffold(); // Admin için ana sayfa
      case 1:
        return const Scaffold(); // Admin için duyurular sayfası
      case 2:
        return const Profil(); // Admin için profil sayfası
      case 3:
        return const Scaffold(); // Diğer admin sayfalarını buraya ekleyebilirsiniz
      default:
        return const Scaffold();
    }
  }

  Widget _buildContentForNotLoggedInUser() {
    switch (_selectedIndex) {
      case 0:
        return const LessonsCategoryScreen(); // Giriş yapmamış kullanıcılar için ana sayfa
      case 1:
        return const Scaffold(); // Bilgi sayfası
      default:
        return const LessonsCategoryScreen(); //(yağmur) Kategori sayfası
    }
  }

  BottomNavigationBar _buildBottomNavigationBarForRole(String role) {
    List<BottomNavigationBarItem> items;
    // Student rolünde 3'ten fazla tab olduğu için type kullanıyoruz.
    BottomNavigationBarType? type;
    switch (role) {
      case 'teacher':
        items = [
          const BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'Classes',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Announcements',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ];
        type = BottomNavigationBarType.fixed;
        break;
      case 'student':
        items = [
          const BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Education',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Announcements',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ];
        type = BottomNavigationBarType.fixed;
        break;
      case 'admin':
        items = [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Announcements',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
          // Diğer admin öğelerini buraya ekleyebilirsiniz
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
            label: 'Announcements',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ];
    }
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: type, // Type parametresini girdiğimizde bütün bottomNavigationBar'lar aynı özellikte oluyor.
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: items,
    );
  }

  BottomNavigationBar _buildBottomNavigationBarForNotLoggedInUser() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'Info',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.login),
          label: 'Login',
        ),
      ],
    );
  }
}
