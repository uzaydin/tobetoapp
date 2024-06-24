import 'package:flutter/material.dart';
import 'package:tobetoapp/screens/catalog/catalog_page.dart';

class CatalogGuest extends StatefulWidget {
  const CatalogGuest({super.key});

  @override
  State<CatalogGuest> createState() => _CatalogGuestState();
}

class _CatalogGuestState extends State<CatalogGuest> {
  @override
  Widget build(BuildContext context) {
    return const CatalogPage();
  }
}