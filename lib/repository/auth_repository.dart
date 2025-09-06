import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/data/api_client.dart';
import 'package:futurefinder_flutter/data/secure_storage_data_source.dart';
import 'package:futurefinder_flutter/dto/api_response_dto.dart';
import 'package:futurefinder_flutter/dto/auth_dto.dart';


import '../exception/api_exception.dart';
import '../model/user.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final SecureStorageDataSource _secureStorageDataSource;
  AuthRepository(this._apiClient, this._secureStorageDataSource);

  Future<int> login(LoginRequest request) async {
    final GeneralResponseDto response = await _apiClient.post(
      url: '/auth/login',
      body: request,
    );

    await _secureStorageDataSource.saveAccessToken(
      response.data['accessToken'],
    );
    await _secureStorageDataSource.saveRefreshToken(
      response.data['refreshToken'],
    );

    return response.status;
  }

  Future<int> signUp(SignUpRequest request) async {
    final GeneralResponseDto response = await _apiClient.post(
      url: '/auth/create/account',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: request.toJson(),              // ✅ 반드시 Map -> jsonEncode 되도록
    );

    final data = response.data;
    final access = (data is Map) ? data['accessToken'] as String? : null;
    final refresh = (data is Map) ? data['refreshToken'] as String? : null;

    if (access == null || refresh == null) {
      throw ApiException(response.status, 'TOKEN_MISSING', '토큰이 응답에 없습니다.');
    }

    await _secureStorageDataSource.saveAccessToken(access);
    await _secureStorageDataSource.saveRefreshToken(refresh);
    return response.status; // 200
  }

  // ✅ 비밀번호 생성
  Future<int> createPassword(CreatePasswordRequest request) async {
    final accessToken = await getAccessToken();
    if (accessToken == null) {
      throw ApiException(401, 'AUTH_4', '토큰을 확인해주세요');
    }

    final GeneralResponseDto response = await _apiClient.post(
      url: '/auth/create/password',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: request.toJson(),              // ✅ 마찬가지로 JSON
    );

    return response.status; // 200
  }
  Future<User> getProfile() async {
    GeneralResponseDto response;
    response = await _apiClient.get(
      url: '/user/profile',
      headers: {'Authorization': 'Bearer ${await getAccessToken()}'},
    );

    return User.fromJson(response.data);
  }

  Future<String?> getAccessToken() async {
    return await _secureStorageDataSource.getAccessToken();
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorageDataSource.getRefreshToken();
  }

  Future<String> refreshAccessToken() async {
    final refreshToken = await getRefreshToken();
    debugPrint("Original refresh token: $refreshToken");

    final response = await _apiClient.get(
      url: '/auth/refresh',
      headers: {"Authorization": "Bearer $refreshToken"},
    );

    final newAccessToken = response.data['accessToken'];
    final newRefreshToken = response.data['refreshToken'];

    await _secureStorageDataSource.saveAccessToken(newAccessToken);
    await _secureStorageDataSource.saveRefreshToken(newRefreshToken);

    debugPrint("New access token: $newAccessToken");
    debugPrint("New refresh token: $newRefreshToken");

    return newAccessToken;
  }
}
