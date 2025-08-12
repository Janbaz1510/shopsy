import 'package:flutter_test/flutter_test.dart';
import 'package:shopsy/features/product/domain/entities/cart_item.dart';
import 'package:shopsy/features/product/domain/entities/product.dart';

/// Unit tests for the CartItem entity
/// 
/// These tests validate the CartItem data model that represents an item in the
/// shopping cart. CartItem combines a Product with a quantity and provides
/// methods for calculating the total price for that specific item.
/// 
/// Test Coverage:
/// - Basic cart item creation and property access
/// - Quantity management and validation
/// - Total price calculation
/// - Equality and hash code behavior
/// - Edge cases with zero/negative quantities
/// - Product reference integrity
void main() {
  group('CartItem Entity', () {
    /// Test basic cart item creation and property access
    /// Validates that all cart item properties are correctly set and accessible
    test('should create cart item with product and quantity', () {
      // Arrange - Create a test product
      const testProduct = Product(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        price: 29.99,
        image: 'https://example.com/image.jpg',
      );
      const testQuantity = 2;

      // Act - Create the cart item
      const cartItem = CartItem(
        product: testProduct,
        quantity: testQuantity,
      );

      // Assert - Verify all properties are correctly set
      expect(cartItem.product, equals(testProduct));
      expect(cartItem.quantity, equals(testQuantity));
    });

    /// Test total price calculation
    /// Validates that the total price is correctly calculated based on product price and quantity
    test('should calculate total price correctly', () {
      // Arrange - Create a product with a specific price
      const testProduct = Product(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        price: 10.0,
        image: 'https://example.com/image.jpg',
      );
      const quantity = 3;

      // Act - Create cart item and calculate total
      const cartItem = CartItem(
        product: testProduct,
        quantity: quantity,
      );

      // Assert - Total should be product price * quantity
      expect(cartItem.totalPrice, equals(30.0)); // 10.0 * 3
    });

    /// Test cart item equality behavior
    /// Validates that cart items with identical products and quantities are considered equal
    test('should be equal when product and quantity are the same', () {
      // Arrange - Create identical products and cart items
      const product1 = Product(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        price: 29.99,
        image: 'https://example.com/image.jpg',
      );

      const product2 = Product(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        price: 29.99,
        image: 'https://example.com/image.jpg',
      );

      const cartItem1 = CartItem(
        product: product1,
        quantity: 2,
      );

      const cartItem2 = CartItem(
        product: product2,
        quantity: 2,
      );

      // Assert - Cart items should be equal
      expect(cartItem1, equals(cartItem2));
      expect(cartItem1.hashCode, equals(cartItem2.hashCode));
    });

    /// Test cart item inequality behavior
    /// Validates that cart items with different products or quantities are not considered equal
    test('should not be equal when product or quantity are different', () {
      // Arrange - Create different products and cart items
      const product1 = Product(
        id: 1,
        title: 'Test Product 1',
        description: 'Test Description',
        price: 29.99,
        image: 'https://example.com/image1.jpg',
      );

      const product2 = Product(
        id: 2,
        title: 'Test Product 2',
        description: 'Test Description',
        price: 29.99,
        image: 'https://example.com/image2.jpg',
      );

      const cartItem1 = CartItem(
        product: product1,
        quantity: 2,
      );

      const cartItem2 = CartItem(
        product: product2,
        quantity: 2,
      );

      const cartItem3 = CartItem(
        product: product1,
        quantity: 3,
      );

      // Assert - Cart items should not be equal
      expect(cartItem1, isNot(equals(cartItem2))); // Different products
      expect(cartItem1, isNot(equals(cartItem3))); // Different quantities
    });

    /// Test cart item with zero quantity
    /// Validates that cart items can have a quantity of zero (though not recommended in production)
    test('should handle zero quantity', () {
      // Arrange - Create a test product
      const testProduct = Product(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        price: 29.99,
        image: 'https://example.com/image.jpg',
      );

      // Act - Create cart item with zero quantity
      const cartItem = CartItem(
        product: testProduct,
        quantity: 0,
      );

      // Assert - Zero quantity should be handled correctly
      expect(cartItem.quantity, equals(0));
      expect(cartItem.totalPrice, equals(0.0)); // 29.99 * 0 = 0.0
    });

    /// Test cart item with negative quantity
    /// Validates that negative quantities are handled (though not recommended in production)
    test('should handle negative quantity', () {
      // Arrange - Create a test product
      const testProduct = Product(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        price: 10.0,
        image: 'https://example.com/image.jpg',
      );

      // Act - Create cart item with negative quantity
      const cartItem = CartItem(
        product: testProduct,
        quantity: -2,
      );

      // Assert - Negative quantity should be handled correctly
      expect(cartItem.quantity, equals(-2));
      expect(cartItem.totalPrice, equals(-20.0)); // 10.0 * (-2) = -20.0
    });

    /// Test cart item with large quantity
    /// Validates that very large quantities are handled correctly
    test('should handle large quantity', () {
      // Arrange - Create a test product
      const testProduct = Product(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        price: 1.0,
        image: 'https://example.com/image.jpg',
      );
      const largeQuantity = 1000000;

      // Act - Create cart item with large quantity
      const cartItem = CartItem(
        product: testProduct,
        quantity: largeQuantity,
      );

      // Assert - Large quantity should be handled correctly
      expect(cartItem.quantity, equals(largeQuantity));
      expect(cartItem.totalPrice, equals(1000000.0)); // 1.0 * 1000000
    });

    /// Test cart item with expensive product
    /// Validates that expensive products are handled correctly in total price calculation
    test('should handle expensive product', () {
      // Arrange - Create an expensive product
      const expensiveProduct = Product(
        id: 1,
        title: 'Expensive Product',
        description: 'Very expensive product',
        price: 9999.99,
        image: 'https://example.com/expensive.jpg',
      );
      const quantity = 2;

      // Act - Create cart item with expensive product
      const cartItem = CartItem(
        product: expensiveProduct,
        quantity: quantity,
      );

      // Assert - Expensive product should be handled correctly
      expect(cartItem.totalPrice, equals(19999.98)); // 9999.99 * 2
    });

    /// Test cart item with free product
    /// Validates that free products (zero price) are handled correctly
    test('should handle free product', () {
      // Arrange - Create a free product
      const freeProduct = Product(
        id: 1,
        title: 'Free Product',
        description: 'This product is free',
        price: 0.0,
        image: 'https://example.com/free.jpg',
      );
      const quantity = 5;

      // Act - Create cart item with free product
      const cartItem = CartItem(
        product: freeProduct,
        quantity: quantity,
      );

      // Assert - Free product should result in zero total price
      expect(cartItem.totalPrice, equals(0.0)); // 0.0 * 5 = 0.0
    });

    /// Test cart item with decimal price product
    /// Validates that products with decimal prices are handled correctly in calculations
    test('should handle decimal price product', () {
      // Arrange - Create a product with decimal price
      const decimalProduct = Product(
        id: 1,
        title: 'Decimal Price Product',
        description: 'Product with decimal price',
        price: 3.33,
        image: 'https://example.com/decimal.jpg',
      );
      const quantity = 3;

      // Act - Create cart item with decimal price product
      const cartItem = CartItem(
        product: decimalProduct,
        quantity: quantity,
      );

      // Assert - Decimal price should be handled correctly
      expect(cartItem.totalPrice, equals(9.99)); // 3.33 * 3
    });

    /// Test cart item string representation
    /// Validates that toString() provides meaningful debug information
    test('should have meaningful string representation', () {
      // Arrange - Create a test cart item
      const testProduct = Product(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        price: 29.99,
        image: 'https://example.com/image.jpg',
      );

      const cartItem = CartItem(
        product: testProduct,
        quantity: 2,
      );

      // Act - Get string representation
      final stringRepresentation = cartItem.toString();

      // Assert - String should contain cart item information
      expect(stringRepresentation, contains('CartItem'));
      expect(stringRepresentation, contains('Test Product'));
      expect(stringRepresentation, contains('2'));
      expect(stringRepresentation, contains('29.99'));
    });

    /// Test cart item with maximum integer quantity
    /// Validates that maximum integer quantities are handled correctly
    test('should handle maximum integer quantity', () {
      // Arrange - Create a test product
      const testProduct = Product(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        price: 1.0,
        image: 'https://example.com/image.jpg',
      );
      const maxQuantity = 9223372036854775807; // Maximum 64-bit integer

      // Act - Create cart item with maximum quantity
      const cartItem = CartItem(
        product: testProduct,
        quantity: maxQuantity,
      );

      // Assert - Maximum quantity should be handled correctly
      expect(cartItem.quantity, equals(maxQuantity));
      expect(cartItem.totalPrice, equals(9223372036854775807.0)); // 1.0 * maxQuantity
    });

    /// Test cart item with minimum integer quantity
    /// Validates that minimum integer quantities are handled correctly
    test('should handle minimum integer quantity', () {
      // Arrange - Create a test product
      const testProduct = Product(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        price: 1.0,
        image: 'https://example.com/image.jpg',
      );
      const minQuantity = -9223372036854775808; // Minimum 64-bit integer

      // Act - Create cart item with minimum quantity
      const cartItem = CartItem(
        product: testProduct,
        quantity: minQuantity,
      );

      // Assert - Minimum quantity should be handled correctly
      expect(cartItem.quantity, equals(minQuantity));
      expect(cartItem.totalPrice, equals(-9223372036854775808.0)); // 1.0 * minQuantity
    });
  });
}
