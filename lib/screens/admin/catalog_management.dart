import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_event.dart';
import 'package:tobetoapp/bloc/admin/admin_state.dart';
import 'package:tobetoapp/models/catalog_model.dart';
import 'package:tobetoapp/screens/admin/catalog_edit.dart';
import 'package:tobetoapp/widgets/admin/catalog_tile.dart';
import 'package:tobetoapp/widgets/search_bar.dart';

class CatalogManagementPage extends StatefulWidget {
  const CatalogManagementPage({super.key});

  @override
  _CatalogManagementPageState createState() => _CatalogManagementPageState();
}

class _CatalogManagementPageState extends State<CatalogManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  List<CatalogModel> _filteredCatalogs = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  void _loadData() {
    context.read<AdminBloc>().add(LoadCatalogs());
  }

  void _onSearchChanged() {
    final searchQuery = _searchController.text.toLowerCase();
    final adminBlocState = context.read<AdminBloc>().state;

    setState(() {
      if (adminBlocState is CatalogsLoaded) {
        _filteredCatalogs = adminBlocState.catalogs.where((catalog) {
          final title = catalog.title?.toLowerCase() ?? '';
          return title.contains(searchQuery);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBarWidget(
              controller: _searchController,
              hintText: 'Eğitim başlığı giriniz',
            ),
          ),
          Expanded(
            child: BlocBuilder<AdminBloc, AdminState>(
              builder: (context, state) {
                if (state is AdminLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AdminError) {
                  return const Center(child: Text('Yüklenirken bir hata oluştu. Lütfen tekrar deneyiniz.'));
                } else if (state is CatalogsLoaded) {
                  final itemsToDisplay = _searchController.text.isEmpty ? state.catalogs : _filteredCatalogs;

                  return ListView.builder(
                    itemCount: itemsToDisplay.length,
                    itemBuilder: (context, index) {
                      final catalog = itemsToDisplay[index];
                      return Column(
                        children: [
                          CatalogTile(
                            catalog: catalog,
                            onEdit: () => _navigateToEditCatalogPage(context, catalog.catalogId!),
                            onDelete: () => _showDeleteCatalogDialog(context, catalog.catalogId!),
                          ),
                          const Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCatalogDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToEditCatalogPage(BuildContext context, String catalogId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<AdminBloc>(),
          child: CatalogEditPage(catalogId: catalogId),
        ),
      ),
    );
  }

  void _showAddCatalogDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Katalog ekle'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Başlık'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'İçerik'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                final newCatalog = CatalogModel(
                  catalogId: '',
                  title: titleController.text,
                  content: descriptionController.text,
                );
                context.read<AdminBloc>().add(AddCatalog(newCatalog));
                Navigator.pop(context);
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteCatalogDialog(BuildContext context, String catalogId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Katalog sil'),
          content: const Text('Bu eğitimi silmek istediğinize emin misiniz ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                context.read<AdminBloc>().add(DeleteCatalog(catalogId));
                Navigator.pop(context);
              },
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );
  }
}
