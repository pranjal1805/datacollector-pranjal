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
  ['Idli','Dosa','Poha','Upma','Paratha','Kachori','Kulcha','Appam','Dhokla','Methi paratha','Aloo puri','Samosa','Masala omelette','Sabudana khichdi','Uttapam','Bread pakora','Chole bhature'],
  ['Butter Chicken','Biryani','Rice','Sambar','Puri Bhaji','Baingan Bharta','Fish Curry','Pork','Aloo Paratha','Paneer Tikka','Vegetable Pulao','Rogan Josh','Chana Masala','Palak Paneer','Paneer','Tandoori Chicken', 'Dal Makhani','Chicken Tikka Masala'],
  ['Chicken','Fish','Biryani','Paneer','Veggies','Salad','Malai kofta','Kadi','Naan','Sambar','Aloo Paratha', 'Manchurian','Noodles','Pizza','Burger','Sabudana wada','Kulche'],
  ['Samosa','Pakora','Vada Pav','Paani Puri','Aloo tikki','Dhokla','Samosa Chaat','Chana Chaat','Momos','Honey Chilly Potato','Burger','Pizza','Kachori','Bhel Puri','Bakery','Chips','Namkeen']
];
List<String> dropdownValue =[];
class NewFoodTrackerScreen extends StatefulWidget {
  @override
  State<NewFoodTrackerScreen> createState() => _NewFoodTrackerScreenState();
}

class _NewFoodTrackerScreenState extends State<NewFoodTrackerScreen> {
  List<String> timeIntervalList = ["Breakfast", "Lunch", "Dinner", "Snacks"];
  int _itemCount = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
    );
  }
}
