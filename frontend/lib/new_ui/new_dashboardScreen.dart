import 'package:camera/camera.dart';
import 'package:datacollector/widgets/config.dart';
import 'package:datacollector/widgets/audio_recorder.dart';
import 'package:datacollector/widgets/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:async';
import 'package:datacollector/chart.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:datacollector/accelerometer_data.dart';
import 'package:datacollector/gyroscope_data.dart';
import '../line_chart.dart';



class NewDashboardScreen extends StatefulWidget {
  @override
  State<NewDashboardScreen> createState() => _NewDashboardScreenState();
}

class _NewDashboardScreenState extends State<NewDashboardScreen> {

  static const platform = MethodChannel('android/bluetooth');
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
    return Expanded(
        child: SingleChildScrollView(
      child: Column(
        children: [
           Row(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Container(
            margin: EdgeInsets.only(left: 100,top:10),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:  BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000000).withOpacity(0.05),
                    offset: const Offset(0,9),
                    blurRadius: 30,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                      color: const Color(0xFF4f4f4f).withOpacity(0.03),
                      offset: const Offset(0, 2),
                      blurRadius: 10,
                      spreadRadius: 0
                  )
                ]),
            child: IconButton(
              icon: const Icon(Icons.mic),
              tooltip: 'Record Audio',
              onPressed: () {
                record_audio();
              },
            )
          ),
          Container(
              margin: EdgeInsets.only(left: 20,top:10),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:  BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.05),
                      offset: const Offset(0,9),
                      blurRadius: 30,
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                        color: const Color(0xFF4f4f4f).withOpacity(0.03),
                        offset: const Offset(0, 2),
                        blurRadius: 10,
                        spreadRadius: 0
                    )
                  ]),
              child: IconButton(
                icon: const Icon(Icons.camera),
                tooltip: 'Record Audio',
                onPressed: () async {
                  // await availableCameras().then(
                  //       (value) => Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => CameraPage(cameras: value,),
                  //     ),
                  //   ),
                  // );
                  camerasrun();
                },
              )
          ),
      ]
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:  BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withOpacity(0.05),
                  offset: const Offset(0,9),
                  blurRadius: 30,
                  spreadRadius: 0,
                ),
                BoxShadow(
                    color: const Color(0xFF4f4f4f).withOpacity(0.03),
                    offset: const Offset(0, 2),
                    blurRadius: 10,
                    spreadRadius: 0
                )
              ]),

            child: CircularPercentIndicator(
              animation: true,
              animationDuration: 800,
              radius: 120.0,
              lineWidth: 15.0,
              percent: 0.8,
              center: new Text("800", style: TextStyle(fontWeight: FontWeight.bold),),
              progressColor: Colors.blue,
              circularStrokeCap: CircularStrokeCap.round,
            ),
          ),
          ElevatedButton(
            child: const Text("Start"),
            onPressed: () {
              if(backAndForth % 2 == 1){
                _accelerometerData.clear();
                _gyroscopeData.clear();
              }
              // start a stream that saves acceleroemeterData
              _streamSubscriptions.add(
                  accelerometerEvents.listen((AccelerometerEvent event) {
                    _accelerometerData.add(AccelerometerData(DateTime.now(), <double>[event.x, event.y, event.z]));
                  })
              );
              // start a stream that saves gyroscopeData
              _streamSubscriptions.add(
                  gyroscopeEvents.listen((GyroscopeEvent event) {
                    _gyroscopeData.add(GyroscopeData(DateTime.now(), <double>[event.x, event.y, event.z]));
                  })
              );
              backAndForth++;
            },
          ),
          ElevatedButton(
            child: const Text("Stop"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              print("length: ${_accelerometerData.length}");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChartScreen(accelerometerData: _accelerometerData, gyroscopeData: _gyroscopeData)),
              );
            },
          ),
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:  BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000000).withOpacity(0.05),
                    offset: const Offset(0,9),
                    blurRadius: 30,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                      color: const Color(0xFF4f4f4f).withOpacity(0.03),
                      offset: const Offset(0, 2),
                      blurRadius: 10,
                      spreadRadius: 0
                  )
                ]),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 50,
                      height: 125,
                      child: new CircularPercentIndicator(
                        radius: 45.0,
                        animation: true,
                        animationDuration: 800,
                        lineWidth: 8.0,
                        percent: 0.4,
                        circularStrokeCap: CircularStrokeCap.butt,
                        progressColor: Colors.black,
                      ),
                    ),
                    Text(
                      'Carbs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 50,
                      height: 125,
                      child: new CircularPercentIndicator(
                        radius: 45.0,
                        animation: true,
                        animationDuration: 800,
                        lineWidth: 8.0,
                        percent: 0.8,
                        circularStrokeCap: CircularStrokeCap.butt,
                        progressColor: Colors.black,
                      ),
                    ),
                    Text(
                      'Proteins', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                    )
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 50,
                      height: 125,
                      child: new CircularPercentIndicator(
                        radius: 45.0,
                        animation: true,
                        animationDuration: 800,
                        lineWidth: 8.0,
                        percent: 0.6,
                        circularStrokeCap: CircularStrokeCap.butt,
                        progressColor: Colors.black,
                      ),
                    ),
                    Text(
                      'Fats', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 20, 10, 20),
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
    );
  }
  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }
  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      accelerometerEvents.listen(
            (AccelerometerEvent event) {
          setState(() {
            _accelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEvents.listen(
            (GyroscopeEvent event) {
          setState(() {
            _gyroscopeValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      userAccelerometerEvents.listen(
            (UserAccelerometerEvent event) {
          setState(() {
            _userAccelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      magnetometerEvents.listen(
            (MagnetometerEvent event) {
          setState(() {
            _magnetometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
  }
}

