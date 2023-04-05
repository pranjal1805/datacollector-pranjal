import 'package:datacollector/screens/activityTracker.dart';
import 'package:datacollector/screens/loggingFood.dart';
import 'package:datacollector/widgets/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:drop_down_list/drop_down_list.dart';
// import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

List<List<String>> items = [
  ['Hostel','SAC','Laundromat','B-Dome','NAB','D Side','Guest House','Faculty Chambers','A-Mess','C-Mess','Institute Cafetaria'],
  ['Happy', 'Stressed', 'Relaxed','Sad','No Response'],
];
List<String> dropdownValue =[];
class LocationScreen extends StatefulWidget {
  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  List<String> timeIntervalList = ["Location", "Emotion"];
  int _itemCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location Screen"),
      ),
      body: SafeArea(
      child: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: timeIntervalList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(15),
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3.0,
                        spreadRadius: 0.0,
                        offset:
                        Offset(2.0, 2.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: Column(
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
                              Icons.edit_rounded,
                              color: Colors.grey,
                              size: 24,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 0, 10, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                                width: 225,
                                height:75,
                                child:   SearchableDropdown<String>(
                                  hintText: const Text('List of items'),
                                  margin: const EdgeInsets.all(15),
                                  items: items[index].map((item) =>
                                      SearchableDropdownMenuItem(
                                        value: item,
                                        child: Text(item), label: '$item',
                                      ),
                                  ).toList(),

                                )
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),
        ],
      ),
    ),
    );
  }
}
