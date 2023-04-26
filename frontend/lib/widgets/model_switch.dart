import 'package:datacollector/models/sensor_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/model_selection.dart';

class ModelSwitch extends StatefulWidget {
  final Map<String, dynamic> modelMap;
  ModelSwitch({
    Key? key,
    required this.modelMap,
  }) : super(key: key);

  @override
  _ModelSwitchState createState() => _ModelSwitchState();
}

class _ModelSwitchState extends State<ModelSwitch> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: widget.modelMap['isActive'],
      title: Text(widget.modelMap['name']),
      onChanged: (val) {
        context.read<ModelSelection>().toggleSensor(widget.modelMap['name']);
      },
    );
  }
}
