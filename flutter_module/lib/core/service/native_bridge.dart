import 'package:flutter/services.dart';

class NativeBridge {
  static const MethodChannel _channel = MethodChannel("app/payment");

  static Future<void> goToNative() async {
    try {
      await _channel.invokeMethod('goToNative');
    } on PlatformException catch (e) {
      print("Failed to go to native: ${e.message}");
    }
  }
}

class NativeBridgeIOS {
  static const platform = MethodChannel('com.example.app/payChannel');

  static Future<void> goToNative() async {
    try {
      final result = await platform.invokeMethod('payButtonPressed');
      print(result); // Should print: Native received payButtonPressed
    } on PlatformException catch (e) {
      print("Failed to send message to native: '${e.message}'.");
    }
  }
}
