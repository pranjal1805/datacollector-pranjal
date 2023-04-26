import 'package:datacollector/models/sensor_model.dart';
import 'package:datacollector/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AchievementsScreen extends StatefulWidget {
  AchievementsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<AchievementsScreen> {
  List<String> titles = ["Friend 1", "Friend 2", "Friend 3"];
  final subtitles = [
    "Here is list 1 subtitle",
    "Here is list 2 subtitle",
    "Here is list 3 subtitle"
  ];
  final icons = [Icons.ac_unit, Icons.access_alarm, Icons.access_time];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Achievements'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(40, 20, 40, 20),
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Color(0xFFF5F5F5),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 75,
                        height: 75,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.face,
                          size: 75,
                          color: Colors.blueGrey,
                        ),
                      ),
                      Text(
                        '<text>',
                      )
                    ],
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Share achievement with friends'),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                child: ListView.builder(
                    itemCount: titles.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: ListTile(
                              onTap: () {
                                setState(() {
                                  titles.add('Friend ' +
                                      (titles.length + 1).toString());
                                  subtitles.add('Here is list ' +
                                      (titles.length).toString() +
                                      ' subtitle');
                                  icons.add(Icons.zoom_out_sharp);
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(titles[index] + ' pressed!'),
                                ));
                              },
                              title: Text(titles[index]),
                              subtitle: Text(subtitles[index]),
                              leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://images.unsplash.com/photo-1547721064-da6cfb341d50")),
                              trailing: Icon(icons[index])));
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
