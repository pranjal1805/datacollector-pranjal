import 'package:datacollector/screens/activityTracker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddActivityWidget extends StatefulWidget {
  const AddActivityWidget({Key? key}) : super(key: key);

  @override
  _AddActivityWidgetState createState() => _AddActivityWidgetState();
}

class _AddActivityWidgetState extends State<AddActivityWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String dropDownActivity = "Aerobic";
  String dropDownUnit = "mins";

  var categoriesList = ['Aerobic', 'Balance', 'Flexibility', 'Strength'];
  var unitsList = ['mins', 'hours'];

  var activitiesList = ['Dancing', 'Running', 'Jogging', 'Walking', 'Jumping'];

  var selectedActivity = 'Jogging';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Activity Tracker'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Category',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: dropDownActivity,
                    items: categoriesList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropDownActivity = newValue!;
                      });
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedActivity,
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        width: 32,
                        child: TextField(
                          style: TextStyle(fontSize: 16),
                          maxLength: 2,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      DropdownButton<String>(
                        value: dropDownUnit,
                        items: unitsList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropDownUnit = newValue!;
                          });
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton.extended(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ActivityTrackerWidget(activity: selectedActivity),
                    //   ),
                    // );
                  }, label: Text('Add'), icon: Icon(Icons.add)),
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: activitiesList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                        child: Text(activitiesList[index],
                            style: TextStyle(fontSize: 16)),
                        onTap: (){
                          setState(() {
                            selectedActivity = activitiesList[index];
                          });
                        },
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
