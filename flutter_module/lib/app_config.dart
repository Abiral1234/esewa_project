// lib/app_config.dart
import 'package:flutter/material.dart';

class AppConfig extends ChangeNotifier {
  bool isDark = false;
  String sessionId = '';
  String fontFamily = '';
  double baseSize = 14.0;

  Map<String, dynamic>? lastPaymentResult;

  void updateFromMap(Map map) {
    if (map.containsKey('theme')) isDark = map['theme'] == 'dark';
    if (map.containsKey('sessionId')) sessionId = map['sessionId'];
    final typography = map['typography'] as Map?;
    if (typography != null) {
      fontFamily = typography['fontFamily'] ?? fontFamily;
      baseSize = (typography['baseSize'] ?? baseSize).toDouble();
    }
    notifyListeners();
  }

  void onPaymentResult(Map<String, dynamic>? args) {
    lastPaymentResult = args;
    // You can process/store or notify listeners
    notifyListeners();
  }
}
