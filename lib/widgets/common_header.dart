import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/favorites/favorites_bloc.dart';
import 'package:tobetoapp/bloc/favorites/favorites_event.dart';
import 'package:tobetoapp/bloc/favorites/favorites_state.dart';

class CommonHeader extends StatelessWidget {
  final String? title;
  final String? itemId;
  final VoidCallback onInfoPressed;
  final bool isFavoriteLoading;

  const CommonHeader({
    Key? key,
    required this.title,
    required this.itemId,
    required this.onInfoPressed,
    this.isFavoriteLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title ?? 'Başlık Yok',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        if (isFavoriteLoading)
          const CircularProgressIndicator()
        else
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              if (state is FavoritesLoaded) {
                final isFavorite = state.favoriteId.contains(itemId);
                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  onPressed: () {
                    _toggleFavorite(context, isFavorite);
                  },
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        IconButton(
          icon: const Icon(Icons.info),
          onPressed: onInfoPressed,
        ),
      ],
    );
  }

  void _toggleFavorite(BuildContext context, bool isFavorite) {
    if (isFavorite) {
      context.read<FavoritesBloc>().add(RemoveFavorite(itemId!));
    } else {
      context.read<FavoritesBloc>().add(AddFavorite(itemId!));
    }
  }
}
