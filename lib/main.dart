import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tobetoapp/bloc/announcements/announcement_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_bloc.dart';
import 'package:tobetoapp/bloc/class/class_bloc.dart';
import 'package:tobetoapp/bloc/user/user_bloc.dart';
import 'package:tobetoapp/repository/announcements_repo.dart';
import 'package:tobetoapp/repository/auth_repo.dart';
import 'package:tobetoapp/repository/class_repository.dart';
import 'package:tobetoapp/repository/user_repository.dart';
import 'package:tobetoapp/screens/homepage.dart';
import 'package:tobetoapp/screens/mainpage.dart';
import 'package:tobetoapp/theme/constants/constants.dart';
import 'package:tobetoapp/theme/theme_data.dart';
import 'package:tobetoapp/theme/theme_switcher.dart';
import 'package:tobetoapp/widgets/guest/animated_container.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthRepository(), UserRepository()),
        ),
        BlocProvider(
          create: (context) => UserBloc(UserRepository()),
        ),
        BlocProvider(
          create: (context) => AnnouncementBloc(AnnouncementRepository()),
        ),
        BlocProvider(
          create: (context) => ClassBloc(ClassRepository()),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>(); // tema için
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  final ThemeService _themeService = ThemeService();
  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final themeMode = await _themeService.getThemeMode();
    setState(() {
      _themeMode = themeMode;
    });
  }

  void setTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        AppConstants.init(context);

        return (ChangeNotifierProvider(
          create: (context) => AnimationControllerExample(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: AppThemes.light,
            darkTheme: AppThemes.dark,
            themeMode: _themeMode,
            home: const Homepage(),
          ),
        ));
      },
    );
  }
}
