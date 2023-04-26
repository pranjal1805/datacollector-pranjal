// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// //
// // class ReminderScreen extends StatefulWidget {
// //   const ReminderScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   _RemindersWidgetState createState() => _RemindersWidgetState();
// // }
// //
// // class _RemindersWidgetState extends State<ReminderScreen> {
// //   bool switchListTileValue1 = true;
// //   bool switchListTileValue2 = false;
// //   bool switchListTileValue3 = true;
// //   bool switchListTileValue4 = true;
// //   final scaffoldKey = GlobalKey<ScaffoldState>();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       key: scaffoldKey,
// //       backgroundColor: Color(0xFFF5F5F5),
// //       body: SafeArea(
// //         child: Column(
// //           mainAxisSize: MainAxisSize.max,
// //           crossAxisAlignment: CrossAxisAlignment.end,
// //           children: [
// //             Padding(
// //               padding: EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
// //               child: Icon(
// //                 Icons.add_box,
// //                 color: Colors.black,
// //                 size: 30,
// //               ),
// //             ),
// //             Padding(
// //               padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
// //               child: SwitchListTile(
// //                 value: switchListTileValue1 ??= true,
// //                 onChanged: (newValue) =>
// //                     setState(() => switchListTileValue1 = newValue),
// //                 title: Text(
// //                   '9.40am',
// //                 ),
// //                 tileColor: Color(0xFF5C5C5C),
// //                 dense: false,
// //                 controlAffinity: ListTileControlAffinity.trailing,
// //               ),
// //             ),
// //             Padding(
// //               padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
// //               child: SwitchListTile(
// //                 value: switchListTileValue2 ??= true,
// //                 onChanged: (newValue) =>
// //                     setState(() => switchListTileValue2 = newValue),
// //                 title: Text(
// //                   '12.00pm',
// //                 ),
// //                 tileColor: Color(0xFF5C5C5C),
// //                 dense: false,
// //                 controlAffinity: ListTileControlAffinity.trailing,
// //               ),
// //             ),
// //             Padding(
// //               padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
// //               child: SwitchListTile(
// //                 value: switchListTileValue3 ??= true,
// //                 onChanged: (newValue) =>
// //                     setState(() => switchListTileValue3 = newValue),
// //                 title: Text(
// //                   '5.00pm',
// //                 ),
// //                 tileColor: Color(0xFF5C5C5C),
// //                 dense: false,
// //                 controlAffinity: ListTileControlAffinity.trailing,
// //               ),
// //             ),
// //             Padding(
// //               padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
// //               child: SwitchListTile(
// //                 value: switchListTileValue4 ??= true,
// //                 onChanged: (newValue) =>
// //                     setState(() => switchListTileValue4 = newValue),
// //                 title: Text(
// //                   '11.15pm',
// //                 ),
// //                 tileColor: Color(0xFF5C5C5C),
// //                 dense: false,
// //                 controlAffinity: ListTileControlAffinity.trailing,
// //               ),
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class ListViewHomeLayout extends StatefulWidget {
// //   @override
// //   ListViewHome createState() {
// //     return new ListViewHome();
// //   }
// // }
// //
// // class ListViewHome extends State<ListViewHomeLayout> {
// //   List<String> titles = ["List 1", "List 2", "List 3"];
// //   final subtitles = [
// //     "Here is list 1 subtitle",
// //     "Here is list 2 subtitle",
// //     "Here is list 3 subtitle"
// //   ];
// //   final icons = [Icons.ac_unit, Icons.access_alarm, Icons.access_time];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return ListView.builder(
// //         itemCount: titles.length,
// //         itemBuilder: (context, index) {
// //           return Card(
// //               child: ListTile(
// //                   onTap: () {
// //                     setState(() {
// //                       titles.add('List' + (titles.length + 1).toString());
// //                       subtitles.add('Here is list' +
// //                           (titles.length + 1).toString() +
// //                           ' subtitle');
// //                       icons.add(Icons.zoom_out_sharp);
// //                     });
// //                     Scaffold.of(context).showSnackBar(SnackBar(
// //                       content: Text(titles[index] + ' pressed!'),
// //                     ));
// //                   },
// //                   title: Text(titles[index]),
// //                   subtitle: Text(subtitles[index]),
// //                   leading: CircleAvatar(
// //                       backgroundImage: NetworkImage(
// //                           "https://images.unsplash.com/photo-1547721064-da6cfb341d50")),
// //                   trailing: Icon(icons[index])));
// //         });
// //   }
// // }
// //
// // class TrackerScreen extends StatefulWidget {
// //   const TrackerScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   _TrackerPageWidgetState createState() => _TrackerPageWidgetState();
// // }
// //
// // class _TrackerPageWidgetState extends State<TrackerScreen> {
// //
// //   List<String> timeIntervalList = ["Breakfast", "Lunch", "Dinner", "Snacks"];
// //
// //
// //   final scaffoldKey = GlobalKey<ScaffoldState>();
// //   late int countControllerValue;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       key: scaffoldKey,
// //       backgroundColor: Color(0xFFF5F5F5),
// //       body: SafeArea(
// //         child: Column(
// //           mainAxisSize: MainAxisSize.max,
// //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //           children: [
// //             Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Padding(
// //                   padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.max,
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     crossAxisAlignment: CrossAxisAlignment.center,
// //                     children: [
// //                       Text(
// //                         'Breakfast',
// //                       ),
// //                       Icon(
// //                         Icons.edit,
// //                         color: Colors.black,
// //                         size: 24,
// //                       )
// //                     ],
// //                   ),
// //                 ),
// //                 Padding(
// //                   padding: EdgeInsetsDirectional.fromSTEB(20, 0, 10, 0),
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.max,
// //                     children: [
// //                       Text(
// //                         'Item - Serving',
// //                       )
// //                     ],
// //                   ),
// //                 ),
// //                 Padding(
// //                   padding: EdgeInsetsDirectional.fromSTEB(20, 0, 10, 0),
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.max,
// //                     children: [
// //                       TextButton(
// //                         onPressed: () {
// //                           Navigator.push(
// //                             context,
// //                             MaterialPageRoute(builder: (context) => LoggingfoodWidget()),
// //                           );
// //                         },
// //                         child: Text('Add Item'),
// //                       ),
// //                       Icon(
// //                         Icons.add_circle_sharp,
// //                         color: Colors.black,
// //                         size: 24,
// //                       )
// //                     ],
// //                   ),
// //                 )
// //               ],
// //             ),
// //             Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Padding(
// //                   padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.max,
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     crossAxisAlignment: CrossAxisAlignment.center,
// //                     children: [
// //                       Text(
// //                         'Lunch',
// //                       ),
// //                       Icon(
// //                         Icons.edit,
// //                         color: Colors.black,
// //                         size: 24,
// //                       )
// //                     ],
// //                   ),
// //                 ),
// //                 Padding(
// //                   padding: EdgeInsetsDirectional.fromSTEB(20, 0, 10, 0),
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.max,
// //                     children: [
// //                       Text(
// //                         'Item - Serving',
// //                       )
// //                     ],
// //                   ),
// //                 ),
// //                 Padding(
// //                   padding: EdgeInsetsDirectional.fromSTEB(20, 0, 10, 0),
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.max,
// //                     children: [
// //                       Text(
// //                         'Add Item',
// //                       ),
// //                       Icon(
// //                         Icons.add_circle_sharp,
// //                         color: Colors.black,
// //                         size: 24,
// //                       )
// //                     ],
// //                   ),
// //                 )
// //               ],
// //             ),
// //             Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Padding(
// //                   padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.max,
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     crossAxisAlignment: CrossAxisAlignment.center,
// //                     children: [
// //                       Text(
// //                         'Dinner',
// //                       ),
// //                       Icon(
// //                         Icons.edit,
// //                         color: Colors.black,
// //                         size: 24,
// //                       )
// //                     ],
// //                   ),
// //                 ),
// //                 Padding(
// //                   padding: EdgeInsetsDirectional.fromSTEB(20, 0, 10, 0),
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.max,
// //                     children: [
// //                       Text(
// //                         'Item - Serving',
// //                       )
// //                     ],
// //                   ),
// //                 ),
// //                 Padding(
// //                   padding: EdgeInsetsDirectional.fromSTEB(20, 0, 10, 0),
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.max,
// //                     children: [
// //                       Text(
// //                         'Add Item',
// //                       ),
// //                       Icon(
// //                         Icons.add_circle_sharp,
// //                         color: Colors.black,
// //                         size: 24,
// //                       )
// //                     ],
// //                   ),
// //                 )
// //               ],
// //             ),
// //             Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Padding(
// //                   padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.max,
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     crossAxisAlignment: CrossAxisAlignment.center,
// //                     children: [
// //                       Text(
// //                         'Snacks',
// //                       ),
// //                       Icon(
// //                         Icons.edit,
// //                         color: Colors.black,
// //                         size: 24,
// //                       )
// //                     ],
// //                   ),
// //                 ),
// //                 Padding(
// //                   padding: EdgeInsetsDirectional.fromSTEB(20, 0, 10, 0),
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.max,
// //                     children: [
// //                       Text(
// //                         'Item - Serving',
// //                       )
// //                     ],
// //                   ),
// //                 ),
// //                 Padding(
// //                   padding: EdgeInsetsDirectional.fromSTEB(20, 0, 10, 0),
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.max,
// //                     children: [
// //                       Text(
// //                         'Add Item',
// //                       ),
// //                       Icon(
// //                         Icons.add_circle_sharp,
// //                         color: Colors.black,
// //                         size: 24,
// //                       )
// //                     ],
// //                   ),
// //                 )
// //               ],
// //             ),
// //             Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Padding(
// //                   padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.max,
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     crossAxisAlignment: CrossAxisAlignment.center,
// //                     children: [
// //                       Text(
// //                         'Water Intake',
// //                       ),
// //                       Container(
// //                         width: 80,
// //                         height: 25,
// //                         decoration: BoxDecoration(
// //                           color: Colors.white,
// //                           borderRadius: BorderRadius.circular(25),
// //                           shape: BoxShape.rectangle,
// //                           border: Border.all(
// //                             color: Color(0xFF9E9E9E),
// //                             width: 1,
// //                           ),
// //                         ),
// //                       )
// //                     ],
// //                   ),
// //                 )
// //               ],
// //             ),
// //             Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Padding(
// //                   padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.max,
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     crossAxisAlignment: CrossAxisAlignment.center,
// //                     children: [
// //                       Text(
// //                         'Activity Tracker',
// //                       ),
// //                       IconButton(onPressed: (){
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(builder: (context) => const ActivityTrackerWidget()),
// //                         );
// //                       }, icon:Icon(
// //                         Icons.directions_run,
// //                         color: Colors.black,
// //                         size: 50,
// //                       )
// //                       )
// //                     ],
// //                   ),
// //                 )
// //               ],
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class LoggingFoodWidget extends StatefulWidget {
//   const LoggingFoodWidget({Key? key}) : super(key: key);
//
//   @override
//   _LoggingFoodWidgetState createState() => _LoggingFoodWidgetState();
// }
//
// class _LoggingFoodWidgetState extends State<LoggingFoodWidget> {
//   late TextEditingController textController;
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   void initState() {
//     super.initState();
//     textController = TextEditingController();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       backgroundColor: Color(0xFFF5F5F5),
//       appBar: AppBar(
//         title: Text('Add Items'),
//       ),
//       body: SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Padding(
//               padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
//               child: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: textController,
//                       obscureText: false,
//                       decoration: InputDecoration(
//                         hintText: 'Search',
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: Colors.black,
//                             width: 1,
//                           ),
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(4.0),
//                             topRight: Radius.circular(4.0),
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: Colors.black,
//                             width: 1,
//                           ),
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(4.0),
//                             topRight: Radius.circular(4.0),
//                           ),
//                         ),
//                       ),
//                       maxLines: 1,
//                     ),
//                   ),
//                   Icon(
//                     Icons.mic,
//                     color: Colors.black,
//                     size: 24,
//                   )
//                 ],
//               ),
//             ),
//             Padding(
//               padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     width: 100,
//                     height: 100,
//                     decoration: BoxDecoration(
//                       color: Color(0xFFEEEEEE),
//                     ),
//                     child: Text(
//                       'Add Radio Tiles here',
//                       textAlign: TextAlign.center,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Padding(
//               padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 1),
//               child: Card(
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 color: Color(0xFFF5F5F5),
//                 child: ListView(
//                   padding: EdgeInsets.zero,
//                   shrinkWrap: true,
//                   scrollDirection: Axis.vertical,
//                   children: [
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(3, 3, 3, 3),
//                       child: Text(
//                         'Item Name',
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(3, 3, 3, 3),
//                       child: Text(
//                         'Item Name',
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(3, 3, 3, 3),
//                       child: Text(
//                         'Item Name',
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(3, 3, 3, 3),
//                       child: Text(
//                         'Item Name',
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(3, 3, 3, 3),
//                       child: Text(
//                         'Item Name',
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(3, 3, 3, 3),
//                       child: Text(
//                         'Item Name',
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(3, 3, 3, 3),
//                       child: Text(
//                         'Item Name',
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(3, 3, 3, 3),
//                       child: Text(
//                         'Item Name',
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(3, 3, 3, 3),
//                       child: Text(
//                         'Item Name',
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//

import 'package:datacollector/screens/addActivity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityTrackerWidget extends StatefulWidget {
  const ActivityTrackerWidget({Key? key}) : super(key: key);

  @override
  _ActivityTrackerWidgetState createState() => _ActivityTrackerWidgetState();
}

class _ActivityTrackerWidgetState extends State<ActivityTrackerWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 50, 0),
              child: Text(
                '750', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
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
                'Activity/Exercise Tracked',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 1),
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Color(0xFFF5F5F5),
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(3, 3, 3, 3),
                      child: Text(
                        'Item Name',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(3, 3, 3, 3),
                      child: Text(
                        'Item Name',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(3, 3, 3, 3),
                      child: Text(
                        'Item Name',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(3, 3, 3, 3),
                      child: Text(
                        'Item Name',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(3, 3, 3, 3),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          TextButton(
                            onPressed: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AddActivityWidget()),
                              );

                            }, child: Text('Add Activity'),
                          ),
                          Icon(
                            Icons.add_circle_sharp,
                            color: Colors.black,
                            size: 24,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(3, 30, 3, 30),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Suggested : Running(from tracker)',
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
            )
          ],
        ),
      ),
    );
  }
}

