import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/bloc/auth/auth_drawer/drawer_manager.dart';
import 'package:tobetoapp/bloc/catalog/catalog_favorites/catalog_favorite_bloc.dart';
import 'package:tobetoapp/bloc/catalog/catalog_favorites/catalog_favorite_event.dart';
import 'package:tobetoapp/bloc/catalog/catalog_favorites/catalog_favorite_state.dart';
import 'package:tobetoapp/bloc/favorites/favorite_bloc.dart';
import 'package:tobetoapp/bloc/favorites/favorite_event.dart';
import 'package:tobetoapp/bloc/favorites/favorite_state.dart';
import 'package:tobetoapp/models/catalog_model.dart';
import 'package:tobetoapp/models/lesson_model.dart';
import 'package:tobetoapp/repository/lessons/lesson_repository.dart';
import 'package:tobetoapp/repository/catalog/catalog_repository.dart';
import 'package:tobetoapp/screens/catalog/catalog_lesson_page.dart';
import 'package:tobetoapp/screens/lesson_details_and_video/lesson_details_page.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/widgets/banner_widget.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<FavoritesBloc>().add(LoadFavorites());
    context.read<CatalogFavoritesBloc>().add(LoadCatalogFavorites());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lessonRepository = context.read<LessonRepository>();
    final catalogRepository = context.read<CatalogRepository>();

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/logo/tobetologo.PNG",
          width: AppConstants.screenWidth * 0.43,
        ),
        centerTitle: true,
      ),
      drawer: DrawerManager(),
      body: Column(
        children: [
          const BannerWidget(
            imagePath: 'assets/logo/general_banner.png',
            text: 'Favorilerim',
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Dersler'),
              Tab(text: 'Katalog Eğitimleri'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFavoritesLessons(context, lessonRepository),
                _buildFavoritesCatalogs(context, catalogRepository),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesLessons(
      BuildContext context, LessonRepository lessonRepository) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, favoritesState) {
        if (favoritesState is FavoritesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (favoritesState is FavoritesLoaded) {
          final favoriteLessonIds = favoritesState.favoriteLessonIds;

          if (favoriteLessonIds.isEmpty) {
            return const Center(child: Text('Favori dersleriniz henüz boş!'));
          }

          return ListView(
            children: favoriteLessonIds.map((lessonId) {
              return FutureBuilder<LessonModel>(
                future: lessonRepository.getLessonById(lessonId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text('Loading...'),
                    );
                  } else if (snapshot.hasData) {
                    final lesson = snapshot.data!;
                    return ListTile(
                      leading: lesson.image != null
                          ? Image.network(lesson.image!)
                          : null,
                      title: Text(lesson.title ?? 'No title'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lesson.description ?? 'No description'),
                          Text(DateFormat('dd MMM yyyy, HH:mm')
                              .format(lesson.startDate!)),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LessonDetailsPage(lesson: lesson),
                          ),
                        );
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              );
            }).toList(),
          );
        } else {
          return const Center(child: Text('Favori dersleriniz henüz boş!'));
        }
      },
    );
  }

  Widget _buildFavoritesCatalogs(
      BuildContext context, CatalogRepository catalogRepository) {
    return BlocBuilder<CatalogFavoritesBloc, CatalogFavoritesState>(
      builder: (context, catalogFavoritesState) {
        if (catalogFavoritesState is CatalogFavoritesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (catalogFavoritesState is CatalogFavoritesLoaded) {
          final favoriteCatalogIds = catalogFavoritesState.favoriteCatalogIds;

          if (favoriteCatalogIds.isEmpty) {
            return const Center(
                child: Text('Favori katalog eğitimleriniz henüz boş!'));
          }

          return ListView(
            children: favoriteCatalogIds.map((catalogId) {
              return FutureBuilder<CatalogModel>(
                future: catalogRepository.getCatalogById(catalogId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text('Loading...'),
                    );
                  } else if (snapshot.hasData) {
                    final catalog = snapshot.data!;
                    return ListTile(
                      leading: catalog.imageUrl != null
                          ? Image.network(catalog.imageUrl!)
                          : null,
                      title: Text(catalog.title ?? 'No title'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(catalog.content ?? 'No description'),
                          Text(DateFormat('dd MMM yyyy, HH:mm')
                              .format(catalog.startDate!)),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CatalogLessonPage(catalogId: catalog),
                          ),
                        );
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              );
            }).toList(),
          );
        } else {
          return const Center(
              child: Text('Favori katalog eğitimleriniz henüz boş!'));
        }
      },
    );
  }
}
