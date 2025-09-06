class SearchResult {
  final String term;
  final String meaning;
  bool isBookmarked; // 북마크 상태는 변경될 수 있으므로 final이 아님

  SearchResult({
    required this.term,
    required this.meaning,
    this.isBookmarked = false,
  });

  static SearchResult fromJson(Map<String, dynamic> json) {
    return SearchResult(term: json['term'], meaning: json['meaning']);
  }
}
