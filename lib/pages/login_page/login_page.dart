import 'package:birds_museum/bloc/auth_bloc/auth_bloc.dart';
import 'package:birds_museum/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MaterialButton(
              color: Colors.white,
              shape: const CircleBorder(),
              height: 300,
              onPressed: () async {},
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Image.asset(
                  'images/music.png',
                  height: 100,
                  width: 100,
                ),
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
            child: ElevatedButton.icon(
              icon: const FaIcon(
                FontAwesomeIcons.google,
              ),
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(AuthGoogleLoginEvent());
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.grey[350],
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: const Color.fromARGB(0xFF, 0xDC, 0x4E, 0x41),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.0),
                  )),
              label: const Text(
                "INICIAR SESION CON GOOGLE",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
