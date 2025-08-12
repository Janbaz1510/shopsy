import 'package:flutter/foundation.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';

/// ProductProvider manages the state for product listing functionality
class ProductProvider with ChangeNotifier {
  /// Use case for fetching products from the domain layer
  final GetProducts getProducts;
  
  /// Private list of products - the actual state data
  List<Product> _products = [];
  
  /// Private loading state indicator
  bool _isLoading = false;

  /// Public getter for accessing the product list
  List<Product> get products => _products;
  
  /// Public getter for accessing the loading state
  bool get isLoading => _isLoading;

  /// Creates a new ProductProvider instance
  ProductProvider(this.getProducts);

  /// Fetches products from the data source and updates the state
  Future<void> fetchProducts() async {
    // Set loading state and notify UI to show loading indicator
    _isLoading = true;
    notifyListeners();

    // Fetch products from the domain layer (business logic)
    _products = await getProducts();

    // Clear loading state and notify UI to update with new data
    _isLoading = false;
    notifyListeners();
  }
}

