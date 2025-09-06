import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/data/api_client.dart';
import 'package:futurefinder_flutter/data/secure_storage_data_source.dart';
import 'package:futurefinder_flutter/dto/api_response_dto.dart';
import 'package:futurefinder_flutter/dto/auth_dto.dart';
import 'package:futurefinder_flutter/model/user.dart';

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

  Future<User> getProfile() async {
    GeneralResponseDto response;
    response = await _apiClient.get(
      url: '/user/profile',
      headers: {'Authorization': 'Bearer ${await getAccessToken()}'},
    );

    return await User.fromJson(response.data);
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
