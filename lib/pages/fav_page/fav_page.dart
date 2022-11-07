// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:birds_museum/pages/fav_page/fav_list.dart';
import 'package:birds_museum/providers/favorites/fav_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: context.watch<FavoritesProvider>().getFavList.isNotEmpty
          ? FavoritesList()
          : _createNotFavoritesYetText(),
    );
  }

  Column _createNotFavoritesYetText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Aún no tienes canciones guardadas",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ],
    );
  }
}
