import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';
String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}
class NewRemindersScreen extends StatefulWidget {
  @override
  _NewRemindersScreenState createState() => _NewRemindersScreenState();
  //State<NewRemindersScreen> createState() => _NewRemindersScreenState();
}
//
//
//
// class PedometerScreen extends StatefulWidget {
//   @override
//   _PedometerScreenState createState() => _PedometerScreenState();
// }

class _NewRemindersScreenState extends State<NewRemindersScreen> {
  String _stepCount = '0';
  late Stream<StepCount> _stepCountStream;
  Pedometer _pedometer = Pedometer();

  @override
  void initState() {
    super.initState();
    startListening();
  }

  void startListening() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen((stepCount) {
      setState(() {
        _stepCount = stepCount.steps.toString();
      });
    });
  }

  @override
  // void dispose() {
  //   _pedometer.stopListening();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pedometer'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Step Count:',
                style: TextStyle(fontSize: 24),
              ),
              Text(
                _stepCount,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
*


class _PedometerScreenState extends State<PedometerScreen>  {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pedometer example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Steps taken:',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                _steps,
                style: TextStyle(fontSize: 60),
              ),
              SizedBox(
                height: 100, // Set a defined height value
              ),
              Text(
                'Pedestrian status:',
                style: TextStyle(fontSize: 30),
              ),
              Icon(
                _status == 'walking'
                    ? Icons.directions_walk
                    : _status == 'stopped'
                    ? Icons.accessibility_new
                    : Icons.error,
                size: 100,
              ),
              Center(
                child: Text(
                  _status,
                  style: _status == 'walking' || _status == 'stopped'
                      ? TextStyle(fontSize: 30)
                      : TextStyle(fontSize: 20, color: Colors.red),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

* */