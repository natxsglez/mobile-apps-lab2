// ignore_for_file: prefer_const_constructors

import 'package:birds_museum/models/platform_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PlatformsList extends StatelessWidget {
  final List<PlatformModel> platformData;
  const PlatformsList({super.key, required this.platformData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Abrir con:"),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _selectPlatformsThatFoundResult,
        )
      ],
    );
  }

  List<Widget> get _selectPlatformsThatFoundResult {
    List<Widget> result = [];
    for (int i = 0; i < platformData.length; i++) {
      if (platformData[i].platformName == "spotify") {
        result.add(_createIconBtn(FaIcon(FontAwesomeIcons.spotify),
            "Ver en Spotify", platformData[i].url));
      }

      if (platformData[i].platformName == "apple_music") {
        result.add(_createIconBtn(FaIcon(FontAwesomeIcons.apple),
            "Ver en Apple Music", platformData[i].url));
      }

      if (platformData[i].platformName == "deezer") {
        result.add(
          _createIconBtn(FaIcon(FontAwesomeIcons.deezer), "Ver en Deezer",
              platformData[i].url),
        );
      }
    }

    return result;
  }

  IconButton _createIconBtn(Widget icon, String tooltipStr, String url) {
    return IconButton(
        icon: icon,
        tooltip: tooltipStr,
        iconSize: 60,
        onPressed: () {
          _launchUrl(url);
        });
  }

  void _launchUrl(String url) async {
    Uri parsedUrl = Uri.parse(url);
    if (!await canLaunchUrl(parsedUrl)) {
      throw 'Could not launch $url';
    } else {
      launchUrl(
        parsedUrl,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
