import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/view/bottom_nav_bar.dart';
import 'package:futurefinder_flutter/view/finance_screen.dart';
import 'package:futurefinder_flutter/view/settings_screen.dart';
import 'package:futurefinder_flutter/view/subscription_screen.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '일자리',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildMyInfoCard(),
          const SizedBox(height: 30),
          _buildSectionHeader(title: '모집중인 인턴 공고'),
          const SizedBox(height: 16),
          _buildRecommendedJobItem(
            company: '[MISO]',
            title: '사업운영 인턴, Operations Intern',
            tag: '인턴',
            dDay: 'D-23',
          ),
          _buildRecommendedJobItem(
            company: '[삼성전자]',
            title: 'DX 부문 인턴 채용',
            tag: '인턴',
            dDay: 'D-20',
          ),
          _buildRecommendedJobItem(
            company: '[삼성전자]',
            title: 'DX 부문 인턴 채용',
            tag: '인턴',
            dDay: 'D-20',
          ),
          const SizedBox(height: 30),
          _buildSectionHeader(title: 'AI 매치 채용 공고'),
          const SizedBox(height: 16),
          _buildAiJobGrid(),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FinanceScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SubscriptionScreen(),
              ),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Text.rich(
        TextSpan(
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            height: 1.4,
            color: Colors.black,
          ),
          children: [
            TextSpan(text: '홍길동님을 위한\n맞춤 채용 정보를 추천드려요'),
            TextSpan(text: '💡'),
          ],
        ),
      ),
    );
  }

  Widget _buildMyInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.cyan.shade200, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF63C5EA), Color(0xFF42A5F5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Text(
                  '내 정보',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(Icons.more_horiz, color: Colors.grey.shade400),
            ],
          ),
          const SizedBox(height: 16),
          _buildCardInfoRow(label: '학력', value: '연세대학교 경영학과'),
          const SizedBox(height: 8),
          _buildCardInfoRow(label: '활동', value: '인턴경험'),
        ],
      ),
    );
  }

  Widget _buildCardInfoRow({required String label, required String value}) {
    return Row(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        const SizedBox(width: 8),
        Text('|', style: TextStyle(color: Colors.grey[300])),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Text(
              '전체보기',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[600], size: 20),
          ],
        ),
      ],
    );
  }

  Widget _buildRecommendedJobItem({
    required String company,
    required String title,
    required String tag,
    required String dDay,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Column(
            children: [
              _buildTag(tag, Colors.cyan.shade50, Colors.cyan.shade600),
              const SizedBox(height: 4),
              _buildTag(dDay, Colors.grey.shade200, Colors.grey.shade700),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          Icon(Icons.star_border_outlined, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      width: 50,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAiJobGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.75,
      children: [
        _buildAiJobCard(
          title: 'SQA인턴 상시채용',
          company: '에스케이인텔릭스(주)',
          location: '서울 전체',
        ),
        _buildAiJobCard(
          title: '서비스 공채 신입사원 모집',
          company: '삼성전자(주)',
          location: '서울 서초구',
        ),
        _buildAiJobCard(
          title: '3분기 경력 및 신입사원 채용',
          company: '쿠쿠홈시스(주)',
          location: '경기 시흥시',
        ),
        _buildAiJobCard(
          title: '정규직 채용',
          company: '대명에너지(주)',
          location: '서울 강남구',
        ),
      ],
    );
  }

  Widget _buildAiJobCard({
    required String title,
    required String company,
    required String location,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.star_border_outlined,
                color: Colors.grey.shade400,
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              company,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              location,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
