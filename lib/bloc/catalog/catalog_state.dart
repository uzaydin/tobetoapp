import 'package:tobetoapp/models/catalog_model.dart';

abstract class CatalogState {}

class CatalogsLoading extends CatalogState {}

class CatalogsLoaded extends CatalogState {
  final List<CatalogModel> catalogs;

  CatalogsLoaded(this.catalogs);
}

class CatalogOperationSuccess extends CatalogState {}

class CatalogOperationFailure extends CatalogState {
  final String error;

  CatalogOperationFailure(this.error);
}


