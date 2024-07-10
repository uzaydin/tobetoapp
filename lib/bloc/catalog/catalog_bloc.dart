import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/catalog/catalog_event.dart';
import 'package:tobetoapp/bloc/catalog/catalog_state.dart';
import 'package:tobetoapp/models/catalog_model.dart';
import 'package:tobetoapp/repository/catalog/catalog_repository.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final CatalogRepository _catalogRepository;
  StreamSubscription<List<CatalogModel>>? _catalogsSubscription;

  CatalogBloc(this._catalogRepository) : super(CatalogsLoading()) {
    on<LoadCatalogs>(_loadCatalogs);
  }

  Future<void> _loadCatalogs(
      LoadCatalogs event, Emitter<CatalogState> emit) async {
    emit(CatalogsLoading());
    try {
      final catalogs = await _catalogRepository.getCatalog(event.catalogId);
      if (catalogs.isEmpty) {
        emit(CatalogOperationFailure('No found.'));
      } else {
        emit(CatalogsLoaded(catalogs));
      }
    } catch (e) {
      emit(CatalogOperationFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _catalogsSubscription?.cancel();
    return super.close();
  }
}

