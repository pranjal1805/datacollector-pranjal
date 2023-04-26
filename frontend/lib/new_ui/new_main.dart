import 'package:flutter/material.dart';

import 'new_home.dart';
import 'new_drawerscreen.dart';

class NewHomeScreen extends StatefulWidget {

  @override
  State<NewHomeScreen> createState() => _MyAppState();

}

class _MyAppState extends State<NewHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NewDrawerScreen(),
          NewHome()
        ],
      ),

    );
  }
}