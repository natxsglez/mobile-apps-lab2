// ignore_for_file: unused_local_variable, prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

String? finalRecordingPath;

class RecorderProvider with ChangeNotifier {
  final _recorder = Record();
  bool _isRecording = false;

  bool get getIsRecording => _isRecording;

  Future<dynamic> recordSong() async {
    Directory? filePath = await getExternalStorageDirectory();
    final file = filePath?.path;
    String? recordPath;

    if (!await filePath!.exists()) {
      await filePath.create(recursive: true);
    }

    if (await _recorder.hasPermission()) {
      await _recorder.start(
          path: '$file/${DateTime.now().millisecondsSinceEpoch}.m4a');
    }

    _isRecording = await _recorder.isRecording();
    notifyListeners();

    if (_isRecording) {
      await Future.delayed(Duration(seconds: 5), _stopRecording);
    }
    _isRecording = false;
    notifyListeners();
    return finalRecordingPath ?? "Falla en grabación";
  }

  void _stopRecording() async {
    finalRecordingPath = await _recorder.stop();
  }
}
