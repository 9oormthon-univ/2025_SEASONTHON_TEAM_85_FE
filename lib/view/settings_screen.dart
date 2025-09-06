import 'dart:math' as math;

import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String userName = '홍길동'; // 실제로는 사용자 데이터에서 가져옴
    final String email = 'honggildong@example.com'; // 실제로는 사용자 데이터에서 가져옴
    final String phoneNumber = '010-1234-5678'; // 실제로는 사용자 데이터에서 가져옴

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      children: [
        const SizedBox(height: 24),
        _buildProfileSection(userName),
        const SizedBox(height: 24),
        _buildContactInfoBox(email, phoneNumber),
        const SizedBox(height: 32),
        _buildSectionHeader('계정'),
        _buildSettingsItem('아이디'),
        _buildSettingsItem('비밀번호'),
        const SizedBox(height: 24),
        _buildSectionHeader('이용안내'),
        _buildSettingsItem('알림 설정'),
        _buildSettingsItem('서비스 이용 약관'),
        _buildSettingsItem('개인정보처리방침'),
        _buildSettingsItem('고객센터'),
        const SizedBox(height: 24),
        _buildSectionHeader('기타'),
        _buildSettingsItem('로그아웃'),
        _buildSettingsItem('회원탈퇴'),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildProfileSection(String userName) {
    return Row(
      children: [
        // 프로필 아이콘 Placeholder
        Transform.rotate(
          angle: -math.pi / 12.0, // 아이콘을 살짝 기울임
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xFF63C5EA), Color(0xFF42A5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            userName,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Icon(Icons.settings_outlined, color: Colors.grey.shade400, size: 28),
      ],
    );
  }

  // 전화번호, 이메일 정보 박스
  Widget _buildContactInfoBox(String email, String phoneNumber) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildInfoTextField('전화번호', phoneNumber),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(height: 1, color: Colors.grey.shade200),
          ),
          _buildInfoTextField('이메일', email),
        ],
      ),
    );
  }

  // 정보 박스 내부의 텍스트 필드 스타일 행
  Widget _buildInfoTextField(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 60, // 레이블 너비 고정으로 정렬 맞춤
            child: Text(
              label,
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ),
          Text('|', style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 16)),
          SizedBox(width: 12),
          Text(value, style: TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  // '계정', '이용안내' 등 섹션 헤더
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  // 설정 메뉴 아이템
  Widget _buildSettingsItem(String title) {
    // ListTile은 설정 메뉴처럼 탭 가능한 리스트 아이템에 적합합니다.
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 16)),
      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
      onTap: () {
        debugPrint('$title tapped');
      },
    );
  }
}
