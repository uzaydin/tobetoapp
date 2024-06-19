import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tobetoapp/bloc/admin/admin_bloc.dart';
import 'package:tobetoapp/bloc/announcements/announcement_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_drawer/auth_provider_drawer.dart';
import 'package:tobetoapp/bloc/blog/blog_bloc.dart';
import 'package:tobetoapp/bloc/catalog/catalog_bloc.dart';
import 'package:tobetoapp/bloc/class/class_bloc.dart';
import 'package:tobetoapp/bloc/exam/exam_bloc.dart';
import 'package:tobetoapp/bloc/favorites/favorite_bloc.dart';
import 'package:tobetoapp/bloc/lessons/lesson_bloc.dart';
import 'package:tobetoapp/bloc/lessons/lesson_live/live_session_bloc.dart';
import 'package:tobetoapp/bloc/lessons/lesson_video/video_bloc.dart';
import 'package:tobetoapp/bloc/news/news_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/user/user_bloc.dart';
import 'package:tobetoapp/homework/homework_bloc.dart';
import 'package:tobetoapp/repository/announcements_repo.dart';
import 'package:tobetoapp/repository/auth_repo.dart';
import 'package:tobetoapp/repository/blog_repository.dart';
import 'package:tobetoapp/repository/catalog_repository.dart';
import 'package:tobetoapp/repository/class_repository.dart';
import 'package:tobetoapp/repository/exam_repository.dart';
import 'package:tobetoapp/repository/lessons/homework_repository.dart';
import 'package:tobetoapp/repository/lessons/lesson_live_repository.dart';
import 'package:tobetoapp/repository/lessons/lesson_repository.dart';
import 'package:tobetoapp/repository/lessons/lesson_video_repository.dart';
import 'package:tobetoapp/repository/news_repository.dart';
import 'package:tobetoapp/repository/profile_repository.dart';
import 'package:tobetoapp/repository/user_repository.dart';
import 'package:tobetoapp/screens/homepage.dart';
import 'package:tobetoapp/theme/constants/constants.dart';
import 'package:tobetoapp/theme/theme_data.dart';
import 'package:tobetoapp/theme/theme_switcher.dart';
import 'package:tobetoapp/widgets/drawer/common_drawer.dart';
import 'package:tobetoapp/widgets/drawer/common_user_drawer.dart';
import 'package:tobetoapp/widgets/guest/animated_container.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(Home(
    sharedPreferences: sharedPreferences,
  ));
}

class Home extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const Home({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<LessonRepository>(create: (_) => LessonRepository()),
          Provider<SharedPreferences>.value(value: sharedPreferences),
          ChangeNotifierProvider(create: (_) => AuthProviderDrawer()),
          ChangeNotifierProvider(create: (_) => AnimationControllerExample()),
        ],
        child: MultiBlocProvider(
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
            BlocProvider(
              create: (context) => NewsBloc(NewsRepository()),
            ),
            BlocProvider(
              create: (context) => BlogBloc(BlogRepository()),
            ),
            BlocProvider(
              create: (context) => CatalogBloc(CatalogRepository()),
            ),
            BlocProvider(
              create: (context) => LessonBloc(LessonRepository()),
            ),
            BlocProvider(
              create: (context) => VideoBloc(VideoRepository()),
            ),
            BlocProvider(
              create: (context) => FavoritesBloc(sharedPreferences),
            ),
            BlocProvider<ProfileBloc>(
              create: (context) =>
                  ProfileBloc(profileRepository: ProfileRepository()),
            ),
            BlocProvider(
              create: (context) => ExamBloc(examRepository: ExamRepository()),
            ),
            BlocProvider(
              create: (context) => HomeworkBloc(HomeworkRepository()),
            ),
            BlocProvider(
              create: (context) => LiveSessionBloc(LessonLiveRepository()),
            ),
            BlocProvider<AdminBloc>(
            create: (context) => AdminBloc(UserRepository(), ClassRepository(),
                LessonRepository()),
          ),
          ],
          child: const MyApp(),
        ));
  }
}

class MyApp extends StatefulWidget {
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>(); // tema için
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  ThemeMode _themeMode = ThemeMode.light;
  final ThemeService _themeService = ThemeService();
  @override
  void initState() {
    super.initState();
    _loadThemeMode();
    WidgetsBinding.instance.addObserver(this);
    // app kapatıldığında oturum da kapatılsın diye
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      // Uygulama kapatıldığında oturumu kapat
      final authProvider =
          Provider.of<AuthProviderDrawer>(context, listen: false);
      authProvider.logout();
    }
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
        return Consumer<AuthProviderDrawer>(
          builder: (context, authProvider, _) {
            final drawer = authProvider.isLoggedIn
                ? const CommonUserDrawer()
                : const CommonDrawer();
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: AppThemes.light,
              darkTheme: AppThemes.dark,
              themeMode: _themeMode,
              home: const Homepage(),
              builder: (context, child) {
                return Scaffold(
                  body: child,
                  drawer: drawer,
                );
              },
            );
          },
        );
      },
    );
  }
}
