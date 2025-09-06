import 'package:futurefinder_flutter/data/api_client.dart';
import 'package:futurefinder_flutter/data/secure_storage_data_source.dart';
import 'package:futurefinder_flutter/exception/api_exception.dart';
import 'package:futurefinder_flutter/model/search_result.dart';

class SearchRepository {
  final ApiClient _apiClient;
  final SecureStorageDataSource _secureStorageDataSource;

  SearchRepository(this._apiClient, this._secureStorageDataSource);

  Future<SearchResult> searchWord(String keyWord) async {
    final response = await _apiClient.get(
      url: '/dictionary/search',
      params: {'q': keyWord},
      headers: {'Authorization': 'Bearer ${await getAccessToken()}'},
    );

    if (response.status == 404) {
      throw ApiException(404, "not found", "not found");
    }

    return SearchResult.fromJson(response.data);
  }

  Future<String?> getAccessToken() async {
    return await _secureStorageDataSource.getAccessToken();
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorageDataSource.getRefreshToken();
  }
}
