// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PlatformsList extends StatelessWidget {
  final Map<dynamic, dynamic> songData;
  const PlatformsList({super.key, required this.songData});

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
    if (songData.containsKey("spotify")) {
      result.add(_createIconBtn(FaIcon(FontAwesomeIcons.spotify),
          "Ver en Spotify", songData["spotify"]["external_urls"]["spotify"]));
    }

    if (songData.containsKey("apple_music")) {
      result.add(_createIconBtn(FaIcon(FontAwesomeIcons.apple),
          "Ver en Apple Music", songData["apple_music"]["url"]));
    }

    if (songData.containsKey("deezer")) {
      result.add(
        _createIconBtn(FaIcon(FontAwesomeIcons.deezer), "Ver en Deezer",
            songData["deezer"]["link"]),
      );
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
