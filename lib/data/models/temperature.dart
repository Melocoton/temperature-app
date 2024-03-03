import 'dart:convert';

class Temperature {
  final int id;
  final String idFormatted;
  final DateTime time;
  final String timeFormatted;
  final int temperature;
  final int humidity;

  Temperature({
    required this.id,
    required this.idFormatted,
    required this.time,
    required this.timeFormatted,
    required this.temperature,
    required this.humidity,
  });

  Temperature copyWith({
    int? id,
    String? idFormatted,
    DateTime? time,
    String? timeFormatted,
    int? temperature,
    int? humidity,
  }) =>
      Temperature(
        id: id ?? this.id,
        idFormatted: idFormatted ?? this.idFormatted,
        time: time ?? this.time,
        timeFormatted: timeFormatted ?? this.timeFormatted,
        temperature: temperature ?? this.temperature,
        humidity: humidity ?? this.humidity,
      );

  factory Temperature.fromRawJson(String str) => Temperature.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Temperature.fromJson(Map<String, dynamic> json) => Temperature(
    id: json["id"],
    idFormatted: json["id_formatted"],
    time: DateTime.fromMillisecondsSinceEpoch(json["time"]),
    timeFormatted: json["time_formatted"],
    temperature: json["temperature"],
    humidity: json["humidity"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_formatted": idFormatted,
    "time": time.millisecondsSinceEpoch,
    "time_formatted": timeFormatted,
    "temperature": temperature,
    "humidity": humidity,
  };
}
