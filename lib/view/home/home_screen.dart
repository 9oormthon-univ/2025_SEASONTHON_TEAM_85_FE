import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:futurefinder_flutter/viewmodel/auth_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AuthViewModel authViewModel;

  @override
  void initState() {
    super.initState();

    authViewModel = context.watch<AuthViewModel>();

    Future.microtask(() async {
      EasyLoading.show(status: '로딩 중...', maskType: EasyLoadingMaskType.black);
      try {
        await authViewModel.fetchData();
        EasyLoading.dismiss();
      } catch (e) {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          const SizedBox(height: 10),
          _buildSearchBar(),
          const SizedBox(height: 20),
          _buildNewsSection(),
          _buildDivider(),
          _buildStockSection(),
          _buildDivider(),
          _buildJobSection(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 8,
      color: const Color(0xFFE8EAEF),
      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        // 검색창
        Expanded(
          child: TextField(
            onTap: () {
              context.go('/home/search');
            },
            decoration: InputDecoration(
              hintText: '검색',
              suffixIcon: const Icon(Icons.search, color: Colors.black),
              filled: true,
              fillColor: const Color(0xFFF0F2F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8), // 간격
        const Icon(Icons.bookmark_border, color: Colors.grey),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Text(
              actionText,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ],
    );
  }

  Widget _buildNewsSection() {
    return Column(
      children: [
        _buildSectionHeader('경제뉴스', '더보기'),
        const SizedBox(height: 16),
        _buildNewsItem(
          title: '사이버 보안 비상… 전 금융권 내일부터 블라인드 모의해킹',
          source: '연합뉴스TV',
          time: '5분전',
        ),
        const SizedBox(height: 16),
        _buildNewsItem(
          title: '지방 건설 경기 악화… 5대 은행, 건설업 연체 대출 ‘급증’',
          source: '부산일보',
          time: '11분전',
        ),
      ],
    );
  }

  Widget _buildNewsItem({
    required String title,
    required String source,
    required String time,
  }) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                '$source · $time',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStockSection() {
    return Column(
      children: [
        _buildSectionHeader('실시간 주식현황', '다른 차트 더보기'),
        const SizedBox(height: 16),
        _buildStockItem(
          rank: '1',
          logoUrl: 'https://via.placeholder.com/40',
          name: '한탑',
          price: '52,700',
          change: '+12.8%',
          isPositive: true,
        ),
        const SizedBox(height: 16),
        _buildStockItem(
          rank: '2',
          logoUrl: 'https://via.placeholder.com/40',
          name: '한화오션',
          price: '117,800',
          change: '-4.5%',
          isPositive: false,
        ),
        const SizedBox(height: 16),
        _buildStockItem(
          rank: '3',
          logoUrl: 'https://via.placeholder.com/40',
          name: '두산 에너빌리티',
          price: '62,700',
          change: '+2.8%',
          isPositive: true,
        ),
      ],
    );
  }

  Widget _buildStockItem({
    required String rank,
    required String logoUrl,
    required String name,
    required String price,
    required String change,
    required bool isPositive,
  }) {
    final changeColor = isPositive ? Colors.red : Colors.blue;
    return Row(
      children: [
        Text(
          rank,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00E2E0),
          ),
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(logoUrl),
          backgroundColor: Colors.grey[200],
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  change,
                  style: TextStyle(color: changeColor, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFE8EAEF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: const Text(
            '주문',
            style: TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJobSection() {
    return Column(
      children: [
        _buildSectionHeader('금일 마감 채용공고', '전체 공고 보기'),
        const SizedBox(height: 16),
        _buildJobItem(
          tag: '인턴',
          tagColor: Colors.cyan.shade100,
          tagFontColor: Colors.cyan.shade800,
          company: '[삼성전자]',
          description: 'DX 부문 2025년 하반기 3급 신입사원 채용 공고',
        ),
        const SizedBox(height: 20),
        _buildJobItem(
          tag: '신입',
          tagColor: Colors.blue.shade100,
          tagFontColor: Colors.blue.shade800,
          company: '[롯데 면세점]',
          description: '2025년 9월 롯데면세점 신입사원 I\'M 전형',
        ),
        const SizedBox(height: 20),
        _buildJobItem(
          tag: '신입',
          tagColor: Colors.blue.shade100,
          tagFontColor: Colors.blue.shade800,
          company: '[웅진식품]',
          description: '2025년도 경영기획/영업/구매직무 채용',
        ),
      ],
    );
  }

  Widget _buildJobItem({
    required String tag,
    required Color tagColor,
    required Color tagFontColor,
    required String company,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 60,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: tagColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                tag,
                style: TextStyle(
                  color: tagFontColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'D-DAY',
                style: TextStyle(
                  color: tagFontColor.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
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
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        const Icon(Icons.star_border, color: Colors.grey, size: 28),
      ],
    );
  }
}
