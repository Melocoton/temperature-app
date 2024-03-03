import 'dart:convert';

class Device {
  final int id;
  final String description;

  Device({
    required this.id,
    required this.description,
  });

  Device copyWith({
    int? id,
    String? description,
  }) =>
      Device(
        id: id ?? this.id,
        description: description ?? this.description,
      );

  factory Device.fromRawJson(String str) => Device.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    id: json["id"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
  };
}
