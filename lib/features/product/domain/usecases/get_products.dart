import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Use case for retrieving all available products
class GetProducts {
  /// Repository dependency for data access
  final ProductRepository repository;

  /// Creates a new GetProducts use case instance
  GetProducts(this.repository);

  /// Executes the use case to retrieve all products
  Future<List<Product>> call() async {
    // Delegate to repository for data access
    return await repository.getProducts();
  }
}
