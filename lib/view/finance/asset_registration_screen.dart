import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// 등록된 자산을 표현하기 위한 데이터 클래스
class Asset {
  final String type;
  final String source;
  final int amount;
  final IconData icon;

  const Asset({
    required this.type,
    required this.source,
    required this.amount,
    required this.icon,
  });
}

class AssetRegistrationScreen extends StatefulWidget {
  const AssetRegistrationScreen({super.key});

  @override
  State<AssetRegistrationScreen> createState() =>
      _AssetRegistrationScreenState();
}

class _AssetRegistrationScreenState extends State<AssetRegistrationScreen> {
  bool _isAssetTypeExpanded = false;
  bool _isFinancialInstitutionExpanded = false;
  String? _selectedAssetType;
  String? _selectedFinancialInstitution;

  final List<String> _assetTypes = ['예금', '적금', '주식', '청약', '코인', '기타'];
  final List<String> _financialInstitutions = [
    '농협은행',
    '신한은행',
    '우체국',
    '하나은행',
    'KB 국민은행',
    '카카오뱅크',
    '토스뱅크',
  ];

  // --- 새로 추가된 부분: 등록된 자산 더미 데이터 ---
  final List<Asset> _registeredAssets = [
    const Asset(
      type: '적금',
      source: '농협은행',
      amount: 103900,
      icon: Icons.savings_outlined,
    ),
    // 필요하다면 여기에 다른 자산을 추가할 수 있습니다.
    // const Asset(type: '예금', source: '카카오뱅크', amount: 1250000, icon: Icons.wallet_outlined),
  ];
  // ---

  void _onAssetTypeSelected(String type) {
    setState(() {
      _selectedAssetType = type;
      _isAssetTypeExpanded = false;
    });
  }

  void _onFinancialInstitutionSelected(String institution) {
    setState(() {
      _selectedFinancialInstitution = institution;
      _isFinancialInstitutionExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isCompleted =
        _selectedAssetType != null && _selectedFinancialInstitution != null;

    return Scaffold(
      // 이미지에 맞게 AppBar 추가
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: const Text(
          '자산등록',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      // 이미지에 맞게 배경색 추가
      backgroundColor: const Color(0xFFF8F9FA),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                // --- 새로 추가된 부분: 등록 카드와 목록을 함께 보여주기 위한 Column ---
                child: Column(
                  children: [
                    // 1. 기존 자산 등록 카드
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '자산을 등록해주세요',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildCustomDropdown(
                            isExpanded: _isAssetTypeExpanded,
                            selectedValue: _selectedAssetType,
                            hintText: '자산형태',
                            options: _assetTypes,
                            onSelected: _onAssetTypeSelected,
                            onToggle: () {
                              setState(() {
                                _isAssetTypeExpanded = !_isAssetTypeExpanded;
                                _isFinancialInstitutionExpanded = false;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildCustomDropdown(
                            isExpanded: _isFinancialInstitutionExpanded,
                            selectedValue: _selectedFinancialInstitution,
                            hintText: '금융사 선택',
                            options: _financialInstitutions,
                            onSelected: _onFinancialInstitutionSelected,
                            onToggle: () {
                              setState(() {
                                _isFinancialInstitutionExpanded =
                                    !_isFinancialInstitutionExpanded;
                                _isAssetTypeExpanded = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    // 2. 등록된 자산 목록
                    const SizedBox(height: 24),
                    _buildRegisteredAssetList(),
                  ],
                ),
                // ---
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isCompleted
                  ? () {
                      context.go('/finance/asset-verification');
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E5C0),
                disabledBackgroundColor: const Color(0xFFB2DFDB),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 0,
              ),
              child: const Text(
                '자산 연결하기',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 새로 추가된 부분: 등록된 자산 목록을 그리는 위젯 ---
  Widget _buildRegisteredAssetList() {
    // 등록된 자산이 없으면 아무것도 그리지 않음
    if (_registeredAssets.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: _registeredAssets
          .map((asset) => _buildRegisteredAssetItem(asset))
          .toList(),
    );
  }

  Widget _buildRegisteredAssetItem(Asset asset) {
    final numberFormat = NumberFormat('###,###,###');
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF2F45B5),
          foregroundColor: Colors.white,
          child: Icon(asset.icon),
        ),
        title: Text(
          asset.type,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          asset.source,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${numberFormat.format(asset.amount)}원',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
        onTap: () {},
      ),
    );
  }
  // ---

  Widget _buildCustomDropdown({
    required bool isExpanded,
    required String? selectedValue,
    required String hintText,
    required List<String> options,
    required Function(String) onSelected,
    required VoidCallback onToggle,
  }) {
    final textColor = selectedValue == null
        ? Colors.grey
        : const Color(0xFF00A3FF);

    return Column(
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedValue ?? hintText,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    fontWeight: selectedValue != null
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = selectedValue == option;
                return ListTile(
                  title: Text(option),
                  trailing: Icon(
                    isSelected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: isSelected
                        ? const Color(0xFF00A3FF)
                        : Colors.grey.shade300,
                  ),
                  onTap: () => onSelected(option),
                );
              },
            ),
          ),
      ],
    );
  }
}
