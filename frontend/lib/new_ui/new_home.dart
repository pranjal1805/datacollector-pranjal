import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:datacollector/new_ui/new_dashboardScreen.dart';
import 'package:datacollector/new_ui/new_foodtracker.dart';
import 'package:datacollector/screens/devices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'new_reminders.dart';


class NewHome extends StatefulWidget {
  const NewHome({Key? key}) : super(key: key);

  @override
  _NewHomeState createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;

  int _currentIndex = 0;

  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  //Logging food added temporarily
  //replace with devices screen
  final tabs = [
    NewDashboardScreen(),
    NewFoodTrackerScreen(),
    NewRemindersScreen(),
    DevicesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
         ..scale(scaleFactor)
         ..rotateY(isDrawerOpen ? -0.5 : 0),
      duration: Duration(milliseconds: 250),
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(isDrawerOpen?40:0.0)

      ),
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isDrawerOpen
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              xOffset = 0;
                              yOffset = 0;
                              scaleFactor = 1;
                              isDrawerOpen = false;
                            });
                          },
                          icon: Icon(Icons.arrow_back_ios))
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              xOffset = 230;
                              yOffset = 150;
                              scaleFactor = 0.6;
                              isDrawerOpen = true;
                            });
                          },
                          icon: Icon(Icons.menu)),
                  Text('Data Collector'),
                  CircleAvatar()
                ],
              ),
            ),
            Container(
              child: tabs[_currentIndex],
            )
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: _currentIndex,
          items: <Widget>[
            Icon(Icons.home_rounded, size: 30, color: Colors.white,),
            Icon(Icons.note_add, size: 30, color: Colors.white),
            Icon(Icons.access_time_outlined, size: 30, color: Colors.white),
            Icon(Icons.watch_outlined, size: 30, color: Colors.white),
          ],
          color: Colors.black87,
          buttonBackgroundColor: Colors.blue,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 300),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          letIndexChange: (index) => true,
        ),
      ),
    );
    //ADD FAB HERE
  }
}
