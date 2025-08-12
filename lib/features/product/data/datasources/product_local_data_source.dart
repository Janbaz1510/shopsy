import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product_model.dart';

/// Abstract interface for local product data source
abstract class ProductLocalDataSource {
  /// Retrieves products from the local JSON data source
  Future<List<ProductModel>> getProductsFromJson();
}

/// Implementation of ProductLocalDataSource for JSON file access
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  @override
  Future<List<ProductModel>> getProductsFromJson() async {
    // Load the JSON file from the assets directory
    final jsonString = await rootBundle.loadString('assets/products.json');
    
    // Parse the JSON string into a list of dynamic objects
    final List<dynamic> jsonList = json.decode(jsonString);
    
    // Convert each JSON object to a ProductModel instance
    return jsonList.map((json) => ProductModel.fromJson(json)).toList();
  }
}
