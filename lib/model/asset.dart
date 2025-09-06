import 'package:flutter/material.dart';

class Asset {
  final String type;
  final String source;
  final int amount;
  final String accountNumber;
  final String imageUrl;

  const Asset({
    required this.type,
    required this.source,
    required this.accountNumber,
    required this.amount,
    required this.imageUrl,
  });

  static Asset fromJson(Map<String, dynamic> json) {
    final String assetType = json['assetType'];
    final String imageUrl;

    switch (assetType) {
      case 'DEPOSIT':
        imageUrl = "assets/images/icon_deposit.png";
        break;
      case 'SAVINGS':
        imageUrl = "assets/images/icon_savings.png";
        break;
      case 'STOCKS':
        imageUrl = "assets/images/icon_stocks.png";
        break;
      case 'SUBSCRIPTION':
        imageUrl = "assets/images/icon_subscription.png";
        break;
      case 'COIN':
        imageUrl = "assets/images/icon_coin.png";
        break;
      default:
        imageUrl = "assets/images/icon_savings.png";
        break;
    }
    return Asset(
      accountNumber: json['accountNumber'],
      source: json['bankName'],
      amount: json['amountKrw'],
      type: json['assetType'],
      imageUrl: imageUrl,
    );
  }
}
