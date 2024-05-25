import 'dart:io';

import 'package:temperature_app/data/models/apiAuth.dart';
import 'package:temperature_app/data/models/device.dart';
import 'package:temperature_app/data/models/temperature.dart';
import 'package:temperature_app/data/models/record.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:temperature_app/data/state/mainState.dart';

const String url = 'url:port';
const String key = 'key';

class TemperatureApi{
  Future<List<Temperature>> getCurrentTemp() async {
    var response = await http.get(Uri.http(url, 'current'), headers: getHeader(true));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List<dynamic>;
      return data.map((e) => Temperature.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<List<Device>> getDevices() async {
    var response = await http.get(Uri.http(url, 'devices'), headers: getHeader(true));
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
    }), headers: getHeader(true));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List<dynamic>;
      return data.map((e) => Record.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<String> authenticate() async {
    var response = await http.post(Uri.http(url, 'auth'), headers: getHeader(false), body: json.encode({'key': key}));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return ApiAuth.fromJson(data).token;
    } else {
      return "";
    }
  }

  Map<String, String> getHeader(bool auth) {
    if (auth) {
      return {HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer ${MainState().token}"};
    } else {
      return {HttpHeaders.contentTypeHeader: "application/json"};
    }
  }
}