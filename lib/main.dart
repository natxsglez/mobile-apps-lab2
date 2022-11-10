import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:birds_museum/bloc/auth_bloc/auth_bloc.dart';
import 'package:birds_museum/bloc/auth_bloc/auth_repository.dart';
import 'package:birds_museum/bloc/favorites_bloc/favorites_bloc.dart';
import 'package:birds_museum/bloc/favorites_bloc/favorites_repository.dart';
import 'package:birds_museum/bloc/recognize_song_bloc/recognize_song_bloc.dart';
import 'package:birds_museum/bloc/recognize_song_bloc/recognize_song_repository.dart';
import 'package:birds_museum/bloc/record/record_bloc.dart';
import 'package:birds_museum/bloc/record/record_repository.dart';
import 'package:birds_museum/models/user_model.dart';
import 'package:birds_museum/pages/home_page/home_page.dart';
import 'package:birds_museum/pages/login_page/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => FavoritesRepository()),
        RepositoryProvider(create: (context) => RecognizeSongRepository()),
        RepositoryProvider(create: (context) => RecordRepository())
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  AuthBloc(authRepository: context.read<AuthRepository>())
                    ..add(AuthCheckLoginStatusEvent())),
          BlocProvider(
              create: (BuildContext context) => FavoritesBloc(
                  favoritesRepository: context.read<FavoritesRepository>())),
          BlocProvider(
              create: (BuildContext context) => RecognizeSongBloc(
                  recognizeSongRepository:
                      context.read<RecognizeSongRepository>())),
          BlocProvider(
              create: (BuildContext context) => RecordBloc(
                  recordRepository: context.read<RecordRepository>()))
        ],
        child: const MyApp(),
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark(),
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        home: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoggedInState) {
              final UserModel? userLogged =
                  BlocProvider.of<AuthBloc>(context).currUser;
              if (userLogged == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Inicia sesión para usar la app",
                    ),
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            if (state is AuthLoggedInState) {
              final UserModel? userLogged =
                  BlocProvider.of<AuthBloc>(context).currUser;
              if (userLogged != null) {
                return HomePage();
              }
            }
            return const LoginPage();
          },
        ));
  }
}
