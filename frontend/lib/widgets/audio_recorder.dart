import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

void _createFile(String _completeFileName) async {
  final directory = await getApplicationDocumentsDirectory();
  String _path = directory.path;
  File(_path + '/audio-files/' + _completeFileName)
      .create(recursive: true)
      .then((File file) async {
    //write to file
    Uint8List bytes = await file.readAsBytes();
    file.writeAsBytes(bytes);
    print(file.path);
  });
}

void _createDirectory(String _path) async {
  bool isDirectoryCreated = await Directory(_path).exists();
  if (!isDirectoryCreated) {
    Directory(_path)
        .create()
        // The created directory is returned as a Future.
        .then((Directory directory) {
      print(directory.path);
    });
  }
}

Future<void> record_audio() async {
  final record = Record();
  // Check and request permission
  if (await record.hasPermission()) {
    final directory = await getApplicationDocumentsDirectory();
    String _path = directory.path+'/audio-files/';
    _createDirectory(_path);
    DateTime _now = DateTime.now();
    int millis = _now.millisecondsSinceEpoch;
    String _completeFileName = 'audio_$millis.mp3';
    _createFile(_completeFileName);
    // Start recording
    await record.start(
      path: _path + _completeFileName,
      encoder: AudioEncoder.aacLc, // by default
      bitRate: 128000, // by default
      samplingRate: 44100, // by default
    );
  }

// Get the state of the recorder
  bool isRecording = await record.isRecording();
  print(isRecording);
// Stop recording
  Timer(Duration(seconds: 5),() async {
    await record.stop();
  });
}
