import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AssetVerificationScreen extends StatefulWidget {
  const AssetVerificationScreen({super.key});

  @override
  State<AssetVerificationScreen> createState() =>
      _AssetVerificationScreenState();
}

class _AssetVerificationScreenState extends State<AssetVerificationScreen> {
  // 화면 상태를 관리하는 변수 (true: 완료 화면, false: 확인 화면)
  bool _isRegistrationComplete = false;

  // 더미 데이터
  final String _bankNameAndAccount = '농협중앙회 354-123534-1243';
  final int _assetAmount = 103900;
  final String _assetType = '적금';
  final String _financialInstitution = '농협은행';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            // 뒤로가기 동작 (필요에 따라 GoRouter 사용)
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              debugPrint('Cannot pop');
            }
          },
        ),
        title: Text(
          _isRegistrationComplete ? '' : '자산일치여부',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ), // 완료 화면에서는 타이틀 없음
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: _isRegistrationComplete
                    ? _buildCompletionContent() // 등록 완료 화면
                    : _buildVerificationContent(), // 자산 확인 화면
              ),
            ),
            const SizedBox(height: 20),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  // 자산 확인 화면의 내용
  Widget _buildVerificationContent() {
    final numberFormat = NumberFormat('###,###,###');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        // 자산 종류
        _buildAssetDetailItem(
          icon: Icons.credit_card, // 이미지에 보이는 아이콘과 유사하게 변경
          iconColor: const Color(0xFF2F45B5),
          label: _assetType,
          value: '자산형태',
        ),
        const Divider(height: 32, thickness: 1, color: Color(0xFFF0F0F0)),
        // 금융사 종류
        _buildAssetDetailItem(
          icon: Icons.account_balance_rounded, // 이미지에 보이는 아이콘과 유사하게 변경
          iconColor: const Color(0xFF6dd600), // 농협 색상에 가깝게
          label: _financialInstitution,
          value: '금융사',
        ),
        const SizedBox(height: 80), // 하단 버튼과의 간격 조절
        Align(
          alignment: Alignment.center,
          child: Text(
            '자산정보를 확인해주세요',
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
          ),
        ),
      ],
    );
  }

  // 등록 완료 화면의 내용
  Widget _buildCompletionContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 이미지 대체용 컨테이너 (실제 이미지 사용 시 Image.asset 또는 Image.network)
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE0F7FA), // 배경 원 색상
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 두 번째 이미지의 배경 원들
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(0.1),
                  ),
                ),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(0.05),
                  ),
                ),
                // 더미 이미지 (두 개의 카드와 사람 아이콘)
                Positioned(
                  left: 20,
                  top: 60,
                  child: Transform.rotate(
                    angle: -0.2, // 살짝 기울이기
                    child: Container(
                      width: 80,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 50,
                  child: Transform.rotate(
                    angle: 0.1, // 살짝 기울이기
                    child: Container(
                      width: 80,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                // 가운데 흰색 카드 (더미)
                Positioned(
                  top: 70,
                  child: Container(
                    width: 70,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            '자산등록이 완료되었습니다',
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

  // 자산 상세 정보 항목 위젯
  Widget _buildAssetDetailItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.1),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Text(value, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }

  // 하단의 확인 버튼
  Widget _buildActionButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          // 버튼을 누르면 상태를 토글
          if (_isRegistrationComplete) {
            // 완료 화면에서 뒤로 돌아갈 때는 이전 화면으로 이동
            Navigator.of(context).pop();
          } else {
            _isRegistrationComplete = !_isRegistrationComplete;
          }
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2F45B5),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 0,
      ),
      child: const Text(
        '확인했어요',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
