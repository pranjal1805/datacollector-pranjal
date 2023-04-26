import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoggingFoodWidget extends StatefulWidget {
  const LoggingFoodWidget({Key? key}) : super(key: key);

  @override
  _LoggingFoodWidgetState createState() => _LoggingFoodWidgetState();
}

class _LoggingFoodWidgetState extends State<LoggingFoodWidget> {
  late TextEditingController textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Add Items'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(40, 20, 40, 20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: textController,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.blueGrey),
                        hintText: 'Search',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24.0))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24.0))),
                      ),
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    width: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(8), // Border width
                    decoration: BoxDecoration(
                        color: Colors.blue, shape: BoxShape.circle),
                    child: ClipOval(
                      child: SizedBox.fromSize(
                        size: Size.fromRadius(12), // Image radius
                        child: Icon(
                          Icons.mic,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
              child: Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
                children: <Widget>[
                  _buildChip('Wheat', Color(Colors.blue.hashCode)),
                  _buildChip('Butter', Color(Colors.blue.hashCode)),
                  _buildChip('Naan', Color(Colors.blue.hashCode)),
                  _buildChip('Tandoori', Color(Colors.blue.hashCode)),
                  _buildChip('Bread', Color(Colors.blue.hashCode)),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Color(0xFFF5F5F5),
                  child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Text('Item');
                      }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildChip(String label, Color color) {
  return Chip(
    labelPadding: EdgeInsets.all(2.0),
    avatar: CircleAvatar(
      backgroundColor: Colors.white,
      child: Text(label[0].toUpperCase()),
    ),
    label: Text(
      label,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.blue,
    elevation: 6.0,
    shadowColor: Colors.grey[60],
    padding: EdgeInsets.all(8.0),
  );
}
