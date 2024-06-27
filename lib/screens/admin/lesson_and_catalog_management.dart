import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_event.dart';
import 'package:tobetoapp/screens/admin/catalog_management.dart';
import 'package:tobetoapp/screens/admin/lesson_management.dart';

class LessonAndCatalogManagementPage extends StatefulWidget {
  const LessonAndCatalogManagementPage({super.key});

  @override
  _LessonAndCatalogManagementPageState createState() => _LessonAndCatalogManagementPageState();
}

class _LessonAndCatalogManagementPageState extends State<LessonAndCatalogManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

void _onTabChanged() {
  setState(() {
    if (_tabController.index == 0) {
      _loadLessons(); 
    } else if (_tabController.index == 1) {
      _loadCatalogs(); 
    }
  });
}

  void _loadLessons() {
    context.read<AdminBloc>().add(LoadLessons());
  }

  void _loadCatalogs() {
    context.read<AdminBloc>().add(LoadCatalogs());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yönetim'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Ders Yönetimi'),
            Tab(text: 'Katalog Yönetimi'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          LessonManagementPage(),
          CatalogManagementPage(),
        ],
      ),
    );
  }
}
