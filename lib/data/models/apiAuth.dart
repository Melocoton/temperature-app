import 'dart:convert';

class ApiAuth {
  final String token;

  ApiAuth({
    required this.token,
  });

  ApiAuth copyWith({
    String? token,
  }) =>
      ApiAuth(
        token: token ?? this.token,
      );

  factory ApiAuth.fromRawJson(String str) => ApiAuth.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ApiAuth.fromJson(Map<String, dynamic> json) => ApiAuth(
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
  };
}