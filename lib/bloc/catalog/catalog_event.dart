abstract class CatalogEvent {}

class LoadCatalogs extends CatalogEvent {
  final String catalogId;

  LoadCatalogs(this.catalogId);
}
