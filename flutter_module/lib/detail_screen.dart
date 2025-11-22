// lib/screens/detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_config.dart';

final MethodChannel _paymentChannel = MethodChannel('app/payment');

class DetailScreen extends StatefulWidget {
  final Map item;
  final AppConfig config;
  DetailScreen({required this.item, required this.config});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String paymentStatus = '';

  Future<void> startPayment() async {
    try {
      final args = {
        'amount': widget.item['price'],
        'sessionId': widget.config.sessionId,
        'itemId': widget.item['id'],
      };
      await _paymentChannel.invokeMethod('startPayment', args);
      // result will come back via the paymentResult handler in main -> AppConfig.onPaymentResult
    } on PlatformException catch (e) {
      setState(() => paymentStatus = 'error: ${e.message}');
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
      appBar: AppBar(title: Text(widget.item['title'], style: textStyle)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: ${widget.item['price']}', style: textStyle),
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
