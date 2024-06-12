import 'package:flutter/material.dart';
import 'package:tobetoapp/theme/constants/constants.dart';
import 'package:tobetoapp/theme/light/light_theme.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const DrawerItem({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(AppConstants.paddingSmall),
          width: 250,
          decoration: BoxDecoration(
            color: AppColors.tobetoMoru,
            borderRadius: BorderRadius.circular(AppConstants.br10),
          ),
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

/*
class DrawerItemUser extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const DrawerItemUser({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        onTap: onTap,
      ),
    );
  }
}
*/
