import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/view/job_onboarding/job_onboarding_complete_screen.dart';
import 'package:futurefinder_flutter/viewmodel/job_viewmodel.dart';
import 'package:provider/provider.dart';

class JobActivityDetailScreen extends StatefulWidget {
  final List<String> selectedActivities;

  const JobActivityDetailScreen({super.key, required this.selectedActivities});

  @override
  State<JobActivityDetailScreen> createState() =>
      _JobActivityDetailScreenState();
}

class _JobActivityDetailScreenState extends State<JobActivityDetailScreen> {
  // 각 활동별 입력 데이터를 저장할 맵
  Map<String, ActivityData> activityDataMap = {};

  @override
  void initState() {
    super.initState();
    // 선택된 활동별로 데이터 객체 생성
    for (String activity in widget.selectedActivities) {
      activityDataMap[activity] = ActivityData();
    }
  }

  bool get isFormValid {
    // 모든 활동의 필수 필드가 입력되었는지 확인
    return activityDataMap.values.every(
      (data) =>
          data.titleController.text.isNotEmpty &&
          data.startDateController.text.isNotEmpty &&
          data.endDateController.text.isNotEmpty,
    );
  }

  // 활동 타입을 API 타입으로 변환
  String getApiType(String activityName) {
    switch (activityName) {
      case '공모전/해커톤':
        return 'COMPETITION';
      case '인턴십 경험':
        return 'INTERNSHIP';
      case '동아리/스터디':
        return 'CLUB';
      case '교육프로그램/부트캠프':
        return 'PROGRAM';
      default:
        return 'OTHER';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '대외활동',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '대외활동 경험이 있나요?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '대외활동',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // 선택된 활동 표시
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.selectedActivities.map((activity) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00BFFF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF00BFFF)),
                      ),
                      child: Text(
                        activity,
                        style: const TextStyle(
                          color: Color(0xFF00BFFF),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),

                // 각 선택된 활동에 대한 상세 입력 폼
                ...widget.selectedActivities.map((activity) {
                  final data = activityDataMap[activity]!;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 활동 타입 라벨
                        Text(
                          '$activity 활동내역',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 활동명/제목
                        _buildInputField(
                          label: '활동명/제목',
                          controller: data.titleController,
                          hintText: activity == '인턴십 경험'
                              ? '활동 이름을 입력하세요'
                              : '$activity 제목을 입력하세요',
                        ),
                        const SizedBox(height: 16),

                        // 시작일
                        _buildInputField(
                          label: '시작일',
                          controller: data.startDateController,
                          hintText: '2024-03-01',
                        ),
                        const SizedBox(height: 16),

                        // 종료일
                        _buildInputField(
                          label: '종료일',
                          controller: data.endDateController,
                          hintText: '2024-06-30',
                        ),
                        const SizedBox(height: 16),

                        // 활동내용 (메모)
                        _buildInputField(
                          label: '활동내용',
                          controller: data.memoController,
                          hintText: '활동 내용을 자세히 작성해주세요',
                          maxLines: 3,
                        ),
                      ],
                    ),
                  );
                }).toList(),

                const SizedBox(height: 40),

                // 완료 버튼
                ElevatedButton(
                  onPressed: isFormValid
                      ? () {
                          _saveActivitiesAndNavigate(context);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BFFF),
                    disabledBackgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '완료',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF00BFFF)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  void _saveActivitiesAndNavigate(BuildContext context) {
    // JobViewModel에 활동 데이터 저장
    final jobViewModel = context.read<JobViewModel>();

    // API 명세에 맞는 형태로 활동 데이터 변환
    List<Map<String, dynamic>> activitiesData = widget.selectedActivities.map((
      activity,
    ) {
      final data = activityDataMap[activity]!;
      return {
        'type': getApiType(activity),
        'title': data.titleController.text,
        'startedOn': data.startDateController.text,
        'endedOn': data.endDateController.text,
        'memo': data.memoController.text,
      };
    }).toList();

    // ViewModel에 활동 데이터 저장
    jobViewModel.saveActivities(activitiesData);

    debugPrint('저장된 활동 데이터: $activitiesData');

    // 완료 화면으로 이동
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const JobOnboardingCompleteScreen(),
      ),
    );
  }

  @override
  void dispose() {
    // 모든 컨트롤러 해제
    for (var data in activityDataMap.values) {
      data.dispose();
    }
    super.dispose();
  }
}

// 활동별 입력 데이터를 관리하는 클래스
class ActivityData {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController memoController = TextEditingController();

  void dispose() {
    titleController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    memoController.dispose();
  }
}
