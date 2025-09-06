import 'package:futurefinder_flutter/dto/api_response_dto.dart';

class User {
  final String username;
  final String nickname;
  final String email;
  final String phoneNumber;
  final String birth;
  final String imageUrl;

  User({
    required this.username,
    required this.nickname,
    required this.email,
    required this.phoneNumber,
    required this.birth,
    required this.imageUrl,
  });

  static Future<User> fromJson(Map<String, dynamic> json) async {
    return User(
      username: json['username'] ?? '',
      nickname: json['nickname'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      birth: json['birth'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
