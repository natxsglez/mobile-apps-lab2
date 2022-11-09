import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class RecordRepository {
  final _recorder = Record();
  bool _isRecording = false;
  String? filePath;
  String? finalRecordingPath;

  FutureOr<bool> _requestPermission(Permission permission) async {
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

  FutureOr<void> _stopRecording() async {
    finalRecordingPath = await _recorder.stop();
  }

  Future<void> getPermissions() async {
    final storagePermission = await _requestPermission(Permission.storage);
    final microphonePermission =
        await _requestPermission(Permission.microphone);

    if (!storagePermission || !microphonePermission) {
      throw "Not enough permissions to use the app";
    }
  }

  Future<dynamic> recordSong() async {
    Directory? filePath = await getExternalStorageDirectory();
    final file = filePath?.path;

    if (!await filePath!.exists()) {
      await filePath.create(recursive: true);
    }

    if (await _recorder.hasPermission()) {
      await _recorder.start(
          path: '$file/${DateTime.now().millisecondsSinceEpoch}.m4a');
    } else {
      throw "Not enough permissions";
    }

    _isRecording = await _recorder.isRecording();

    if (_isRecording) {
      await Future.delayed(const Duration(seconds: 7), _stopRecording);
    }
    _isRecording = false;
    return finalRecordingPath ?? "Falla en grabación";
  }
}
