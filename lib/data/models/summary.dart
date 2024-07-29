import 'dart:convert';

class Summary {
  final DateTime time;
  final int maxTemp;
  final int minTem;
  final int maxHum;
  final int minHum;

  Summary({
    required this.time,
    required this.maxTemp,
    required this.minTem,
    required this.maxHum,
    required this.minHum,
  });

  Summary copyWith({
    DateTime? time,
    int? maxTemp,
    int? minTem,
    int? maxHum,
    int? minHum,
  }) =>
      Summary(
        time: time ?? this.time,
        maxTemp: maxTemp ?? this.maxTemp,
        minTem: minTem ?? this.minTem,
        maxHum: maxHum ?? this.maxHum,
        minHum: minHum ?? this.minHum,
      );

  factory Summary.fromRawJson(String str) => Summary.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    time: DateTime.parse(json["time"]),
    maxTemp: json["maxTemp"],
    minTem: json["minTem"],
    maxHum: json["maxHum"],
    minHum: json["minHum"],
  );

  Map<String, dynamic> toJson() => {
    "time": "${time.year.toString().padLeft(4, '0')}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}",
    "maxTemp": maxTemp,
    "minTem": minTem,
    "maxHum": maxHum,
    "minHum": minHum,
  };
}