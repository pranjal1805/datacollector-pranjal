import 'package:datacollector/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/model_selection.dart';
import '../widgets/model_switch.dart';

class ModelsScreen extends StatefulWidget {
  ModelsScreen({Key? key}) : super(key: key);

  @override
  _ModelsScreenState createState() => _ModelsScreenState();
}

class _ModelsScreenState extends State<ModelsScreen> {
  List<Map<String, dynamic>> _models(BuildContext context) => [
        {
          'name': '1D CNN',
          'description': '',
          'isActive': context.watch<ModelSelection>().is1DCNN,
        },
        {
          'name': 'LSTM',
          'description': '',
          'isActive': context.watch<ModelSelection>().isLSTM,
        },
    {
      'name': 'Quantization',
      'description': '',
      'isActive': context.watch<ModelSelection>().isquantization,
    },
    {
      'name': 'Pruning',
      'description': '',
      'isActive': context.watch<ModelSelection>().ispruning,
    },
    {
      'name': 'Compression',
      'description': '',
      'isActive': context.watch<ModelSelection>().iscompression,
    },
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Models and Optimizers'),
      ),
      body: ListView.builder(
          itemCount: _models(context).length,
          itemBuilder: (context, position) {
            return ModelSwitch(
              modelMap: _models(context)[position],
            );
          }),
    );
  }
}
