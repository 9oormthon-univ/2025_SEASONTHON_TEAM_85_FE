import 'package:futurefinder_flutter/data/api_client.dart';
import 'package:futurefinder_flutter/data/secure_storage_data_source.dart';
import 'package:futurefinder_flutter/dto/api_response_dto.dart';
import 'package:futurefinder_flutter/model/asset.dart';

class AssetRepository {
  final ApiClient _apiClient;
  final SecureStorageDataSource _secureStorageDataSource;

  AssetRepository(this._apiClient, this._secureStorageDataSource);

  Future<List<Asset>> getAssets() async {
    final GeneralResponseDto response = await _apiClient.get(
      url: '/asset/list',
      headers: {"Authorization": "Bearer ${await getAccessToken()}"},
    );

    return List<Asset>.from(response.data);
  }

  Future<String?> getAccessToken() async {
    return await _secureStorageDataSource.getAccessToken();
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorageDataSource.getRefreshToken();
  }
}
