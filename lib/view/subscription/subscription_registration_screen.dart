import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:futurefinder_flutter/model/asset.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SubscriptionRegistrationScreen extends StatefulWidget {
  const SubscriptionRegistrationScreen({super.key});

  @override
  State<SubscriptionRegistrationScreen> createState() =>
      _SubscriptionRegistrationScreenState();
}

class _SubscriptionRegistrationScreenState
    extends State<SubscriptionRegistrationScreen> {
  // 입력 필드 상태 관리
  String? _selectedBank;
  final TextEditingController _amountController = TextEditingController();
  bool _isBankDropdownExpanded = false;

  // 더미 데이터
  final List<String> _banks = ['IBK기업은행', 'KB국민은행', '신한은행', '하나은행', '우리은행'];
  final List<Asset> _registeredAccounts = [
    const Asset(
      type: '청년 주택드림 청약통장',
      source: 'IBK기업은행',
      amount: 1239000,
      icon: Icons.account_balance_wallet,
    ),
    // 다른 청약 통장이 있다면 여기에 추가
  ];

  @override
  void initState() {
    super.initState();
    // 금액 입력 필드에 변경 감지 리스너 추가 (숫자 포맷팅용)
    _amountController.addListener(_formatAmount);

    _amountController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _amountController.removeListener(_formatAmount);
    _amountController.removeListener(() {
      setState(() {});
    });
    _amountController.dispose();
    super.dispose();
  }

  // 사용자가 숫자를 입력할 때마다 세 자리마다 쉼표를 찍어주는 함수
  void _formatAmount() {
    String text = _amountController.text.replaceAll(',', '');
    if (text.isEmpty) return;

    final number = int.tryParse(text);
    if (number != null) {
      final formattedText = NumberFormat('###,###,###').format(number);
      if (_amountController.text != formattedText) {
        _amountController.value = TextEditingValue(
          text: formattedText,
          selection: TextSelection.collapsed(offset: formattedText.length),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isInputCompleted =
        _selectedBank != null && _amountController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const Icon(Icons.arrow_back_ios),
        title: const Text('청약통장'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 1. 청약 통장 등록 카드
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
                                '청약 통장을 등록해주세요',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildBankDropdown(),
                          const SizedBox(height: 12),
                          _buildAmountTextField(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 2. 이미 등록된 자산이 있을 경우 목록 표시
                    _buildRegisteredAssetList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isInputCompleted
                  ? () {
                      context.go('/subscription/subscription-verification');
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F45B5),
                disabledBackgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 0,
              ),
              child: const Text(
                '청약통장 등록하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 금융사 선택 드롭다운 위젯
  Widget _buildBankDropdown() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isBankDropdownExpanded = !_isBankDropdownExpanded;
            });
          },
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
                  _selectedBank ?? '금융사',
                  style: TextStyle(
                    fontSize: 16,
                    color: _selectedBank != null
                        ? const Color(0xFF00A3FF)
                        : const Color(0xFF8B8B8D),
                    fontWeight: _selectedBank != null
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                Icon(
                  _isBankDropdownExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        if (_isBankDropdownExpanded)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _banks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_banks[index]),
                  onTap: () {
                    setState(() {
                      _selectedBank = _banks[index];
                      _isBankDropdownExpanded = false;
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  // 보유금액 입력 텍스트 필드
  Widget _buildAmountTextField() {
    return TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        hintText: '보유금액',
        hintStyle: const TextStyle(color: Color(0xFF8B8B8D)),
        filled: true,
        fillColor: Colors.white,
        suffixText: '원',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }

  // 등록된 자산 목록을 보여주는 위젯
  Widget _buildRegisteredAssetList() {
    if (_registeredAccounts.isEmpty) {
      return const SizedBox.shrink(); // 자산이 없으면 아무것도 안보여줌
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '등록된 청약통장',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ..._registeredAccounts
            .map((asset) => _buildRegisteredAssetItem(asset))
            .toList(),
      ],
    );
  }

  // 사용자가 제공한 위젯 함수
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
}
