import 'dart:io';

import 'package:datacollector/models/sensor_model.dart';
import 'package:datacollector/screens/dashboard.dart';
import 'package:datacollector/screens/dashboard_new.dart';
import 'package:datacollector/screens/food_tracker.dart';
import 'package:datacollector/screens/login.dart';
import 'package:datacollector/screens/profile.dart';
import 'package:datacollector/screens/reminders.dart';
import 'package:datacollector/screens/devices.dart';
import 'package:datacollector/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'achievements.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _MyAppState();

}

class _MyAppState extends State<HomeScreen> {
  int _currentIndex = 0;

  //Logging food added temporarily
  //replace with devices screen
  final tabs = [
    HomePageWidget(), TrackerScreen(), ListViewHomeLayout(), DevicesScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      //change main theme here
      theme: ThemeData(fontFamily: 'Cairo', brightness: Brightness.light),
      routes: {
        '/settings': (context) => SettingsScreen(),
        '/profile' : (context) => ProfileScreen(),
        '/login' : (context) => LoginScreen(),
        '/home' : (context) => HomePageWidget(),
      },
      home: Scaffold(
        appBar: AppBar(
          title: Text('Data Collector'),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AchievementsScreen()),
                    );
                  },
                  child: Icon(
                    Icons.emoji_events_rounded,
                    size: 26.0,
                  ),
                )
            ),
          ],
        ),
        body: tabs[_currentIndex],
        drawer: NavigationDrawer(
          children:[

          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.note_add),
              label: 'Tracker',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.doorbell),
              label: 'Reminder',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.watch),
              label: 'Devices',
            ),
          ],
          selectedItemColor: Colors.white,
          onTap: (index){
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}