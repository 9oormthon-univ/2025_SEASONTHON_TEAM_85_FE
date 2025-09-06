// repository/job_repository.dart
import 'package:futurefinder_flutter/data/api_client.dart';
import 'package:futurefinder_flutter/data/secure_storage_data_source.dart';
import 'package:futurefinder_flutter/dto/api_response_dto.dart';
import 'package:futurefinder_flutter/model/job_response.dart';

class JobRepository {
  final ApiClient _apiClient;
  final SecureStorageDataSource _secureStorageDataSource;

  JobRepository(this._apiClient, this._secureStorageDataSource);

  // 헤더에 인증 토큰 추가하는 헬퍼 메서드
  Future<Map<String, String>> _getAuthHeaders() async {
    final accessToken = await _secureStorageDataSource.readToken();
    if (accessToken != null) {
      return {'Authorization': 'Bearer $accessToken'};
    }
    return {};
  }

  // AI 맞춤형 취업 공고 조회
  Future<List<RecommendedJobResponse>> getRecommendedJobs() async {
    final headers = await _getAuthHeaders();

    final GeneralResponseDto response = await _apiClient.get(
      url: '/job/recommended-jobs',
      headers: headers,
    );

    final List<dynamic> jobsData = response.data as List;
    return jobsData
        .map((json) => RecommendedJobResponse.fromJson(json))
        .toList();
  }

  // AI 추천 대외활동 조회
  Future<List<RecommendedActivityResponse>> getRecommendedActivities() async {
    final headers = await _getAuthHeaders();

    final GeneralResponseDto response = await _apiClient.get(
      url: '/job/recommended-activities',
      headers: headers,
    );

    final List<dynamic> activitiesData = response.data as List;
    return activitiesData
        .map((json) => RecommendedActivityResponse.fromJson(json))
        .toList();
  }

  // 취업 관련 정보 전체 조회 (학력, 대외활동, 수상내역)
  Future<JobInfoResponse> getJobInfo() async {
    final headers = await _getAuthHeaders();

    final GeneralResponseDto response = await _apiClient.get(
      url: '/job/info',
      headers: headers,
    );

    return JobInfoResponse.fromJson(response.data);
  }

  // 학력 정보만 조회
  Future<EducationResponse?> getEducation() async {
    final headers = await _getAuthHeaders();

    final GeneralResponseDto response = await _apiClient.get(
      url: '/job/education',
      headers: headers,
    );

    if (response.data == null) return null;
    return EducationResponse.fromJson(response.data);
  }

  // 대외활동 목록 조회
  Future<List<ActivityResponse>> getActivities() async {
    final headers = await _getAuthHeaders();

    final GeneralResponseDto response = await _apiClient.get(
      url: '/job/activities',
      headers: headers,
    );

    final List<dynamic> activitiesData = response.data as List;
    return activitiesData
        .map((json) => ActivityResponse.fromJson(json))
        .toList();
  }

  // 수상 내역 목록 조회
  Future<List<AwardResponse>> getAwards() async {
    final headers = await _getAuthHeaders();

    final GeneralResponseDto response = await _apiClient.get(
      url: '/job/awards',
      headers: headers,
    );

    final List<dynamic> awardsData = response.data as List;
    return awardsData.map((json) => AwardResponse.fromJson(json)).toList();
  }
}
