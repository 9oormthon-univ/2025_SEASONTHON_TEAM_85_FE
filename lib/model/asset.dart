import 'package:flutter/material.dart';

class Asset {
  final String type;
  final String source;
  final int amount;
  final IconData icon;

  const Asset({
    required this.type,
    required this.source,
    required this.amount,
    required this.icon,
  });
}
