import 'package:futurefinder_flutter/data/api_client.dart';
import 'package:futurefinder_flutter/data/secure_storage_data_source.dart';

class UserRepository {
  final ApiClient _apiClient;
  final SecureStorageDataSource _secureStorageDataSource;

  UserRepository(this._apiClient, this._secureStorageDataSource);
}
