import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/model/asset.dart';
import 'package:futurefinder_flutter/repository/asset_repository.dart';

class AssetViewModel extends ChangeNotifier {
  final AssetRepository _assetRepository;

  AssetViewModel(this._assetRepository);

  List<Asset> assets = [];

  Future<void> fetchData(String keyWord) async {
    fetchAssets(keyWord);
  }

  Future<void> fetchAssets(String keyWord) async {
    assets = await _assetRepository.getAssets();
    notifyListeners();
  }
}
