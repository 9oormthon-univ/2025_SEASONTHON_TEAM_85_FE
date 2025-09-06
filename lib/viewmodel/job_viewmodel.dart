// viewmodel/job_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/mixin/loading_mixin.dart';
import 'package:futurefinder_flutter/model/job_response.dart';
import 'package:futurefinder_flutter/repository/job_repository.dart';

class JobViewModel extends ChangeNotifier with LoadingMixin {
  final JobRepository _jobRepository;

  JobViewModel(this._jobRepository);

  // 상태 관리
  List<RecommendedJobResponse> _recommendedJobs = [];
  List<RecommendedActivityResponse> _recommendedActivities = [];
  JobInfoResponse? _jobInfo;
  String? _errorMessage;

  // 온보딩 데이터 임시 저장
  Map<String, String>? _educationData;
  List<Map<String, String>> _activitiesData = [];

  // Getters
  List<RecommendedJobResponse> get recommendedJobs => _recommendedJobs;
  List<RecommendedActivityResponse> get recommendedActivities =>
      _recommendedActivities;
  JobInfoResponse? get jobInfo => _jobInfo;
  String? get errorMessage => _errorMessage;
  Map<String, String>? get educationData => _educationData;
  List<Map<String, String>> get activitiesData => _activitiesData;

  // 사용자 정보 (jobInfo에서 가져옴)
  String get userName {
    if (_jobInfo?.educations.isNotEmpty == true) {
      return '김영주님'; // 일단 하드코딩, 나중에 사용자 정보 API에서 가져오기
    }
    return '김영주님';
  }

  String get userEducation {
    if (_educationData != null) {
      return '${_educationData!['school']} ${_educationData!['major']}';
    }
    if (_jobInfo?.educations.isNotEmpty == true) {
      final education = _jobInfo!.educations.first;
      return '${education.schoolName} ${education.major}';
    }
    return '연세대학교 경영학과';
  }

  String get userActivity {
    if (_activitiesData.isNotEmpty) {
      // 모든 활동을 한국어로 변환해서 쉼표로 연결
      final koreanActivities = _activitiesData.map((activity) {
        final activityType = activity['type'] ?? '';
        return _convertActivityTypeToKorean(activityType);
      }).toList();

      return koreanActivities.join(', ');
    }
    if (_jobInfo?.activities.isNotEmpty == true) {
      // jobInfo에서도 마찬가지로 처리
      final koreanActivities = _jobInfo!.activities.map((activity) {
        return _convertActivityTypeToKorean(activity.type);
      }).toList();

      return koreanActivities.join(', ');
    }
    return '인턴경험';
  }

  // 활동 타입을 한국어로 변환하는 헬퍼 메서드 추가
  String _convertActivityTypeToKorean(String englishType) {
    switch (englishType) {
      case 'COMPETITION':
        return '공모전/수상';
      case 'INTERNSHIP':
        return '인턴십';
      case 'CLUB':
        return '동아리/스터디';
      case 'PROGRAM':
        return '교육프로그램/부트캠프';
      default:
        return '기타 활동';
    }
  }

  // 교육 정보 저장
  void saveEducation(Map<String, String> educationData) {
    _educationData = educationData;
    debugPrint('교육 정보 저장됨: $_educationData');
    notifyListeners();
  }

  // 활동 정보 저장 (API 명세에 맞게 수정)
  void saveActivities(List<Map<String, dynamic>> activitiesData) {
    _activitiesData = activitiesData
        .map(
          (activity) => {
            'type': activity['type'] as String,
            'title': activity['title'] as String,
            'startedOn': activity['startedOn'] as String,
            'endedOn': activity['endedOn'] as String,
            'memo': activity['memo'] as String,
          },
        )
        .toList();
    debugPrint('활동 정보 저장됨: $_activitiesData');
    notifyListeners();
  }

  // 온보딩 데이터 초기화
  void clearOnboardingData() {
    _educationData = null;
    _activitiesData = [];
    notifyListeners();
  }

  // 온보딩 완료 처리
  Future<void> completeOnboarding() async {
    try {
      startLoading();

      // 실제 API 호출로 사용자 정보 저장
      // await _jobRepository.saveUserEducation(_educationData);
      // await _jobRepository.saveUserActivities(_activitiesData);

      // 임시로 더미 데이터로 jobInfo 생성
      _createJobInfoFromOnboardingData();

      // 추천 데이터 로드
      await loadInitialData();
    } catch (e) {
      _errorMessage = '온보딩 완료 중 오류가 발생했습니다: $e';
      debugPrint('온보딩 완료 오류: $e');

      // 오류 발생 시에도 더미 데이터로 진행
      _createJobInfoFromOnboardingData();
      loadDummyData();
    } finally {
      stopLoading();
    }
  }

  // 온보딩 데이터로부터 JobInfo 생성
  void _createJobInfoFromOnboardingData() {
    if (_educationData != null) {
      // 실제로는 API 모델에 맞게 변환해야 함
      // 여기서는 임시로 더미 JobInfoResponse 생성
      debugPrint(
        '온보딩 데이터로 JobInfo 생성: 교육정보 ${_educationData}, 활동정보 ${_activitiesData}',
      );
    }
  }

  // 초기 데이터 로드
  Future<void> loadInitialData() async {
    try {
      startLoading();
      _errorMessage = null;

      // 병렬로 API 호출
      final futures = await Future.wait([
        _jobRepository.getRecommendedJobs(),
        _jobRepository.getRecommendedActivities(),
        _jobRepository.getJobInfo(),
      ]);

      _recommendedJobs = futures[0] as List<RecommendedJobResponse>;
      _recommendedActivities = futures[1] as List<RecommendedActivityResponse>;
      _jobInfo = futures[2] as JobInfoResponse;

      notifyListeners();
    } catch (e) {
      _errorMessage = '데이터를 불러오는 중 오류가 발생했습니다: $e';
      notifyListeners();
      // 에러 발생 시 더미 데이터 로드
      loadDummyData();
    } finally {
      stopLoading();
    }
  }

  // 추천 채용공고 새로고침
  Future<void> refreshRecommendedJobs() async {
    try {
      _recommendedJobs = await _jobRepository.getRecommendedJobs();
      notifyListeners();
    } catch (e) {
      _errorMessage = '추천 채용공고를 새로고침하는 중 오류가 발생했습니다: $e';
      notifyListeners();
    }
  }

  // 추천 대외활동 새로고침
  Future<void> refreshRecommendedActivities() async {
    try {
      _recommendedActivities = await _jobRepository.getRecommendedActivities();
      notifyListeners();
    } catch (e) {
      _errorMessage = '추천 대외활동을 새로고침하는 중 오류가 발생했습니다: $e';
      notifyListeners();
    }
  }

  // 사용자 정보 새로고침
  Future<void> refreshUserInfo() async {
    try {
      _jobInfo = await _jobRepository.getJobInfo();
      notifyListeners();
    } catch (e) {
      _errorMessage = '사용자 정보를 새로고침하는 중 오류가 발생했습니다: $e';
      notifyListeners();
    }
  }

  // 에러 메시지 클리어
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // 더미 데이터 생성 (API 연동 실패 시 대체용)
  void loadDummyData() {
    _recommendedJobs = [
      RecommendedJobResponse(
        id: 1,
        title: '사업운영 인턴, Operations Intern',
        company: '[MISO]',
        location: '서울 전체',
        jobType: '인턴',
        deadline: '2025-01-30',
        description: 'MISO에서 사업운영 인턴을 모집합니다.',
        logoUrl: '',
        tags: ['사업운영', '인턴', '스타트업'],
        salaryInfo: '시급 12,000원',
      ),
      RecommendedJobResponse(
        id: 2,
        title: 'DX 부문 인턴 채용',
        company: '[삼성전자]',
        location: '서울 서초구',
        jobType: '인턴',
        deadline: '2025-01-27',
        description: '삼성전자 DX 부문에서 인턴을 모집합니다.',
        logoUrl: '',
        tags: ['DX', '인턴', '대기업'],
        salaryInfo: '월급 2,500,000원',
      ),
      RecommendedJobResponse(
        id: 3,
        title: 'DX 부문 인턴 채용',
        company: '[삼성전자]',
        location: '서울 서초구',
        jobType: '인턴',
        deadline: '2025-01-27',
        description: '삼성전자 DX 부문에서 인턴을 모집합니다.',
        logoUrl: '',
        tags: ['DX', '인턴', '대기업'],
        salaryInfo: '월급 2,500,000원',
      ),
    ];

    _recommendedActivities = [
      RecommendedActivityResponse(
        id: 1,
        title: 'POOM 서포터즈 5기 모집',
        organization: '주식회사 아트박스',
        location: '지역 제한없음',
        type: '브랜드',
        deadline: '2025-02-15',
        description: 'POOM 브랜드 서포터즈를 모집합니다.',
        logoUrl: '',
        tags: ['서포터즈', '브랜드', 'SNS'],
      ),
      RecommendedActivityResponse(
        id: 2,
        title: 'CJ LOGISTICS 대학생 앰버서터',
        organization: 'CJ대한통운(주)',
        location: '서울',
        type: '기업',
        deadline: '2025-02-20',
        description: 'CJ 대학생 앰버서터를 모집합니다.',
        logoUrl: '',
        tags: ['앰버서터', '기업', '물류'],
      ),
      RecommendedActivityResponse(
        id: 3,
        title: 'Digital Hana',
        organization: '하나은행',
        location: '서울',
        type: '금융',
        deadline: '2025-02-10',
        description: '하나은행 디지털 서포터즈를 모집합니다.',
        logoUrl: '',
        tags: ['디지털', '금융', '은행'],
      ),
      RecommendedActivityResponse(
        id: 4,
        title: '삼성 금융캠퍼스 1기 모집(3일과정)',
        organization: '삼성생명보험(주)',
        location: '지역제한없음',
        type: '교육',
        deadline: '2025-02-25',
        description: '삼성 금융캠퍼스 교육 프로그램입니다.',
        logoUrl: '',
        tags: ['교육', '금융', '캠퍼스'],
      ),
    ];

    notifyListeners();
  }
}
