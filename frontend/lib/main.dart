import 'package:cron/cron.dart';
import 'package:datacollector/models/sensor_model.dart';
import 'package:datacollector/new_ui/new_main.dart';
import 'package:datacollector/screens/dashboard_new.dart';
import 'package:datacollector/screens/gauth.dart';
import 'package:datacollector/screens/login.dart';
import 'package:datacollector/screens/profile.dart';
import 'package:datacollector/screens/settings.dart';
import 'package:datacollector/utils/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'models/model_selection.dart';
import 'screens/models.dart';
import 'screens/location.dart';

void main() async {
  await init();
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
      null, // icon for your app notification
      [
        NotificationChannel(
            channelKey: 'key1',
            channelName: 'Datacollector',
            channelDescription: "Notification example",
            defaultColor: Color(0XFF9050DD),
            ledColor: Colors.white,
            playSound: true,
            enableLights:true,
            enableVibration: true
        )
      ]
  );

  final cron =Cron();
  //'0/5 * * * * *' every 5 seconds
  cron.schedule(Schedule.parse('* * */2 * * *'), () async => {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'key1',
            title: 'Food and current emotion',
            body: 'Please log about your latest meal and current emotion',
        )
    )
  });
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SensorModel()),
        ChangeNotifierProvider(create: (context) => ModelSelection()),
      ],
      child: MyApp(),
    ),
    // MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

// class _MyAppState extends State<MyApp> {
//   int _currentIndex = 0;
//
//   final tabs = [
//     DashboardScreen(), TrackerScreen(), ReminderScreen(), DevicesScreen()
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       routes: {
//         '/settings': (context) => SettingsScreen(),
//         '/profile' : (context) => ProfileScreen(),
//         '/login' : (context) => LoginScreen(),
//         '/home' : (context) => MyApp(),
//       },
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Data Collector'),
//         ),
//         body: tabs[_currentIndex],
//         drawer: NavigationDrawer(),
//         bottomNavigationBar: BottomNavigationBar(
//           backgroundColor: Colors.blue,
//           type: BottomNavigationBarType.fixed,
//           currentIndex: _currentIndex,
//           items: const <BottomNavigationBarItem>[
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.note_add),
//               label: 'Tracker',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.doorbell),
//               label: 'Reminder',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.watch),
//               label: 'Devices',
//             ),
//           ],
//           selectedItemColor: Colors.white,
//           onTap: (index){
//             setState(() {
//               _currentIndex = index;
//             });
//           },
//         ),
//       ),
//     );
//   }
// }

//Login screen not in use currently

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({
    required this.messageContent,
    required this.messageType,
  });
}

class _MyAppState extends State<MyApp> {
  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';

  @override
  void initState() {
    final firebaseMessaging = FCM();
    print("initState");
    firebaseMessaging.setNotifications(context);

    firebaseMessaging.streamCtlr.stream.listen(_changeData);
    firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    firebaseMessaging.titleCtlr.stream.listen(_changeTitle);

    super.initState();
  }

  _changeData(String msg) => setState(() {
        notificationData = msg;
        print("Data: " + msg);
      });
  _changeBody(String msg) => setState(() {
        notificationBody = msg;
        print("Body: " + msg);
      });
  _changeTitle(String msg) => setState(() {
        notificationTitle = msg;
        print("Title: " + msg);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(fontFamily: 'Cairo'),
      routes: {
        '/settings': (context) => SettingsScreen(),
        '/profile': (context) => ProfileScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomePageWidget(),
        '/models': (context) => ModelsScreen(),
        '/location': (context) => LocationScreen(),
      },
      //Change home screen from here
      home: LoginScreen(),
    );
  }
}

Future init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';

  List<ChatMessage> messages = [];

  @override
  void initState() {
    final firebaseMessaging = FCM();
    print("initState");
    firebaseMessaging.setNotifications(context);

    firebaseMessaging.streamCtlr.stream.listen(_changeData);
    firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    firebaseMessaging.titleCtlr.stream.listen(_changeTitle);

    super.initState();
  }

  _changeData(msg) =>
      setState(() {
        notificationData = msg.toString();
        print("Data: " + msg.toString());
      });

  _changeBody(String msg) =>
      setState(() {
        notificationBody = msg;
        setState(() {
          messages.add(
            ChatMessage(
              messageContent: msg,
              messageType: "receiver",
            ),
          );
        });
        print("Body: " + msg);
      });

  _changeTitle(String msg) =>
      setState(() {
        notificationTitle = msg;
        print("Title: " + msg);
      });

  TextEditingController _chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 15.0,
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: ListView.builder(
                itemCount: messages.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 10, bottom: 10),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 10),
                    child: Align(
                      alignment: (messages[index].messageType == "receiver"
                          ? Alignment.topLeft
                          : Alignment.topRight),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (messages[index].messageType == "receiver"
                              ? Colors.grey.shade200
                              : Colors.blue[200]),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Text(
                          messages[index].messageContent,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _chatController,
                        decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            splashRadius: 0.1,
                            onPressed: () {
                              setState(() {
                                if (_chatController.text == "") return;
                                messages.add(
                                  ChatMessage(
                                    messageContent: _chatController.text,
                                    messageType: "sender",
                                  ),
                                );
                                _chatController.clear();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
