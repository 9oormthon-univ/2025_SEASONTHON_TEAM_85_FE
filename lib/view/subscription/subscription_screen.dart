import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/model/asset.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool hasSubscriptionAccount = false; // 더미 데이터: 청약통장 보유 여부
  final mySubscription = const Asset(
    // 더미 자산 데이터
    type: '청년 주택드림 청약통장',
    source: 'IBK기업은행',
    amount: 123900,
    icon: Icons.account_balance,
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        const SizedBox(height: 8),
        // hasSubscriptionAccount 값에 따라 다른 카드를 보여줌
        if (hasSubscriptionAccount)
          _buildMySubscriptionCard(context, mySubscription) // 자산이 있을 때
        else
          _buildInfoCard(context), // 자산이 없을 때

        const SizedBox(height: 16),
        _buildChatbotCard(context),
        const SizedBox(height: 32),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            '청약상품',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        _buildProductCard(
          title: '청년 주택드림 청약통장',
          subtitle: '청년의 주거안정과 목돈마련 기회를 제공하는 청약상품',
          interestRate: '연 3.12% - 4.20%',
        ),
        const SizedBox(height: 12),
        _buildProductCard(
          title: '주택청약종합저축',
          subtitle: '주택청약자격을 부여하는 상품',
          interestRate: '연 3.10%',
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Text('자산 보유 여부 (더미 데이터)'),
            const SizedBox(width: 8),
            Switch(
              value: hasSubscriptionAccount,
              onChanged: (value) {
                setState(() {
                  hasSubscriptionAccount = value;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  // --- 새로 추가된 위젯: 등록된 청약통장 카드 ---
  Widget _buildMySubscriptionCard(BuildContext context, Asset asset) {
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
                '홍길동님의 청약통장',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings, color: Colors.white70),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            asset.source,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '${numberFormat.format(asset.amount)}원',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '매월 10만원 / 12회차',
                style: TextStyle(color: Colors.white),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C7E4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                ),
                child: const Text('송금'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // ---

  // 기존 '청약 정보 등록하기' 카드
  Widget _buildInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '청약 정보\n등록하기',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '청약정보를 한눈에 관리할 수 있어요.',
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
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.go('/subscription/interest-area'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2F45B5),
              minimumSize: const Size(double.infinity, 52),
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

  // 챗봇 카드
  Widget _buildChatbotCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        // 전체를 버튼으로 만들기 위해 InkWell로 감싸기
        borderRadius: BorderRadius.circular(20), // 물결 효과도 둥글게
        onTap: () => context.go('/subscription/subscription-chatbot'),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '청약챗봇에게 질문하세요',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  '내가 받을 수 있는 청약정보는?',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 청약 상품 카드
  Widget _buildProductCard({
    required String title,
    required String subtitle,
    required String interestRate,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontFamily: 'Pretendard',
                ),
                children: [
                  const TextSpan(text: '최고 '),
                  TextSpan(
                    text: interestRate,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F45B5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
