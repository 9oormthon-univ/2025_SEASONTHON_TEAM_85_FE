import 'package:futurefinder_flutter/data/api_client.dart';
import 'package:futurefinder_flutter/data/secure_storage_data_source.dart';
import 'package:futurefinder_flutter/model/user.dart';

class UserRepository {
  final ApiClient _apiClient;
  final SecureStorageDataSource _secureStorageDataSource;

  UserRepository(this._apiClient, this._secureStorageDataSource);

  Future<User> getProfile() async {
    final userJson = await _apiClient.get(url: '/user/profile');

    return User.fromJson(userJson);
  }
}
