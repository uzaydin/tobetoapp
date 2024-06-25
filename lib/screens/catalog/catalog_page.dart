import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/catalog/catalog_bloc.dart';
import 'package:tobetoapp/bloc/catalog/catalog_event.dart';
import 'package:tobetoapp/bloc/catalog/catalog_state.dart';
import 'package:tobetoapp/models/catalog_model.dart';
import 'package:tobetoapp/screens/catalog/catalog_detail_page.dart';
import 'package:tobetoapp/screens/catalog/catalog_filter_widget.dart';

class CatalogPage extends StatefulWidget {

  const CatalogPage({
    super.key,
  });

  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  List<CatalogModel> catalogs = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CatalogBloc>(context).add(LoadCatalogs(''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eğitimlerimiz"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final filteredList = await showDialog<List<CatalogModel>>(
                context: context,
                builder: (BuildContext context) {
                  return const Dialog(
                    child: CatalogFilterWidget(),
                  );
                },
              );

              if (filteredList != null) {
                setState(() {
                  catalogs = filteredList;
                });
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) {
          if (state is CatalogsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CatalogsLoaded) {
            if (catalogs.isEmpty) {
              catalogs = state.catalogs;
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                childAspectRatio: 2 / 3, 
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: const EdgeInsets.all(10),
              itemCount: catalogs.length,
              itemBuilder: (context, index) {
                CatalogModel catalog = catalogs[index];
                String imageUrl = catalog.imageUrl!;
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CatalogDetailPage(catalogId: catalog ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.6),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  catalog.title ?? 'Başlık Yok',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                                   ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
          } else if (state is CatalogOperationFailure) {
            return const Center(
              child: Text('Eğitimler yüklenirken hata oluştu.'),
            );
          } else {
            return const Center(
              child: Text('Başka bir hata oluştu.'),
            );
          }
        },
      ),
    );
  }
}

