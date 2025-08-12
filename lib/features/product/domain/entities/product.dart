/// Product entity representing a product in the e-commerce application
class Product {
  /// Unique identifier for the product
  final int id;
  
  /// Product name/title
  final String title;
  
  /// Detailed product description
  final String description;
  
  /// Product price in the application's currency
  final double price;
  
  /// URL or path to the product image
  final String image;

  /// Creates a new Product instance
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
  });

  /// Returns a string representation of the product for debugging
  @override
  String toString() {
    return 'Product(id: $id, title: $title, price: $price)';
  }

  /// Checks if this product is equal to another object
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.price == price &&
        other.image == image;
  }

  /// Returns a hash code for this product
  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        price.hashCode ^
        image.hashCode;
  }
}
