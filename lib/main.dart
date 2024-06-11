import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tobetoapp/bloc/announcements/announcement_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_bloc.dart';
import 'package:tobetoapp/bloc/blog/blog_bloc.dart';
import 'package:tobetoapp/bloc/catalog/catalog_bloc.dart';
import 'package:tobetoapp/bloc/class/class_bloc.dart';
import 'package:tobetoapp/bloc/favorites/favorite_bloc.dart';
import 'package:tobetoapp/bloc/lessons/lesson_bloc.dart';
import 'package:tobetoapp/bloc/lessons/lesson_video/video_bloc.dart';
import 'package:tobetoapp/bloc/news/news_bloc.dart';
import 'package:tobetoapp/bloc/user/user_bloc.dart';
import 'package:tobetoapp/repository/announcements_repo.dart';
import 'package:tobetoapp/repository/auth_repo.dart';
import 'package:tobetoapp/repository/blog_repository.dart';
import 'package:tobetoapp/repository/catalog_repository.dart';
import 'package:tobetoapp/repository/class_repository.dart';

import 'package:tobetoapp/repository/lessons/lesson_repository.dart';
import 'package:tobetoapp/repository/lessons/lesson_video_repository.dart';
import 'package:tobetoapp/repository/news_repository.dart';
import 'package:tobetoapp/repository/user_repository.dart';
import 'package:tobetoapp/screens/homepage.dart';
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
          ],
          child: const MyApp(),
        ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return (ChangeNotifierProvider(
        create: (context) => AnimationControllerExample(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const Homepage(),
        )));
  }
}
