import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GoalsScreen extends StatefulWidget{
  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Set Goals'),
        ),
        backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current goal :'),
              Text('Daily calorie count :')
            ],
          ),
        ),
      ),

    );
  }
}