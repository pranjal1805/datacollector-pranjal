import 'package:datacollector/models/sensor_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SensorSwitch extends StatefulWidget {
  final Map<String, dynamic> sensorMap;
  SensorSwitch({
    Key? key,
    required this.sensorMap,
  }) : super(key: key);

  @override
  _SensorSwitchState createState() => _SensorSwitchState();
}

class _SensorSwitchState extends State<SensorSwitch> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: widget.sensorMap['isActive'],
      title: Text(widget.sensorMap['name']),
      onChanged: (val) {
        context.read<SensorModel>().toggleSensor(widget.sensorMap['name']);
        // TODO: method channels to control sensor services
      },
    );
  }
}
