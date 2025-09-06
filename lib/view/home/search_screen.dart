import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:futurefinder_flutter/model/search_result.dart';
import 'package:futurefinder_flutter/viewmodel/auth_viewmodel.dart';
import 'package:futurefinder_flutter/viewmodel/search_viewmodel.dart';
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SearchViewModel searchViewModel = context.watch<SearchViewModel>();

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
          onSubmitted: (v) async {
            EasyLoading.show(
              status: "로딩 중...",
              maskType: EasyLoadingMaskType.black,
            );
            await searchViewModel.fetchCurrentSearchResult(v);
            EasyLoading.dismiss();
          },
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
      body: Column(
        children: [
          _buildSearchOptions(),
          SizedBox(height: 10),
          _buildSearchResultView(searchViewModel),
        ],
      ),
    );
  }

  // 검색 결과 목록 화면
  Widget _buildSearchResultView(SearchViewModel searchViewModel) {
    if (searchViewModel.currentSearchResult == null) {
      return const Center(child: Text('검색 결과가 없습니다.'));
    } else {
      return Expanded(
        child: SingleChildScrollView(
          child: _buildSearchResultItem(searchViewModel.currentSearchResult!),
        ),
      );
    }
  }

  Widget _buildSearchOptions() {
    return Padding(
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

  // 개별 검색 결과 아이템
  Widget _buildSearchResultItem(SearchResult result) {
    debugPrint(result.term);
    return Padding(
      padding: const EdgeInsets.all(20.0),
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
            result.meaning,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
