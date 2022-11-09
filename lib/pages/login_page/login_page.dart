import 'package:birds_museum/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Image.asset(
              'images/music.png',
              height: 100,
              width: 100,
            ),
          ),
          ElevatedButton.icon(
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
          )
        ],
      ),
    );
  }
}
