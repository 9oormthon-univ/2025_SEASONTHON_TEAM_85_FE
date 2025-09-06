import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/model/asset.dart';
import 'package:futurefinder_flutter/viewmodel/asset_viewmodel.dart';
import 'package:futurefinder_flutter/viewmodel/auth_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  late final AuthViewModel authViewModel;

  @override
  void initState() {
    super.initState();

    authViewModel = context.read<AuthViewModel>();

    Future.microtask(() async {
      try {
        await authViewModel.fetchData();
      } catch (e) {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final assetViewModel = context.watch<AssetViewModel>();

    return Scaffold(
      // Scaffold의 배경색을 이미지와 유사하게 변경
      backgroundColor: const Color(0xFFF6F6F6),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // assetViewModel.assets.isNotEmpty 값에 따라 다른 위젯을 보여줌
          if (assetViewModel.assets.isNotEmpty)
            _buildMyAssetsView(context, assetViewModel) // 자산이 있을 때의 UI
          else
            _buildAssetLinkCard(context), // 자산이 없을 때의 UI

          const SizedBox(height: 16),
          _buildInfoCard(
            title: '금융차트',
            subtitle: '내 또래의 금융 자산은 얼마일까요?',
            color: const Color(0xFFD7E5FF), // 배경색에 맞춰 흰색으로 변경
            // 회색 박스 대신 이미지에 있는 아이콘으로 대체
            iconPlaceholder: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEDF8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.bar_chart, color: Color(0xFF6d61e7)),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: '월별리포트',
            subtitle: '내 자산 변화를 리포트로 확인해보세요',
            color: Colors.white, // 배경색에 맞춰 흰색으로 변경
            iconPlaceholder: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEDF8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.wallet, color: Color(0xFF6d61e7)),
            ),
          ),
          Row(
            children: [
              const Text('자산 보유 여부 (더미 데이터)'),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  // --- 아래부터는 자산이 있을 때 보여줄 위젯들 ---

  Widget _buildMyAssetsView(
    BuildContext context,
    AssetViewModel assetViewModel,
  ) {
    return Column(
      children: [
        _buildMyAssetsCard(context),
        const SizedBox(height: 16),
        _buildAssetList(assetViewModel),
      ],
    );
  }

  // 상단의 파란색 '나의 자산' 카드
  Widget _buildMyAssetsCard(BuildContext context) {
    final numberFormat = NumberFormat('###,###,###');
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2F45B5), Color(0xFF1A2A7A)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '나의 자산',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '홍길동님의 현재 자산',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            '${numberFormat.format(272856)}원',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C7E4),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: const Text('자산 보러가기'),
            ),
          ),
        ],
      ),
    );
  }

  // 개별 자산 목록
  Widget _buildAssetList(AssetViewModel assetViewModel) {
    return Column(
      children: [
        for (Asset asset in assetViewModel.assets) _buildAssetItem(asset),
      ],
    );
  }

  // 개별 자산 리스트 아이템
  Widget _buildAssetItem(Asset asset) {
    final numberFormat = NumberFormat('###,###,###');
    return ListTile(
      leading: Image.asset(asset.imageUrl),
      title: Text(
        asset.type,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(asset.source, style: const TextStyle(color: Colors.grey)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${numberFormat.format(asset.amount)}원',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
      onTap: () {},
    );
  }

  // --- 기존 코드 (자산이 없을 때) ---
  Widget _buildAssetLinkCard(BuildContext context) {
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
            onPressed: () => context.go('/finance/asset-registration'),
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

  // 정보 카드 (금융차트, 월별리포트)
  Widget _buildInfoCard({
    required String title,
    required String subtitle,
    required Color color,
    Widget? iconPlaceholder, // iconPlaceholder를 받을 수 있도록 수정
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
          // iconPlaceholder가 있으면 그것을, 없으면 기존의 회색 박스를 보여줌
          iconPlaceholder ??
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
