import 'dart:convert';

class Record {
  final int time;
  final num temperature;
  final num humidity;

  Record({
    required this.time,
    required this.temperature,
    required this.humidity,
  });

  Record copyWith({
    int? time,
    num? temperature,
    num? humidity,
  }) =>
      Record(
        time: time ?? this.time,
        temperature: temperature ?? this.temperature,
        humidity: humidity ?? this.humidity,
      );

  factory Record.fromRawJson(String str) => Record.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Record.fromJson(Map<String, dynamic> json) => Record(
    time: json["time"],
    temperature: json["temperature"],
    humidity: json["humidity"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "temperature": temperature,
    "humidity": humidity,
  };
}