import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubscriptionVerificationScreen extends StatefulWidget {
  const SubscriptionVerificationScreen({super.key});

  @override
  State<SubscriptionVerificationScreen> createState() =>
      _SubscriptionVerificationScreenState();
}

class _SubscriptionVerificationScreenState
    extends State<SubscriptionVerificationScreen> {
  // 화면 상태를 관리하는 변수 (true: 완료 화면, false: 확인 화면)
  bool _isRegistrationComplete = false;

  // 더미 데이터
  final String _bankNameAndAccount = 'IBK기업은행 354-123534-1243';
  final int _assetAmount = 123900;
  final String _financialInstitution = 'IBK 기업은행';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 상태에 따라 AppBar 타이틀과 배경색 변경
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back_ios),
        title: Text(_isRegistrationComplete ? '' : '자산일치여부'),
        backgroundColor: _isRegistrationComplete
            ? Colors.white
            : const Color(0xFFF8F9FA),
      ),
      backgroundColor: _isRegistrationComplete
          ? Colors.white
          : const Color(0xFFF8F9FA),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 화면의 메인 콘텐츠 영역
            Expanded(
              child: _isRegistrationComplete
                  ? _buildCompletionView() // 등록 완료 화면
                  : _buildVerificationView(), // 자산 확인 화면
            ),
            const SizedBox(height: 20),
            // 하단 버튼
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  // 자산 확인 화면 UI
  Widget _buildVerificationView() {
    final numberFormat = NumberFormat('###,###,###');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        Text(
          _bankNameAndAccount,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Text(
          '${numberFormat.format(_assetAmount)}원',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        _buildDetailItem(
          icon: Icons.account_balance,
          iconColor: const Color(0xFF2F45B5),
          label: _financialInstitution,
          value: '금융사',
        ),
        const Spacer(), // 남은 공간을 모두 차지하여 하단 텍스트를 밑으로 밀어냄
        Text(
          '청약정보를 확인해주세요',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  // 자산 확인 화면의 상세 정보 아이템
  Widget _buildDetailItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.1),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: Text(
        value,
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  // 등록 완료 화면 UI
  Widget _buildCompletionView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 이미지 대체용 컨테이너
          Container(
            width: 220,
            height: 220,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0xFFD4F9F4), // 중심 색상
                  Color(0xFFF8F9FA), // 바깥 색상
                ],
                stops: [0.6, 1.0],
              ),
            ),
            child: Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.architecture,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            '청약등록이 완료되었습니다',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // 하단 액션 버튼 (상태에 따라 텍스트와 기능 변경)
  Widget _buildActionButton() {
    return ElevatedButton(
      onPressed: () {
        if (_isRegistrationComplete) {
          if (Navigator.canPop(context)) Navigator.pop(context);
        } else {
          // 확인 화면에서는 상태를 변경하여 완료 화면을 보여줌
          setState(() {
            _isRegistrationComplete = true;
          });
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2F45B5),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 0,
      ),
      child: Text(
        '확인했어요',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
