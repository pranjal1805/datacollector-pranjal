import 'dart:async';

import 'package:datacollector/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data.containsKey('data')) {
    // Handle data message
    final data = message.data['data'];
  }

  if (message.data.containsKey('notification')) {
    // Handle notification message
    final notification = message.data['notification'];
  }
  // Or do other work.
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final streamCtlr = StreamController<String>.broadcast();
  final titleCtlr = StreamController<String>.broadcast();
  final bodyCtlr = StreamController<String>.broadcast();

  setNotifications(BuildContext context) {
    try {
      FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
      FirebaseMessaging.onMessage.listen(
        (message) async {
          if (message.data.containsKey('data')) {
            // Handle data message
            streamCtlr.sink.add(message.data['data']);
          }
          if (message.data.containsKey('notification')) {
            // Handle notification message
            streamCtlr.sink.add(message.data['notification']);
          }
          // Or do other work.
          titleCtlr.sink.add(message.notification!.title!);
          bodyCtlr.sink.add(message.notification!.body!);
        },
      );

      FirebaseMessaging.onMessageOpenedApp.listen((event) => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          ));
      // With this token you can test it easily on your phone
      final token =
          _firebaseMessaging.getToken().then((value) => print('Token: $value'));
    } catch (e) {
      print(e);
    }
  }

  dispose() {
    streamCtlr.close();
    bodyCtlr.close();
    titleCtlr.close();
  }
}
