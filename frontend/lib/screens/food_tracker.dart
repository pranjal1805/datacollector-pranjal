import 'package:datacollector/screens/activityTracker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

import 'loggingFood.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({Key? key}) : super(key: key);

  @override
  _TrackerPageWidgetState createState() => _TrackerPageWidgetState();
}

class _TrackerPageWidgetState extends State<TrackerScreen> {
  List<String> timeIntervalList = ["Breakfast", "Lunch", "Dinner", "Snacks"];

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late int countControllerValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFF5F5F5),
        body: SafeArea(
            child: Column(
          children: [
            Container(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: timeIntervalList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                timeIntervalList[index],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Icon(
                                Icons.edit,
                                color: Colors.blueGrey,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        //   child: Row(
                        //     mainAxisSize: MainAxisSize.max,
                        //     children: [
                        //       Text(
                        //         '',
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 10, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LoggingFoodWidget()),
                                  );
                                },
                                child: Text('Add Item'),
                              ),
                              Icon(
                                Icons.add_circle_sharp,
                                color: Colors.black,
                                size: 24,
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  }),
            ),
            //water intake
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Water Intake',
                      ),
                      Container(
                        width: 100,
                        child: NumberInputWithIncrementDecrement(
                          min: 0,
                          max: 10, controller: TextEditingController(),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            //activity tracker
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Activity Tracker',
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ActivityTrackerWidget()),
                            );
                          },
                          icon: Icon(
                            Icons.directions_run,
                            color: Colors.black,
                            size: 50,
                          ))
                    ],
                  ),
                )
              ],
            ),
            Container(
              height: 20,
            ),
          ],
        )
        )
    );
  }
}
