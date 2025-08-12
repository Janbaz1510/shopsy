import '../entities/product.dart';

/// Abstract interface for product data repository
abstract class ProductRepository {
  /// Retrieves all available products
  Future<List<Product>> getProducts();
}
