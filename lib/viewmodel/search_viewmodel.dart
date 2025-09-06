import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/exception/api_exception.dart';
import 'package:futurefinder_flutter/model/search_result.dart';
import 'package:futurefinder_flutter/repository/search_repository.dart';

class SearchViewModel extends ChangeNotifier {
  final SearchRepository _searchRepository;

  SearchViewModel(this._searchRepository);

  SearchResult? _currentSearchResult;
  SearchResult? get currentSearchResult => _currentSearchResult;

  Future<void> fetchData(String keyWord) async {
    fetchCurrentSearchResult(keyWord);
  }

  Future<void> fetchCurrentSearchResult(String keyWord) async {
    try {
      _currentSearchResult = await _searchRepository.searchWord(keyWord);
    } on ApiException catch (e) {
      if (e.status == 404) {
        _currentSearchResult == null;
      } else {
        rethrow;
      }
    }
    notifyListeners();
  }
}
