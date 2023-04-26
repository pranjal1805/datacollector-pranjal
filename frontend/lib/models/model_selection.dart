import 'package:datacollector/utils/method_channel.dart';
import 'package:flutter/material.dart';

class ModelSelection with ChangeNotifier {
  bool _1DCNN = false;
  bool _LSTM = false;
  bool _quantization=false;
  bool _pruning=false;
  bool _compression=false;

  bool get is1DCNN => _1DCNN;
  bool get isLSTM => _LSTM;
  bool get isquantization => _quantization;
  bool get ispruning => _pruning;
  bool get iscompression => _compression;

  toggleSensor(String modelName) {
    switch (modelName) {
      case '1D CNN':
        _1DCNN = !_1DCNN;
        notifyListeners();
        break;

      case 'LSTM':
        _LSTM = !_LSTM;
        notifyListeners();
        break;
      case 'Quantization':
        if(_pruning==true || _compression==true)
        {
          _pruning=false;
          _compression=false;
        }
        _quantization = !_quantization;
        notifyListeners();
        break;

      case 'Pruning':
        if(_quantization==true || _compression==true)
        {
          _quantization=false;
          _compression=false;
        }
        _pruning = !_pruning;
        notifyListeners();
        break;
      case 'Compression':
        if(_quantization==true || _pruning==true)
        {
          _quantization=false;
          _pruning=false;
        }
        _compression = !_compression;
        notifyListeners();
        break;


      default:
        break;
    }
  }
}
