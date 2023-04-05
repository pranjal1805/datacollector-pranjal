import 'dart:convert';

import 'package:datacollector/models/sensor_model.dart';
import 'package:datacollector/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {


  final url = "https://jsonplaceholder.typicode.com/posts";

  var _postsJson = [];

  void postReq() async {
    try {
      final response = await post(Uri.parse(url), body: {
        "userId": "100",
        "title": "title",
        "body": "bodyyyy"
      });
      print(response.body);
    }
    catch (err) {
      print(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(onPressed: postReq,
          child: Text('Send Req'),)
        ),
      ),
    );
  }
}


// import 'dart:convert';
//
// import 'package:datacollector/models/sensor_model.dart';
// import 'package:datacollector/widgets/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart';
//
// class DashboardScreen extends StatefulWidget {
//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen> {
//
//
//   final url = "https://jsonplaceholder.typicode.com/posts";
//
//   var _postsJson = [];
//   void fetchReq() async{
//     try{
//       final response =  await get(Uri.parse(url));
//       final jsonData = jsonDecode(response.body) as List;
//
//       setState(() {
//         _postsJson = jsonData;
//       });
//
//       print(response.statusCode);
//     }
//     catch(err){
//       print(err.toString());
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     fetchReq();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: ListView.builder(itemCount : _postsJson.length,itemBuilder: (context, i){
//
//             final post = _postsJson[i];
//             return Text("Title : ${post["title"]}\n Body: ${post["body"]} \n\n");
//
//           }),
//         ),
//       ),
//     );
//   }
// }
