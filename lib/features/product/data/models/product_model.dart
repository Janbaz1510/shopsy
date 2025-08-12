import '../../domain/entities/product.dart';

/// Data model for Product that extends the domain entity
class ProductModel extends Product {
  /// Creates a new ProductModel instance
  ProductModel({
    required int id,
    required String title,
    required String description,
    required double price,
    required String image,
  }) : super(
    id: id,
    title: title,
    description: description,
    price: price,
    image: image,
  );

  /// Factory constructor for creating ProductModel from JSON data
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      // Extract and validate product ID
      id: json['id'],
      // Extract product title
      title: json['title'],
      // Extract product description
      description: json['description'],
      // Extract and convert price to double (handles both int and double)
      price: (json['price'] as num).toDouble(),
      // Extract product image URL
      image: json['image'],
    );
  }
}
