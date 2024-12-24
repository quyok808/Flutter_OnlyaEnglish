import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class ApiService {
  final String apiUrl = "https://192.168.1.9:7240/api/Product";

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }

  Future<Product> addProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(product.toJson()),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 201) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception("Failed to add product: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Failed to add product");
    }
  }

  Future<void> updateProduct(Product product) async {
    final response = await http.put(
      Uri.parse("$apiUrl/${product.id}"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception("Failed to update product");
    }
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse("$apiUrl/$id"));
    if (response.statusCode != 204) {
      throw Exception("Failed to delete product");
    }
  }
}
