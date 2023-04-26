import 'dart:async';

import 'package:datacollector/line_chart.dart';
import 'package:datacollector/chart.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:datacollector/accelerometer_data.dart';
import 'package:datacollector/gyroscope_data.dart';
import 'package:datacollector/screens/goals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

import 'addActivity.dart';
import 'loggingFood.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<double>? _accelerometerValues;
  List<double>? _userAccelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  List<AccelerometerData> _accelerometerData = [];
  List<GyroscopeData> _gyroscopeData = [];

  int backAndForth = 0;
  @override
  Widget build(BuildContext context) {
    final accelerometer =
    _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final gyroscope =
    _gyroscopeValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        .toList();
    final magnetometer =
    _magnetometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFF5F5F5),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 1),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      child: CircularPercentIndicator(
                        animation: true,
                        animationDuration: 1200,
                        radius: 120.0,
                        lineWidth: 15.0,
                        percent: 0.8,
                        center: new Text("800"),
                        progressColor: Colors.green,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 50, 10, 1),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          child: new CircularPercentIndicator(
                            radius: 50.0,
                            animation: true,
                            animationDuration: 1200,
                            lineWidth: 5.0,
                            percent: 0.4,
                            circularStrokeCap: CircularStrokeCap.butt,
                            backgroundColor: Colors.yellow,
                            progressColor: Colors.red,
                          ),
                        ),
                        Text(
                          'Carbs',
                        )
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          child: new CircularPercentIndicator(
                            radius: 50.0,
                            animation: true,
                            animationDuration: 1200,
                            lineWidth: 5.0,
                            percent: 0.8,
                            circularStrokeCap: CircularStrokeCap.butt,
                            backgroundColor: Colors.yellow,
                            progressColor: Colors.red,
                          ),
                        ),
                        Text(
                          'Proteins',
                        )
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          child: new CircularPercentIndicator(
                            radius: 50.0,
                            animation: true,
                            animationDuration: 1200,
                            lineWidth: 5.0,
                            percent: 0.6,
                            circularStrokeCap: CircularStrokeCap.butt,
                            backgroundColor: Colors.yellow,
                            progressColor: Colors.red,
                          ),
                        ),
                        Text(
                          'Fats',
                        )
                      ],
                    )
                  ],
                ),
              ),
              Divider(
                height: 20,
                thickness: 5,
                indent: 20,
                endIndent: 20,
                color: CupertinoColors.black,
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 1),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        width: 300,
                        height: 200,
                        child: PointsLineChart.withSampleData()),
                  ],
                ),
              )
            ],
          ),
        ),
        floatingActionButton: SpeedDial(
          child: const Icon(Icons.add),
          speedDialChildren: <SpeedDialChild>[
            SpeedDialChild(
              child: const Icon(Icons.directions_run),
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              label: 'Add Activity',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AddActivityWidget(),
                ),);
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.arrow_forward_rounded),
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              label: 'Set Goals',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => GoalsScreen(),
                ),);
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.set_meal),
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              label: 'Add Meal',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => LoggingFoodWidget(),
                ),);
              },
            ),
          ],
          closedForegroundColor: Colors.white,
          openForegroundColor: Colors.blue,
          closedBackgroundColor: Colors.blue,
          openBackgroundColor: Colors.white,
        ),
    );
  }
}
