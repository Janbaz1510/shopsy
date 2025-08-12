import 'package:flutter_test/flutter_test.dart';
import 'package:shopsy/features/product/domain/entities/cart_item.dart';
import 'package:shopsy/features/product/domain/entities/product.dart';
import 'package:shopsy/features/product/presentation/state/cart_provider.dart';

void main() {
  group('CartProvider', () {
    late CartProvider provider;
    late Product testProduct1;
    late Product testProduct2;

    setUp(() {
      provider = CartProvider();
      testProduct1 = Product(
        id: 1,
        title: 'Test Product 1',
        description: 'Test Description 1',
        price: 29.99,
        image: 'https://example.com/image1.jpg',
      );
      testProduct2 = Product(
        id: 2,
        title: 'Test Product 2',
        description: 'Test Description 2',
        price: 39.99,
        image: 'https://example.com/image2.jpg',
      );
    });

    test('should initialize with empty cart', () {
      // Assert
      expect(provider.items, isEmpty);
      expect(provider.totalPrice, equals(0.0));
    });

    test('should add product to cart', () {
      // Act
      provider.addProduct(testProduct1);

      // Assert
      expect(provider.items, hasLength(1));
      expect(provider.items.first.product, equals(testProduct1));
      expect(provider.items.first.quantity, equals(1));
      expect(provider.totalPrice, equals(29.99));
    });

    test('should increase quantity when adding same product again', () {
      // Arrange
      provider.addProduct(testProduct1);

      // Act
      provider.addProduct(testProduct1);

      // Assert
      expect(provider.items, hasLength(1));
      expect(provider.items.first.quantity, equals(2));
      expect(provider.totalPrice, equals(29.99 * 2));
    });

    test('should add different products separately', () {
      // Act
      provider.addProduct(testProduct1);
      provider.addProduct(testProduct2);

      // Assert
      expect(provider.items, hasLength(2));
      expect(provider.items.first.product, equals(testProduct1));
      expect(provider.items.first.quantity, equals(1));
      expect(provider.items.last.product, equals(testProduct2));
      expect(provider.items.last.quantity, equals(1));
      expect(provider.totalPrice, equals(29.99 + 39.99));
    });

    test('should decrease quantity when product quantity is greater than 1', () {
      // Arrange
      provider.addProduct(testProduct1);
      provider.addProduct(testProduct1); // quantity = 2

      // Act
      provider.decreaseQuantity(testProduct1.id);

      // Assert
      expect(provider.items, hasLength(1));
      expect(provider.items.first.quantity, equals(1));
      expect(provider.totalPrice, equals(29.99));
    });

    test('should remove product when quantity becomes 0', () {
      // Arrange
      provider.addProduct(testProduct1); // quantity = 1

      // Act
      provider.decreaseQuantity(testProduct1.id);

      // Assert
      expect(provider.items, isEmpty);
      expect(provider.totalPrice, equals(0.0));
    });

    test('should not decrease quantity for non-existent product', () {
      // Arrange
      provider.addProduct(testProduct1);

      // Act
      provider.decreaseQuantity(999); // non-existent product ID

      // Assert
      expect(provider.items, hasLength(1));
      expect(provider.items.first.quantity, equals(1));
      expect(provider.totalPrice, equals(29.99));
    });

    test('should remove product by ID', () {
      // Arrange
      provider.addProduct(testProduct1);
      provider.addProduct(testProduct2);

      // Act
      provider.removeProduct(testProduct1.id);

      // Assert
      expect(provider.items, hasLength(1));
      expect(provider.items.first.product, equals(testProduct2));
      expect(provider.totalPrice, equals(39.99));
    });

    test('should not remove non-existent product', () {
      // Arrange
      provider.addProduct(testProduct1);

      // Act
      provider.removeProduct(999); // non-existent product ID

      // Assert
      expect(provider.items, hasLength(1));
      expect(provider.items.first.product, equals(testProduct1));
      expect(provider.totalPrice, equals(29.99));
    });

    test('should clear cart', () {
      // Arrange
      provider.addProduct(testProduct1);
      provider.addProduct(testProduct2);

      // Act
      provider.clearCart();

      // Assert
      expect(provider.items, isEmpty);
      expect(provider.totalPrice, equals(0.0));
    });

    test('should calculate total price correctly with multiple items', () {
      // Arrange
      provider.addProduct(testProduct1); // 29.99
      provider.addProduct(testProduct1); // 29.99 * 2
      provider.addProduct(testProduct2); // 39.99

      // Act
      final totalPrice = provider.totalPrice;

      // Assert
      expect(totalPrice, equals(29.99 * 2 + 39.99));
    });

    test('should handle products with zero price', () {
      // Arrange
      final freeProduct = Product(
        id: 3,
        title: 'Free Product',
        description: 'Free Description',
        price: 0.0,
        image: 'https://example.com/free.jpg',
      );

      // Act
      provider.addProduct(freeProduct);
      provider.addProduct(freeProduct); // quantity = 2

      // Assert
      expect(provider.items, hasLength(1));
      expect(provider.items.first.quantity, equals(2));
      expect(provider.totalPrice, equals(0.0));
    });

    test('should handle products with negative price', () {
      // Arrange
      final discountedProduct = Product(
        id: 4,
        title: 'Discounted Product',
        description: 'Discounted Description',
        price: -5.0,
        image: 'https://example.com/discounted.jpg',
      );

      // Act
      provider.addProduct(discountedProduct);
      provider.addProduct(discountedProduct); // quantity = 2

      // Assert
      expect(provider.items, hasLength(1));
      expect(provider.items.first.quantity, equals(2));
      expect(provider.totalPrice, equals(-10.0));
    });

    test('should handle products with very high price', () {
      // Arrange
      final expensiveProduct = Product(
        id: 5,
        title: 'Expensive Product',
        description: 'Very expensive',
        price: 999999.99,
        image: 'https://example.com/expensive.jpg',
      );

      // Act
      provider.addProduct(expensiveProduct);

      // Assert
      expect(provider.items, hasLength(1));
      expect(provider.items.first.quantity, equals(1));
      expect(provider.totalPrice, equals(999999.99));
    });

    test('should handle products with very small price', () {
      // Arrange
      final cheapProduct = Product(
        id: 6,
        title: 'Cheap Product',
        description: 'Very cheap',
        price: 0.01,
        image: 'https://example.com/cheap.jpg',
      );

      // Act
      provider.addProduct(cheapProduct);
      provider.addProduct(cheapProduct); // quantity = 2

      // Assert
      expect(provider.items, hasLength(1));
      expect(provider.items.first.quantity, equals(2));
      expect(provider.totalPrice, equals(0.02));
    });

    test('should handle products with empty strings', () {
      // Arrange
      final emptyProduct = Product(
        id: 7,
        title: '',
        description: '',
        price: 10.0,
        image: '',
      );

      // Act
      provider.addProduct(emptyProduct);

      // Assert
      expect(provider.items, hasLength(1));
      expect(provider.items.first.product.title, equals(''));
      expect(provider.items.first.product.description, equals(''));
      expect(provider.items.first.product.image, equals(''));
      expect(provider.totalPrice, equals(10.0));
    });

    test('should handle products with special characters', () {
      // Arrange
      final specialProduct = Product(
        id: 8,
        title: 'Product with émojis 🛍️',
        description: 'Description with unicode: 中文 Español',
        price: 10.0,
        image: 'https://example.com/special.jpg',
      );

      // Act
      provider.addProduct(specialProduct);

      // Assert
      expect(provider.items, hasLength(1));
      expect(provider.items.first.product.title, equals('Product with émojis 🛍️'));
      expect(provider.items.first.product.description, equals('Description with unicode: 中文 Español'));
      expect(provider.totalPrice, equals(10.0));
    });

    test('should handle products with maximum integer ID', () {
      // Arrange
      final maxIdProduct = Product(
        id: 9223372036854775807,
        title: 'Max ID Product',
        description: 'Description',
        price: 10.0,
        image: 'https://example.com/maxid.jpg',
      );

      // Act
      provider.addProduct(maxIdProduct);

      // Assert
      expect(provider.items, hasLength(1));
      expect(provider.items.first.product.id, equals(9223372036854775807));
      expect(provider.totalPrice, equals(10.0));
    });

    test('should handle products with minimum integer ID', () {
      // Arrange
      final minIdProduct = Product(
        id: -9223372036854775808,
        title: 'Min ID Product',
        description: 'Description',
        price: 10.0,
        image: 'https://example.com/minid.jpg',
      );

      // Act
      provider.addProduct(minIdProduct);

      // Assert
      expect(provider.items, hasLength(1));
      expect(provider.items.first.product.id, equals(-9223372036854775808));
      expect(provider.totalPrice, equals(10.0));
    });

    test('should handle large quantities', () {
      // Arrange
      const largeQuantity = 1000;

      // Act
      for (int i = 0; i < largeQuantity; i++) {
        provider.addProduct(testProduct1);
      }

      // Assert
      expect(provider.items, hasLength(1));
      expect(provider.items.first.quantity, equals(largeQuantity));
      expect(provider.totalPrice, equals(29.99 * largeQuantity));
    });

    test('should handle multiple operations in sequence', () {
      // Act
      provider.addProduct(testProduct1); // Add product 1
      provider.addProduct(testProduct2); // Add product 2
      provider.addProduct(testProduct1); // Increase quantity of product 1
      provider.decreaseQuantity(testProduct1.id); // Decrease quantity of product 1
      provider.removeProduct(testProduct2.id); // Remove product 2
      provider.clearCart(); // Clear cart

      // Assert
      expect(provider.items, isEmpty);
      expect(provider.totalPrice, equals(0.0));
    });

    test('should handle complex cart operations', () {
      // Arrange
      final product3 = Product(
        id: 3,
        title: 'Product 3',
        description: 'Description 3',
        price: 15.50,
        image: 'https://example.com/image3.jpg',
      );

      // Act
      provider.addProduct(testProduct1); // 29.99
      provider.addProduct(testProduct2); // 39.99
      provider.addProduct(product3); // 15.50
      provider.addProduct(testProduct1); // 29.99 * 2
      provider.addProduct(testProduct2); // 39.99 * 2
      provider.decreaseQuantity(testProduct1.id); // 29.99
      provider.removeProduct(product3.id); // Remove product 3

      // Assert
      expect(provider.items, hasLength(2));
      expect(provider.items.first.product, equals(testProduct1));
      expect(provider.items.first.quantity, equals(1));
      expect(provider.items.last.product, equals(testProduct2));
      expect(provider.items.last.quantity, equals(2));
      expect(provider.totalPrice, equals(29.99 + 39.99 * 2));
    });

    test('should handle edge case of removing product with quantity 1', () {
      // Arrange
      provider.addProduct(testProduct1);

      // Act
      provider.removeProduct(testProduct1.id);

      // Assert
      expect(provider.items, isEmpty);
      expect(provider.totalPrice, equals(0.0));
    });

    test('should handle edge case of decreasing quantity of product with quantity 1', () {
      // Arrange
      provider.addProduct(testProduct1);

      // Act
      provider.decreaseQuantity(testProduct1.id);

      // Assert
      expect(provider.items, isEmpty);
      expect(provider.totalPrice, equals(0.0));
    });

    test('should handle edge case of clearing empty cart', () {
      // Act
      provider.clearCart();

      // Assert
      expect(provider.items, isEmpty);
      expect(provider.totalPrice, equals(0.0));
    });

    test('should handle edge case of removing non-existent product from empty cart', () {
      // Act
      provider.removeProduct(999);

      // Assert
      expect(provider.items, isEmpty);
      expect(provider.totalPrice, equals(0.0));
    });

    test('should handle edge case of decreasing quantity of non-existent product from empty cart', () {
      // Act
      provider.decreaseQuantity(999);

      // Assert
      expect(provider.items, isEmpty);
      expect(provider.totalPrice, equals(0.0));
    });

    test('should handle precision in price calculations', () {
      // Arrange
      final preciseProduct = Product(
        id: 9,
        title: 'Precise Product',
        description: 'Precise Description',
        price: 0.3333333333333333,
        image: 'https://example.com/precise.jpg',
      );

      // Act
      provider.addProduct(preciseProduct);
      provider.addProduct(preciseProduct); // quantity = 2

      // Assert
      expect(provider.items, hasLength(1));
      expect(provider.items.first.quantity, equals(2));
      expect(provider.totalPrice, equals(0.3333333333333333 * 2));
    });

    test('should handle very large price values', () {
      // Arrange
      final veryExpensiveProduct = Product(
        id: 10,
        title: 'Very Expensive Product',
        description: 'Very expensive',
        price: 999999999.99,
        image: 'https://example.com/veryexpensive.jpg',
      );

      // Act
      provider.addProduct(veryExpensiveProduct);

      // Assert
      expect(provider.items, hasLength(1));
      expect(provider.items.first.quantity, equals(1));
      expect(provider.totalPrice, equals(999999999.99));
    });

    test('should handle products with maximum integer ID and high price', () {
      // Arrange
      final maxIdExpensiveProduct = Product(
        id: 9223372036854775807,
        title: 'Max ID Expensive Product',
        description: 'Very expensive with max ID',
        price: 999999.99,
        image: 'https://example.com/maxidexpensive.jpg',
      );

      // Act
      provider.addProduct(maxIdExpensiveProduct);
      provider.addProduct(maxIdExpensiveProduct); // quantity = 2

      // Assert
      expect(provider.items, hasLength(1));
      expect(provider.items.first.product.id, equals(9223372036854775807));
      expect(provider.items.first.quantity, equals(2));
      expect(provider.totalPrice, equals(999999.99 * 2));
    });

    test('should handle products with minimum integer ID and negative price', () {
      // Arrange
      final minIdNegativeProduct = Product(
        id: -9223372036854775808,
        title: 'Min ID Negative Product',
        description: 'Negative price with min ID',
        price: -999.99,
        image: 'https://example.com/minidnegative.jpg',
      );

      // Act
      provider.addProduct(minIdNegativeProduct);
      provider.addProduct(minIdNegativeProduct); // quantity = 2

      // Assert
      expect(provider.items, hasLength(1));
      expect(provider.items.first.product.id, equals(-9223372036854775808));
      expect(provider.items.first.quantity, equals(2));
      expect(provider.totalPrice, equals(-999.99 * 2));
    });
  });
}
