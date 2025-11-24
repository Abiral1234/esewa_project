// lib/repositories/product_repository.dart
import 'dart:convert';
import 'package:flutter_module/features/items_list/data/model/product_model.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  final String baseUrl = 'https://fakestoreapi.com/products';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
