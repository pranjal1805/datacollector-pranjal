import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';


class DevicesScreen extends StatefulWidget {
  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {

  static const platform = MethodChannel('android/bluetooth');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Connect fitness tracker', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.watch,
                    color: Colors.white,
                    size: 100,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                  'Connect your fitness tracker to log your activity and view it in the app'),
            ),
            TextButton(onPressed: (){
              platform.invokeListMethod("getBluetoothDevices");
            }, child: Text('Click to search for devices')),

            TextButton(onPressed: (){
              platform.invokeListMethod("showScannedDevices");
            }, child: Text('Show list of scanned devices')),

            TextButton(onPressed: (){
              platform.invokeListMethod("connectToDevice");
            }, child: Text('Test : connect to a bluetooth device')),

            TextButton(onPressed: (){
              platform.invokeListMethod("disconnectDevice");
            }, child: Text('Disconnect Device')),
            TextButton(onPressed: (){
              platform.invokeListMethod("previouslyConnectedDevices");
            }, child: Text('Show previously connected devices'))
          ],
        ),
      ),
    );
  }
}