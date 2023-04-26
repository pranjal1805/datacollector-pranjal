import 'package:datacollector/screens/addActivity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityTrackerWidget extends StatefulWidget {
  const ActivityTrackerWidget({Key? key, String? activity}) : super(key: key);

  @override
  _ActivityTrackerWidgetState createState() => _ActivityTrackerWidgetState();
}

class _ActivityTrackerWidgetState extends State<ActivityTrackerWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> activitiesList = ["Steps", "Cycling", "Dancing"];
  List<String> caloriesList = ["200 cal", "300 cal", "250 cal"];

  @override
  Widget build(BuildContext context) {

    var receivedActivity = ModalRoute.of(context)!.settings.arguments.toString();
    print(receivedActivity);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Activity Tracker'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 50, 0),
              child: Text(
                '750',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
              child: Text(
                'Calories burned',
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 50, 0, 0),
              child: Text(
                'Activity/Exercise Tracked',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
              child: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                ),
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Wrap(
                    children: [
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: activitiesList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(activitiesList[index],
                                      style: TextStyle(fontSize: 16)),
                                  Text(caloriesList[index],
                                      style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            );
                          }),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AddActivityWidget()),
                              );

                            }, child: Text('Add Activity', style: TextStyle(fontSize :16)),
                          ),
                          Icon(
                            Icons.add_circle_sharp,
                            color: Colors.black,
                            size: 24,
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 60),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'Suggested : Running(from tracker)', style: TextStyle(fontSize :16),
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
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
