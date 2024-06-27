import 'package:flutter/material.dart';
import 'package:tobetoapp/models/catalog_model.dart';

class CatalogTile extends StatelessWidget {
  final CatalogModel catalog;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CatalogTile({
    super.key,
    required this.catalog,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(catalog.title!),
      subtitle: Text(catalog.content!),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}