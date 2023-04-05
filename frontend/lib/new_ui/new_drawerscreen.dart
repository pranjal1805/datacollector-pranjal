import 'package:datacollector/widgets/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

class NewDrawerScreen extends StatefulWidget {
  const NewDrawerScreen({Key? key}) : super(key: key);

  @override
  _NewDrawerScreenState createState() => _NewDrawerScreenState();
}

class _NewDrawerScreenState extends State<NewDrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryGreen,
      padding: EdgeInsets.only(top: 50, left: 10, bottom: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('User Name',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(
                    'User status',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              )
            ],
          ),
          Column(
            children: drawerItems
                .map((e) => Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(e['title'] + ' pressed'),
                          ));
                          if (e['title'] == 'Tracker') {
                            Navigator.pushNamed(context, '/settings');
                          }
                          else if (e['title'] == 'Models') {
                            Navigator.pushNamed(context, '/models');
                          }
                          else if (e['title'] == 'Location and Emotion') {
                            Navigator.pushNamed(context, '/location');
                          }
                        },
                        child: Container(
                          child: Row(
                            children: [
                              Icon(
                                e['icon'],
                                color: Colors.white,
                                size: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                e['title'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          Row(
            children: [
              Icon(
                Icons.settings_outlined,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text('Settings',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 2,
                height: 20,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text('Logout',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}
