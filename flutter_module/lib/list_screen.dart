// lib/screens/list_screen.dart
import 'package:flutter/material.dart';
import '../app_config.dart';
import 'detail_screen.dart';
import 'package:flutter/services.dart';

final MethodChannel _paymentChannel = MethodChannel('app/payment');

class ListScreen extends StatelessWidget {
  final AppConfig config;

  ListScreen({required this.config});

  final items = List.generate(
      20, (i) => {'id': i, 'title': 'Item $i', 'price': (i + 1) * 10.0});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
        fontFamily: config.fontFamily.isNotEmpty ? config.fontFamily : null,
        fontSize: config.baseSize);
    return Scaffold(
      appBar: AppBar(title: Text('List', style: textStyle)),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, i) {
          final item = items[i];
          return ListTile(
            title: Text(item['title'].toString(), style: textStyle),
            subtitle: Text('Price: ${item['price']}', style: textStyle),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => DetailScreen(item: item, config: config),
            )),
          );
        },
      ),
    );
  }
}
