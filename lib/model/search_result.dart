class SearchResult {
  final String term;
  final String? fullName; // 예: [Gross Domestic Product]
  final String definition;
  bool isBookmarked; // 북마크 상태는 변경될 수 있으므로 final이 아님

  SearchResult({
    required this.term,
    this.fullName,
    required this.definition,
    this.isBookmarked = false,
  });
}
