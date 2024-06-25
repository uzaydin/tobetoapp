// import 'package:tobetoapp/models/catalog_model.dart';

abstract class CatalogEvent {}

class LoadCatalogs extends CatalogEvent {
  final String catalogId;

  LoadCatalogs(this.catalogId);
}

// class AddCatalog extends CatalogEvent {
//   final CatalogModel catalogModel;

//   AddCatalog(this.catalogModel);
// }

// class DeleteCatalog extends CatalogEvent {
//   final String id;

//   DeleteCatalog(this.id);
// }

// class CatalogsUpdated extends CatalogEvent {
//   final List<CatalogModel> catalogs;

//   CatalogsUpdated(this.catalogs);
// }