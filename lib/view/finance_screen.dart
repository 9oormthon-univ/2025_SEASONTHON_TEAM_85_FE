import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/view/bottom_nav_bar.dart';
import 'package:futurefinder_flutter/view/jobs_screen.dart';
import 'package:futurefinder_flutter/view/settings_screen.dart';
import 'package:futurefinder_flutter/view/subscription_screen.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildAssetLinkCard(),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: '금융차트',
            subtitle: '내 또래의 금융 자산은 얼마일까요?',
            color: const Color(0xFFEEEDF8),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: '월별리포트',
            subtitle: '내 자산 변화를 리포트로 확인해보세요',
            color: const Color(0xFFF6F6F6),
          ),
        ],
      ),
    );
  }

  // 상단의 메인 카드 (자산 연결하기)
  Widget _buildAssetLinkCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE0FFFA), Color(0xFFD4F9F4)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '간편하게\n자산 연결하기',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '자산을 한눈에 관리할 수 있어요.',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // 이미지 대체 회색 박스
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00E5C0),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              '내 자산 등록하기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 중간, 하단의 정보 카드 (금융차트, 월별리포트)
  Widget _buildInfoCard({
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
          // 이미지 대체 회색 박스
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }
}
