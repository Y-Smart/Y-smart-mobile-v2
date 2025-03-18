import 'dart:convert';

class Jwt {
  final String accessToken;

  Jwt({required this.accessToken});

  Map<String, dynamic> toMap() {
    return {
      'accessToken': accessToken,
    };
  }

  factory Jwt.fromMap(Map<String, dynamic> map) {
    return Jwt(
      accessToken: map['accessToken'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Jwt.fromJson(String source) => Jwt.fromMap(json.decode(source));
}