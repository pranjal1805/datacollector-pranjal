import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  Future<bool> findFile(String fileName) async{
    final path = await _localPath;
    return await File('$path/$fileName').exists();
  }
  Future<String> readFile(String fileName) async {
    try {
      final file = await _localFile(fileName);

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "0";
    }
  }

  Future<File> writeFile(String data, String fileName) async {
    final file = await _localFile(fileName);
    final path = await _localPath;
    print("writing to file $path/$fileName");
    // Write the file
    return file.writeAsString(data);
  }
}