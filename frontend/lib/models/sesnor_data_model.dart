class SensorDataModel {
  String? sensorId;
  String? count;
  List<Data>? data;

  SensorDataModel({this.sensorId, this.count, this.data});

  SensorDataModel.fromJson(Map<String, dynamic> json) {
    sensorId = json['sensor_id'];
    count = json['count'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sensor_id'] = this.sensorId;
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? timestamp;
  int? activeMs;
  double? xAxis;
  double? yAxis;
  double? zAxis;

  Data({this.timestamp, this.activeMs, this.xAxis, this.yAxis, this.zAxis});

  Data.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    activeMs = json['active_ms'];
    xAxis = json['x_axis'];
    yAxis = json['y_axis'];
    zAxis = json['z_axis'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timestamp'] = this.timestamp;
    data['active_ms'] = this.activeMs;
    data['x_axis'] = this.xAxis;
    data['y_axis'] = this.yAxis;
    data['z_axis'] = this.zAxis;
    return data;
  }
}
