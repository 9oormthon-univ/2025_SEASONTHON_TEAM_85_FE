import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/viewmodel/job_viewmodel.dart';
import 'package:provider/provider.dart';

class JobOnboardingCompleteScreen extends StatelessWidget {
  const JobOnboardingCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // 기존 Container 코드를 이것으로 교체:
              Image.asset(
                'assets/images/job_complete_3d.png',
                width: 300,
                height: 300,
              ),

              const Spacer(flex: 1),

              // 메인 텍스트
              const Text(
                '일자리 카드 등록이 완료되었어요\n맞춤채용정보를 확인해보세요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),

              const Spacer(flex: 3),

              // 시작하기 버튼
              Consumer<JobViewModel>(
                builder: (context, jobViewModel, child) {
                  return ElevatedButton(
                    onPressed: jobViewModel.isLoading
                        ? null
                        : () async {
                            await _handleStartButton(context, jobViewModel);
                          },
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
                    child: jobViewModel.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            '맞춤 채용정보 시작하기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleStartButton(
    BuildContext context,
    JobViewModel jobViewModel,
  ) async {
    try {
      // 온보딩 완료 처리 (데이터 저장 및 추천 정보 로드)
      await jobViewModel.completeOnboarding();

      // 성공적으로 완료되면 메인 화면으로 이동
      if (context.mounted) {
        // 모든 온보딩 화면을 닫고 일자리 메인 화면으로 돌아가기
        Navigator.of(context).popUntil((route) => route.isFirst);

        // 성공 메시지 표시 (선택사항)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('맞춤 채용정보가 준비되었습니다!'),
            backgroundColor: Color(0xFF00BFFF),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // 에러 발생 시에도 메인 화면으로 이동 (더미 데이터로 표시)
      if (context.mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('일시적인 오류가 발생했지만 서비스를 이용할 수 있습니다.'),
            backgroundColor: Colors.orange.shade600,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
