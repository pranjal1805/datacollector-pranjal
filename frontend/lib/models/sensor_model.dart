import 'package:datacollector/utils/method_channel.dart';
import 'package:flutter/material.dart';

class SensorModel with ChangeNotifier {
  bool _isGyroActive = false;
  bool _isAccelActive = false;
  bool _isMagnetoActive = false;
  bool _isPPGActive = false;
  bool _isECGActive = false;

  bool get isGyroActive => _isGyroActive;
  bool get isAccelActive => _isAccelActive;
  bool get isMagnetoActive => _isMagnetoActive;
  bool get isPPGActive => _isPPGActive;
  bool get isECGActive => _isECGActive;

  toggleSensor(String sensorName) {
    switch (sensorName) {
      case 'Gyroscope':
        _isGyroActive = !_isGyroActive;
        androidSensorChannel
            .invokeMethod(_isGyroActive ? 'startGyro' : 'stopGyro');
        notifyListeners();
        break;

      case 'Accelerometer':
        _isAccelActive = !_isAccelActive;
        androidSensorChannel
            .invokeMethod(_isAccelActive ? 'startAccel' : 'stopAccel');
        notifyListeners();
        break;

      case 'Magnetometer':
        _isMagnetoActive = !_isMagnetoActive;
        androidSensorChannel
            .invokeMethod(_isMagnetoActive ? 'startMagneto' : 'stopMagneto');
        notifyListeners();
        break;

      case 'PPG':
        _isPPGActive = !_isPPGActive;
        androidSensorChannel
            .invokeMethod(_isPPGActive ? 'startPPG' : 'stopPPG');
        notifyListeners();
        break;

      case 'ECG':
        _isECGActive = !_isECGActive;
        androidSensorChannel
            .invokeMethod(_isECGActive ? 'startECG' : 'stopECG');
        notifyListeners();
        break;

      default:
        break;
    }
    checkSensorActivity();
  }

  void checkSensorActivity() {
    if (!isAccelActive &&
        !isGyroActive &&
        !isMagnetoActive &&
        !isPPGActive &&
        !isECGActive) {
      androidSensorChannel.invokeMethod('serviceOff');
    }
  }
}
