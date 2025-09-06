import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/view/job_onboarding/job_activity_detail_screen.dart';
import 'package:futurefinder_flutter/view/job_onboarding/job_onboarding_complete_screen.dart';

class JobActivitySelectionScreen extends StatefulWidget {
  const JobActivitySelectionScreen({super.key});

  @override
  State<JobActivitySelectionScreen> createState() =>
      _JobActivitySelectionScreenState();
}

class _JobActivitySelectionScreenState
    extends State<JobActivitySelectionScreen> {
  Set<String> selectedActivities = {};

  final List<String> activityOptions = [
    '공모전/해커톤',
    '인턴십 경험',
    '동아리/스터디',
    '교육프로그램/부트캠프',
  ];

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
      body: Padding(
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

            // 대외활동 옵션 리스트
            Expanded(
              child: ListView.builder(
                itemCount: activityOptions.length,
                itemBuilder: (context, index) {
                  final activity = activityOptions[index];
                  final isSelected = selectedActivities.contains(activity);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedActivities.remove(activity);
                          } else {
                            selectedActivities.add(activity);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              activity,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: isSelected
                                  ? const Color(0xFF00BFFF)
                                  : Colors.grey.shade400,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // 하단 버튼들
            Column(
              children: [
                // 아니요 버튼
                TextButton(
                  onPressed: () {
                    // 대외활동 없음으로 설정하고 완료 화면으로
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            const JobOnboardingCompleteScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    '아니요',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 12),

                // 완료 버튼
                ElevatedButton(
                  onPressed: selectedActivities.isNotEmpty
                      ? () {
                          // 선택된 대외활동이 있으면 상세 입력 화면으로
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => JobActivityDetailScreen(
                                selectedActivities: selectedActivities.toList(),
                              ),
                            ),
                          );
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
          ],
        ),
      ),
    );
  }
}
