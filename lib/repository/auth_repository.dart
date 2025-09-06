import 'package:futurefinder_flutter/data/api_client.dart';
import 'package:futurefinder_flutter/data/secure_storage_data_source.dart';
import 'package:futurefinder_flutter/dto/api_response_dto.dart';
import 'package:futurefinder_flutter/dto/auth_dto.dart';

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
}
