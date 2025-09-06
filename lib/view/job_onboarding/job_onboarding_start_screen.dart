import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/view/job_onboarding/job_education_input_screen.dart';

class JobOnboardingStartScreen extends StatelessWidget {
  const JobOnboardingStartScreen({super.key});

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
                'assets/images/job_card_3d.png',
                width: 300,
                height: 300,
              ),

              const Spacer(flex: 1),

              // 메인 텍스트
              const Text(
                '취업관련정보를 입력하고 맞춤형\n일자리 추천을 받을 수 있어요',
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
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const JobEducationInputScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BFFF),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '시작하기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
