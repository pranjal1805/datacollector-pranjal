import 'package:datacollector/models/sensor_model.dart';
import 'package:datacollector/new_ui/new_home.dart';
import 'package:datacollector/screens/home.dart';
import 'package:datacollector/screens/settings.dart';
import 'package:datacollector/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../new_ui/new_main.dart';

////Pressing back gets back to login screen

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: SafeArea(
              child: Column(
            children: [
              SizedBox(
                height: 100,
                child: Center(
                  child: Text(
                    "Multi-Modal Data Collector",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {},
                child: Text('Login'),
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewHomeScreen()));
                },
                child: Text('SKIP'),
              )
            ],
          )),
        ),
      ),
    );
  }
}
