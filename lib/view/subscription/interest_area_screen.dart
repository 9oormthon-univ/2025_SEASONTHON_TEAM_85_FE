import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InterestAreaScreen extends StatefulWidget {
  const InterestAreaScreen({super.key});

  @override
  State<InterestAreaScreen> createState() => _InterestAreaScreenState();
}

class _InterestAreaScreenState extends State<InterestAreaScreen> {
  // 각 드롭다운의 선택된 값을 저장할 상태 변수
  String? _selectedSido;
  String? _selectedSigungu;
  String? _selectedEupmyeondong;

  // 어떤 드롭다운이 확장되었는지 관리하는 상태 변수 (0: 시/도, 1: 시/군/구, 2: 읍/면/동)
  int? _expandedDropdownIndex;

  // --- 더미 데이터 (실제 앱에서는 API를 통해 가져와야 합니다) ---
  final List<String> _sidoList = ['서울특별시', '경기도', '충청남도', '경상북도', '전라남도'];
  final Map<String, List<String>> _sigunguMap = {
    '서울특별시': ['강남구', '서초구', '송파구', '마포구'],
    '경기도': ['수원시', '성남시', '용인시', '고양시'],
    '충청남도': ['천안시 동남구', '천안시 서북구', '아산시', '공주시'],
    '경상북도': ['포항시', '구미시', '경주시', '안동시'],
    '전라남도': ['목포시', '여수시', '순천시', '나주시'],
  };
  final Map<String, List<String>> _eupmyeondongMap = {
    '천안시 서북구': ['성정동', '두정동', '불당동', '백석동'],
    '강남구': ['역삼동', '논현동', '삼성동', '대치동'],
  };
  // ---

  @override
  Widget build(BuildContext context) {
    // 모든 지역이 선택되었는지 확인
    final isCompleted =
        _selectedSido != null &&
        _selectedSigungu != null &&
        _selectedEupmyeondong != null;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          '관심지역등록',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '관심있는 지역을 선택해주세요',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // 시/도 선택 드롭다운
                    _buildCustomDropdown(
                      index: 0,
                      selectedValue: _selectedSido,
                      hintText: '시/도 선택',
                      options: _sidoList,
                      onSelected: (value) {
                        setState(() {
                          _selectedSido = value;
                          // 상위 지역 변경 시 하위 지역 선택 초기화
                          _selectedSigungu = null;
                          _selectedEupmyeondong = null;
                          _expandedDropdownIndex = null;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    // 시/군/구 선택 드롭다운
                    _buildCustomDropdown(
                      index: 1,
                      selectedValue: _selectedSigungu,
                      hintText: '시/군/구 선택',
                      // 이전 선택에 따라 옵션이 동적으로 변경됨
                      options: _selectedSido != null
                          ? _sigunguMap[_selectedSido] ?? []
                          : [],
                      isEnabled: _selectedSido != null, // 시/도가 선택되어야 활성화
                      onSelected: (value) {
                        setState(() {
                          _selectedSigungu = value;
                          _selectedEupmyeondong = null;
                          _expandedDropdownIndex = null;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    // 읍/면/동 선택 드롭다운
                    _buildCustomDropdown(
                      index: 2,
                      selectedValue: _selectedEupmyeondong,
                      hintText: '읍/면/동 선택',
                      options: _selectedSigungu != null
                          ? _eupmyeondongMap[_selectedSigungu] ?? []
                          : [],
                      isEnabled: _selectedSigungu != null, // 시/군/구가 선택되어야 활성화
                      onSelected: (value) {
                        setState(() {
                          _selectedEupmyeondong = value;
                          _expandedDropdownIndex = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isCompleted
                  ? () {
                      context.go('/subscription/subscription-registration');
                    }
                  : null, // 모든 선택이 완료되면 활성화
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
                '관심지역 선택하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 재사용 가능한 커스텀 드롭다운 위젯
  Widget _buildCustomDropdown({
    required int index,
    required String? selectedValue,
    required String hintText,
    required List<String> options,
    required ValueChanged<String> onSelected,
    bool isEnabled = true,
  }) {
    bool isExpanded = _expandedDropdownIndex == index;
    final hintColor = isEnabled ? Colors.grey : Colors.grey.shade400;

    return Column(
      children: [
        GestureDetector(
          onTap: isEnabled
              ? () {
                  setState(() {
                    _expandedDropdownIndex = isExpanded ? null : index;
                  });
                }
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isEnabled ? Colors.white : const Color(0xFFF5F5F5),
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
                    color: selectedValue != null ? Colors.black : hintColor,
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: isEnabled ? Colors.grey : Colors.grey.shade400,
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
            constraints: const BoxConstraints(maxHeight: 200), // 리스트 최대 높이 제한
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (context, idx) {
                return ListTile(
                  title: Text(options[idx]),
                  onTap: () => onSelected(options[idx]),
                );
              },
            ),
          ),
      ],
    );
  }
}
