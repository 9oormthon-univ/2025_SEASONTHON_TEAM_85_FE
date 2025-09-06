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

  static Future<User> fromJson(GeneralResponseDto json) async {
    return User(
      username: json.data['username'],
      nickname: json.data['nickname'],
      email: json.data['email'],
      phoneNumber: json.data['phoneNumber'],
      birth: json.data['birth'],
      imageUrl: json.data['imageUrl'],
    );
  }
}
