import 'package:birds_museum/pages/home_page/home_page.dart';
import 'package:birds_museum/providers/favorites/fav_provider.dart';
import 'package:birds_museum/providers/recognize_song/recognize_song_provider.dart';
import 'package:birds_museum/providers/recorder/recorder_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
  }
  return false;
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => FavoritesProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => RecorderProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => RecognizeSongProvider(),
      )
    ],
    child: const MyApp(),
  ));
  await requestPermission(Permission.storage);
  await requestPermission(Permission.microphone);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark(), title: 'Material App', home: const HomePage());
  }
}
