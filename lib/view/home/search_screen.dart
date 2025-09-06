import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/model/search_result.dart';
import 'package:futurefinder_flutter/viewmodel/auth_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final AuthViewModel authViewModel;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_onSearchChanged);

    authViewModel = context.read<AuthViewModel>();

    Future.microtask(() async {
      try {
        await authViewModel.fetchData();
      } catch (e) {
        context.go('/login');
      }
    });
  }

  List<String> _recentSearches = ['GDP'];
  final List<String> _popularTerms = [
    '코스피',
    '코스닥',
    '환율',
    '금리',
    'GDP',
    '펀드',
    '리세션',
    '배당',
    '인플레이션',
  ];

  // --- 검색 결과 상태 관리를 위한 변수 추가 ---
  List<SearchResult> _searchResults = [];
  final List<SearchResult> _allTerms = [
    SearchResult(
      term: 'GDP',
      fullName: '[Gross Domestic Product]',
      definition: '일정 기간 동안 한 나라 안에서 생산된 모든 재화와 서비스의 시장 가치 종합을 나타내는 경제 지표.',
      isBookmarked: false,
    ),
    SearchResult(
      term: '인플레이션',
      definition: '일정 기간 동안 재화와 서비스의 전반적인 가격 수준이 상승하는 현상을 의미하는 경제 지표.',
      isBookmarked: true,
    ),
    SearchResult(
      term: '코스피',
      definition:
          '한국거래소의 유가증권시장에 상장된 회사들의 주식에 대한 총합인 시가총액의 기준시점과 비교시점을 비교하여 나타낸 지표.',
      isBookmarked: false,
    ),
  ];
  // ---

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // 검색어가 변경될 때마다 호출되는 함수
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = _allTerms.where((result) {
          return result.term.toLowerCase().contains(query) ||
              (result.fullName?.toLowerCase().contains(query) ?? false);
        }).toList();
      }
    });
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
        title: TextField(
          controller: _searchController,
          autofocus: true, // 화면 진입 시 자동으로 키보드 올라오게 설정
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
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border, size: 28),
            onPressed: () {
              context.go('/home/bookmark');
            },
          ),
        ],
      ),
      body: _searchController.text.isEmpty
          ? _buildInitialView() // 검색어가 없으면 초기 화면 표시
          : _buildSearchResultsView(), // 검색어가 있으면 결과 표시
    );
  }

  // 초기 화면 (최근 검색어, 인기 검색어)
  Widget _buildInitialView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '최근 검색 용어',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8.0,
            children: _recentSearches
                .map(
                  (term) => Chip(
                    label: Text(
                      term,
                      style: const TextStyle(color: Color(0xFF00A3FF)),
                    ),
                    backgroundColor: const Color(0xFFE0F7FA),
                    deleteIcon: const Icon(
                      Icons.close,
                      size: 16,
                      color: Color(0xFF00A3FF),
                    ),
                    onDeleted: () =>
                        setState(() => _recentSearches.remove(term)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide.none,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 32),
          const Text(
            '인기 경제 용어',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _popularTerms
                .map(
                  (term) => Chip(
                    label: Text(
                      term,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    backgroundColor: Colors.grey.shade100,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide.none,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  // 검색 결과 목록 화면
  Widget _buildSearchResultsView() {
    if (_searchResults.isEmpty) {
      return const Center(child: Text('검색 결과가 없습니다.'));
    }
    // ListView.separated는 아이템 사이에 구분선을 쉽게 추가할 수 있습니다.
    return ListView.separated(
      padding: const EdgeInsets.all(20.0),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return _buildSearchResultItem(result);
      },
    );
  }

  // 개별 검색 결과 아이템
  Widget _buildSearchResultItem(SearchResult result) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // RichText를 사용하여 텍스트 일부만 다른 스타일 적용
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'Pretendard',
                  ),
                  children: [
                    TextSpan(
                      text: result.term,
                      style: const TextStyle(
                        color: Color(0xFF00A3FF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (result.fullName != null)
                      TextSpan(
                        text: ' ${result.fullName}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                  ],
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  result.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: result.isBookmarked
                      ? const Color(0xFF00A3FF)
                      : Colors.grey,
                ),
                onPressed: () {
                  // 북마크 아이콘을 누르면 상태 변경
                  setState(() {
                    result.isBookmarked = !result.isBookmarked;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            result.definition,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
