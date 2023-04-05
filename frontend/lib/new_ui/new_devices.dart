import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';


class NewDevicesScreen extends StatefulWidget {
  @override
  State<NewDevicesScreen> createState() => _NewDevicesScreenState();
}

class _NewDevicesScreenState extends State<NewDevicesScreen> {

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
                  'New Dash',
                ),
              ],
            ),

            TextButton(onPressed: (){
              platform.invokeListMethod("getBluetoothDevices");
            }, child: Text('Click to search for devices'))
          ],
        ),
      ),
    );
  }
}