// lib/screens/detail_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module/core/service/native_bridge.dart';
import 'package:flutter_module/features/items_list/data/model/product_model.dart';
import '../../../../../app_config.dart';

final MethodChannel _paymentChannel = MethodChannel('app/payment');

class DetailScreen extends StatefulWidget {
  final Product item;
  final AppConfig config;
  DetailScreen({required this.item, required this.config});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String paymentStatus = '';

  Future<void> startPayment() async {
    if (Platform.isAndroid) {
      try {
        final args = {
          'amount': widget.item.price,
          'sessionId': widget.config.sessionId,
          'itemId': widget.item.id,
        };

        // _paymentChannel.invokeMethod('startPayment', args);
        NativeBridge.goToNative();
        // result will come back via the paymentResult handler in main -> AppConfig.onPaymentResult
      } on PlatformException catch (e) {
        setState(() => paymentStatus = 'error: ${e.message}');
      }
    } else {
      NativeBridgeIOS.goToNative();
    }
  }

  @override
  void initState() {
    super.initState();

    widget.config.addListener(_configListener);
  }

  void _configListener() {
    final res = widget.config.lastPaymentResult;
    if (res != null && mounted) {
      setState(() {
        paymentStatus = 'Payment: ${res['status']} tx:${res['transactionId']}';
      });
    }
  }

  @override
  void dispose() {
    widget.config.removeListener(_configListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
        fontFamily: widget.config.fontFamily.isNotEmpty
            ? widget.config.fontFamily
            : null,
        fontSize: widget.config.baseSize);
    return Scaffold(
      appBar: AppBar(title: Text(widget.item.title ?? '', style: textStyle)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: ${widget.item.price}', style: textStyle),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: startPayment, child: Text('Pay', style: textStyle)),
            SizedBox(height: 20),
            Text(paymentStatus, style: textStyle),
          ],
        ),
      ),
    );
  }
}
