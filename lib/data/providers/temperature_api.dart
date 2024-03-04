import 'package:temperature_app/data/models/device.dart';
import 'package:temperature_app/data/models/temperature.dart';
import 'package:temperature_app/data/models/record.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String url = 'raspberrypi.lan:9001';

class TemperatureApi{
  Future<List<Temperature>> getCurrentTemp() async {
    var response = await http.get(Uri.http(url, 'current'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List<dynamic>;
      return data.map((e) => Temperature.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<List<Device>> getDevices() async {
    var response = await http.get(Uri.http(url, 'devices'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List<dynamic>;
      return data.map((e) => Device.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<List<Record>> getHistory(int id, DateTime startDate, DateTime endDate) async {
    // ${startDate.millisecondsSinceEpoch}-${endDate.millisecondsSinceEpoch}
    var response = await http.get(Uri.http(url, 'history/$id', {
      'rangeStart': startDate.millisecondsSinceEpoch.toString(),
      'rangeEnd': endDate.millisecondsSinceEpoch.toString(),
      'smooth': true.toString()
    }));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List<dynamic>;
      return data.map((e) => Record.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}