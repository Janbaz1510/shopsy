import 'package:flutter_test/flutter_test.dart';
import 'package:shopsy/features/product/domain/entities/product.dart';

/// Unit tests for the Product entity
/// 
/// These tests validate the core Product data model that represents a product
/// in the e-commerce application. The Product entity is a fundamental building
/// block used throughout the application for displaying product information,
/// managing cart items, and handling business logic.
/// 
/// Test Coverage:
/// - Basic product creation and property access
/// - Equality and hash code behavior
/// - String representation
/// - Edge cases with special characters and unicode
/// - Null safety and data integrity
void main() {
  group('Product Entity', () {
    /// Test basic product creation and property access
    /// Validates that all product properties are correctly set and accessible
    test('should create product with all properties', () {
      // Arrange - Create a test product with all required properties
      const testId = 1;
      const testTitle = 'Test Product';
      const testDescription = 'Test Description';
      const testPrice = 99.99;
      const testImage = 'https://example.com/image.jpg';

      // Act - Create the product instance
      const product = Product(
        id: testId,
        title: testTitle,
        description: testDescription,
        price: testPrice,
        image: testImage,
      );

      // Assert - Verify all properties are correctly set
      expect(product.id, equals(testId));
      expect(product.title, equals(testTitle));
      expect(product.description, equals(testDescription));
      expect(product.price, equals(testPrice));
      expect(product.image, equals(testImage));
    });

    /// Test product equality behavior
    /// Validates that products with identical properties are considered equal
    test('should be equal when all properties are the same', () {
      // Arrange - Create two products with identical properties
      const product1 = Product(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        price: 99.99,
        image: 'https://example.com/image.jpg',
      );

      const product2 = Product(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        price: 99.99,
        image: 'https://example.com/image.jpg',
      );

      // Assert - Products should be equal
      expect(product1, equals(product2));
      expect(product1.hashCode, equals(product2.hashCode));
    });

    /// Test product inequality behavior
    /// Validates that products with different properties are not considered equal
    test('should not be equal when properties are different', () {
      // Arrange - Create products with different properties
      const product1 = Product(
        id: 1,
        title: 'Test Product 1',
        description: 'Test Description',
        price: 99.99,
        image: 'https://example.com/image1.jpg',
      );

      const product2 = Product(
        id: 2,
        title: 'Test Product 2',
        description: 'Test Description',
        price: 99.99,
        image: 'https://example.com/image2.jpg',
      );

      // Assert - Products should not be equal
      expect(product1, isNot(equals(product2)));
    });

    /// Test string representation of product
    /// Validates that toString() provides meaningful debug information
    test('should have meaningful string representation', () {
      // Arrange - Create a test product
      const product = Product(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        price: 99.99,
        image: 'https://example.com/image.jpg',
      );

      // Act - Get string representation
      final stringRepresentation = product.toString();

      // Assert - String should contain product information
      expect(stringRepresentation, contains('Product'));
      expect(stringRepresentation, contains('1'));
      expect(stringRepresentation, contains('Test Product'));
      expect(stringRepresentation, contains('99.99'));
    });

    /// Test product with zero price
    /// Validates that products can have a price of zero (free products)
    test('should handle zero price', () {
      // Arrange & Act - Create product with zero price
      const product = Product(
        id: 1,
        title: 'Free Product',
        description: 'This product is free',
        price: 0.0,
        image: 'https://example.com/free.jpg',
      );

      // Assert - Zero price should be handled correctly
      expect(product.price, equals(0.0));
      expect(product.price, isA<double>());
    });

    /// Test product with negative price
    /// Validates that negative prices are handled (though not recommended in production)
    test('should handle negative price', () {
      // Arrange & Act - Create product with negative price
      const product = Product(
        id: 1,
        title: 'Discounted Product',
        description: 'This product has a negative price',
        price: -10.0,
        image: 'https://example.com/discounted.jpg',
      );

      // Assert - Negative price should be handled correctly
      expect(product.price, equals(-10.0));
      expect(product.price, isA<double>());
    });

    /// Test product with very long text
    /// Validates that products can handle long titles and descriptions
    test('should handle long text in title and description', () {
      // Arrange - Create long text strings
      const longTitle = 'This is a very long product title that contains many words and should be handled properly by the Product entity without any issues or truncation';
      const longDescription = 'This is a very long product description that contains many words and should be handled properly by the Product entity without any issues or truncation. It should be able to store large amounts of text for detailed product information.';

      // Act - Create product with long text
      const product = Product(
        id: 1,
        title: longTitle,
        description: longDescription,
        price: 99.99,
        image: 'https://example.com/long.jpg',
      );

      // Assert - Long text should be preserved exactly
      expect(product.title, equals(longTitle));
      expect(product.description, equals(longDescription));
      expect(product.title.length, greaterThan(50));
      expect(product.description.length, greaterThan(100));
    });

    /// Test product with special characters in strings
    /// Validates that products can handle special characters, emojis, and unicode
    test('should handle special characters in strings', () {
      // Arrange - Create product with special characters
      const specialProduct = Product(
        id: 1,
        title: 'Product with émojis 🛍️ and symbols @#\$%',
        description: 'Description with unicode: 中文 Español Français',
        price: 10.0,
        image: 'https://example.com/image with spaces.jpg',
      );

      // Assert - Special characters should be preserved
      expect(specialProduct.title, equals('Product with émojis 🛍️ and symbols @#\$%'));
      expect(specialProduct.description, equals('Description with unicode: 中文 Español Français'));
      expect(specialProduct.image, equals('https://example.com/image with spaces.jpg'));
    });

    /// Test product with maximum integer ID
    /// Validates that large ID values are handled correctly
    test('should handle maximum integer ID', () {
      // Arrange & Act - Create product with maximum integer ID
      const maxId = 9223372036854775807; // Maximum 64-bit integer
      const product = Product(
        id: maxId,
        title: 'Max ID Product',
        description: 'Product with maximum ID',
        price: 99.99,
        image: 'https://example.com/max.jpg',
      );

      // Assert - Maximum ID should be handled correctly
      expect(product.id, equals(maxId));
      expect(product.id, isA<int>());
    });

    /// Test product with minimum integer ID
    /// Validates that minimum ID values are handled correctly
    test('should handle minimum integer ID', () {
      // Arrange & Act - Create product with minimum integer ID
      const minId = -9223372036854775808; // Minimum 64-bit integer
      const product = Product(
        id: minId,
        title: 'Min ID Product',
        description: 'Product with minimum ID',
        price: 99.99,
        image: 'https://example.com/min.jpg',
      );

      // Assert - Minimum ID should be handled correctly
      expect(product.id, equals(minId));
      expect(product.id, isA<int>());
    });

    /// Test product with very high price
    /// Validates that very large price values are handled correctly
    test('should handle very high price', () {
      // Arrange & Act - Create product with very high price
      const highPrice = 999999.99;
      const product = Product(
        id: 1,
        title: 'Expensive Product',
        description: 'Very expensive product',
        price: highPrice,
        image: 'https://example.com/expensive.jpg',
      );

      // Assert - High price should be handled correctly
      expect(product.price, equals(highPrice));
      expect(product.price, isA<double>());
    });

    /// Test product with very small price
    /// Validates that very small price values are handled correctly
    test('should handle very small price', () {
      // Arrange & Act - Create product with very small price
      const smallPrice = 0.01;
      const product = Product(
        id: 1,
        title: 'Cheap Product',
        description: 'Very cheap product',
        price: smallPrice,
        image: 'https://example.com/cheap.jpg',
      );

      // Assert - Small price should be handled correctly
      expect(product.price, equals(smallPrice));
      expect(product.price, isA<double>());
    });

    /// Test product with empty strings
    /// Validates that empty strings are handled correctly (though not recommended in production)
    test('should handle empty strings', () {
      // Arrange & Act - Create product with empty strings
      const product = Product(
        id: 1,
        title: '',
        description: '',
        price: 99.99,
        image: '',
      );

      // Assert - Empty strings should be handled correctly
      expect(product.title, equals(''));
      expect(product.description, equals(''));
      expect(product.image, equals(''));
      expect(product.title.isEmpty, isTrue);
      expect(product.description.isEmpty, isTrue);
      expect(product.image.isEmpty, isTrue);
    });

    /// Test product with whitespace-only strings
    /// Validates that whitespace-only strings are handled correctly
    test('should handle whitespace-only strings', () {
      // Arrange & Act - Create product with whitespace-only strings
      const product = Product(
        id: 1,
        title: '   ',
        description: '\t\n',
        price: 99.99,
        image: ' ',
      );

      // Assert - Whitespace-only strings should be handled correctly
      expect(product.title, equals('   '));
      expect(product.description, equals('\t\n'));
      expect(product.image, equals(' '));
      expect(product.title.trim().isEmpty, isTrue);
      expect(product.description.trim().isEmpty, isTrue);
      expect(product.image.trim().isEmpty, isTrue);
    });
  });
}
