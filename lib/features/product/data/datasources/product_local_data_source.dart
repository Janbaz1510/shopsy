import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getProductsFromJson();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  @override
  Future<List<ProductModel>> getProductsFromJson() async {
    final jsonString = await rootBundle.loadString('assets/products.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => ProductModel.fromJson(json)).toList();
  }
}
