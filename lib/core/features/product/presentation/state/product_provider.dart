import 'package:flutter/foundation.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';

class ProductProvider with ChangeNotifier {
  final GetProducts getProducts;
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  ProductProvider(this.getProducts);

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    _products = await getProducts();

    _isLoading = false;
    notifyListeners();
  }
}

