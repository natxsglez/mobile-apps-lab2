import 'package:birds_museum/pages/fav_page/fav_item.dart';
import 'package:birds_museum/bloc/bloc/fav_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesList extends StatefulWidget {
  const FavoritesList({super.key});

  @override
  State<FavoritesList> createState() => _FavoritesListState();
}

class _FavoritesListState extends State<FavoritesList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: ListView.builder(
                itemCount: context.watch<FavoritesProvider>().getFavList.length,
                itemBuilder: (BuildContext context, int index) {
                  return FavoriteItem(
                      favItem:
                          context.read<FavoritesProvider>().getFavList[index]);
                }))
      ],
    );
  }
}
