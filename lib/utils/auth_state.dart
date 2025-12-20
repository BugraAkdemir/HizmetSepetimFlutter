import 'package:flutter/material.dart';

class UserSession {
  final String name;
  final String email;
  final String role;

  UserSession({
    required this.name,
    required this.email,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "role": role,
      };

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      name: json["name"] ?? "Kullanıcı",
      email: json["email"] ?? "",
      role: json["role"] ?? "ALICI",
    );
  }
}


final authState = ValueNotifier<bool>(false);
final userSession = ValueNotifier<UserSession?>(null);
