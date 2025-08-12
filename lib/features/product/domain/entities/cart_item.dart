import 'product.dart';

/// CartItem entity representing an item in the shopping cart
class CartItem {
  /// The product associated with this cart item
  final Product product;
  
  /// The quantity of this product in the cart
  int quantity;

  /// Creates a new CartItem instance
  CartItem({required this.product, this.quantity = 1});

  /// Calculates the total price for this cart item
  double get totalPrice => product.price * quantity;

  /// Returns a string representation of the cart item for debugging
  @override
  String toString() {
    return 'CartItem(product: ${product.title}, quantity: $quantity, totalPrice: $totalPrice)';
  }

  /// Checks if this cart item is equal to another object
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        other.product == product &&
        other.quantity == quantity;
  }

  /// Returns a hash code for this cart item
  @override
  int get hashCode {
    return product.hashCode ^ quantity.hashCode;
  }
}
