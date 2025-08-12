import 'package:flutter/foundation.dart';
import 'package:shopsy/features/product/domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';

/// CartProvider manages the shopping cart state and functionality
class CartProvider with ChangeNotifier {
  /// Private map storing cart items with product ID as key
  final Map<int, CartItem> _items = {}; // productId -> CartItem

  /// Public getter for accessing all cart items as a list
  List<CartItem> get items => _items.values.toList();

  /// Calculates the total price of all items in the cart
  double get totalPrice {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  /// Adds a product to the cart or increases its quantity
  void addProduct(Product product) {
    if (_items.containsKey(product.id)) {
      // Product already exists - increment quantity
      _items[product.id]!.quantity += 1;
    } else {
      // Product doesn't exist - create new cart item
      _items[product.id] = CartItem(product: product, quantity: 1);
    }
    // Notify UI components of the cart change
    notifyListeners();
  }

  /// Decreases the quantity of a product in the cart
  void decreaseQuantity(int productId) {
    if (!_items.containsKey(productId)) return; // Product not in cart

    if (_items[productId]!.quantity > 1) {
      // Decrease quantity if more than 1
      _items[productId]!.quantity -= 1;
    } else {
      // Remove product if quantity would become 0
      _items.remove(productId);
    }
    // Notify UI components of the cart change
    notifyListeners();
  }

  /// Removes a product completely from the cart
  void removeProduct(int productId) {
    if (_items.containsKey(productId)) {
      _items.remove(productId);
      // Notify UI components of the cart change
      notifyListeners();
    }
  }

  /// Clears all items from the cart
  void clearCart() {
    _items.clear();
    // Notify UI components of the cart change
    notifyListeners();
  }
}


