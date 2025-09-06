import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/model/bookmarked_item.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  // 북마크 목록을 상태로 관리
  final List<BookmarkedItem> _bookmarkedItems = [
    BookmarkedItem(
      term: 'GDP',
      fullName: '[Gross Domestic Product]',
      definition:
          '일정 기간 동안 한 나라 안에서 생산된 모든 재화와 서비스의 시장 가치 종합을 나타내는 경제 지표. 국가 경제의 규모와 성장 정도를 측정할 때 사용하며, 명목 GDP와 실질 GDP로 나누어 계산한다. 1인당 GDP는 국민 1인당 평균 경제 생산량을 의미하며, 생활 수준을 평가할 때 참고된다.',
    ),
    BookmarkedItem(
      term: '인플레이션',
      definition:
          '일정 기간 동안 재화와 서비스의 전반적인 가격 수준이 상승하는 현상을 의미하는 경제 지표. 화폐 가치가 하락하고, 생활비가 증가하는 것을 나타내며, 중앙은행의 금리 정책, 정부의 재정 정책 등 경제 전반에 큰 영향을 미친다.',
    ),
    // 다른 북마크 아이템들
  ];

  // 북마크를 제거하는 함수
  void _removeBookmark(BookmarkedItem item) {
    setState(() {
      _bookmarkedItems.remove(item);
    });

    // 사용자에게 스낵바로 피드백 제공 (선택 사항)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("'${item.term}' 북마크가 해제되었습니다."),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: const Text('북마크'),
        centerTitle: true,
      ),
      body: _bookmarkedItems.isEmpty
          ? const Center(
              child: Text(
                '북마크된 항목이 없습니다.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20.0),
              // 아이템 사이에 구분선을 자동으로 추가
              separatorBuilder: (context, index) => const Divider(height: 40),
              itemCount: _bookmarkedItems.length,
              itemBuilder: (context, index) {
                final item = _bookmarkedItems[index];
                return _buildBookmarkItem(item);
              },
            ),
    );
  }

  // 개별 북마크 아이템을 그리는 위젯
  Widget _buildBookmarkItem(BookmarkedItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Expanded를 사용하여 텍스트가 길어져도 아이콘이 밀려나지 않도록 함
            Expanded(
              // RichText를 사용하여 텍스트의 일부만 다른 스타일 적용
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: 'Pretendard',
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: item.term,
                      style: const TextStyle(
                        color: Color(0xFF00A3FF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (item.fullName != null)
                      TextSpan(
                        text: ' ${item.fullName}',
                        style: const TextStyle(
                          color: Color(0xFF00A3FF),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // 북마크 아이콘 버튼
            IconButton(
              // 아이콘 주변의 불필요한 여백 제거
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.bookmark,
                color: Color(0xFF00A3FF),
                size: 28,
              ),
              onPressed: () => _removeBookmark(item),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          item.definition,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 15,
            height: 1.6, // 줄 간격 조절
          ),
        ),
      ],
    );
  }
}
