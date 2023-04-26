import 'package:datacollector/models/sensor_model.dart';
import 'package:datacollector/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<Map<String, dynamic>> _sensors(BuildContext context) => [
        {
          'name': 'Gyroscope',
          'description': '',
          'isActive': context.watch<SensorModel>().isGyroActive,
        },
        {
          'name': 'Accelerometer',
          'description': '',
          'isActive': context.watch<SensorModel>().isAccelActive,
        },
        {
          'name': 'Magnetometer',
          'description': '',
          'isActive': context.watch<SensorModel>().isMagnetoActive,
        },
        {
          'name': 'PPG',
          'description': '',
          'isActive': context.watch<SensorModel>().isPPGActive,
        },
        {
          'name': 'ECG',
          'description': '',
          'isActive': context.watch<SensorModel>().isECGActive,
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView.builder(
        itemCount: _sensors(context).length,
        itemBuilder: (context, position) {
          return SensorSwitch(
            sensorMap: _sensors(context)[position],
          );
        },
      ),
    );
  }
}
