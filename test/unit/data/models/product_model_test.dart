import 'package:flutter_test/flutter_test.dart';
import 'package:shopsy/features/product/data/models/product_model.dart';

void main() {
  group('ProductModel', () {
    test('should create ProductModel with correct properties', () {
      // Arrange
      const id = 1;
      const title = 'Test Product';
      const description = 'Test Description';
      const price = 29.99;
      const image = 'https://example.com/image.jpg';

      // Act
      final productModel = ProductModel(
        id: id,
        title: title,
        description: description,
        price: price,
        image: image,
      );

      // Assert
      expect(productModel.id, equals(id));
      expect(productModel.title, equals(title));
      expect(productModel.description, equals(description));
      expect(productModel.price, equals(price));
      expect(productModel.image, equals(image));
    });

    test('should create ProductModel from JSON', () {
      // Arrange
      final json = {
        'id': 1,
        'title': 'Test Product',
        'description': 'Test Description',
        'price': 29.99,
        'image': 'https://example.com/image.jpg',
      };

      // Act
      final productModel = ProductModel.fromJson(json);

      // Assert
      expect(productModel.id, equals(1));
      expect(productModel.title, equals('Test Product'));
      expect(productModel.description, equals('Test Description'));
      expect(productModel.price, equals(29.99));
      expect(productModel.image, equals('https://example.com/image.jpg'));
    });

    test('should handle integer price in JSON', () {
      // Arrange
      final json = {
        'id': 1,
        'title': 'Test Product',
        'description': 'Test Description',
        'price': 29, // integer instead of double
        'image': 'https://example.com/image.jpg',
      };

      // Act
      final productModel = ProductModel.fromJson(json);

      // Assert
      expect(productModel.price, equals(29.0));
    });

    test('should handle zero price', () {
      // Arrange
      final json = {
        'id': 1,
        'title': 'Free Product',
        'description': 'Free Description',
        'price': 0.0,
        'image': 'https://example.com/free.jpg',
      };

      // Act
      final productModel = ProductModel.fromJson(json);

      // Assert
      expect(productModel.price, equals(0.0));
    });

    test('should handle negative price', () {
      // Arrange
      final json = {
        'id': 1,
        'title': 'Discounted Product',
        'description': 'Discounted Description',
        'price': -5.0,
        'image': 'https://example.com/discounted.jpg',
      };

      // Act
      final productModel = ProductModel.fromJson(json);

      // Assert
      expect(productModel.price, equals(-5.0));
    });

    test('should handle very high price', () {
      // Arrange
      final json = {
        'id': 1,
        'title': 'Expensive Product',
        'description': 'Very expensive',
        'price': 999999.99,
        'image': 'https://example.com/expensive.jpg',
      };

      // Act
      final productModel = ProductModel.fromJson(json);

      // Assert
      expect(productModel.price, equals(999999.99));
    });

    test('should handle empty strings', () {
      // Arrange
      final json = {
        'id': 1,
        'title': '',
        'description': '',
        'price': 10.0,
        'image': '',
      };

      // Act
      final productModel = ProductModel.fromJson(json);

      // Assert
      expect(productModel.title, equals(''));
      expect(productModel.description, equals(''));
      expect(productModel.image, equals(''));
    });

    test('should handle special characters in strings', () {
      // Arrange
      final json = {
        'id': 1,
        'title': 'Product with émojis 🛍️ and symbols @#\$%',
        'description': 'Description with unicode: 中文 Español Français',
        'price': 10.0,
        'image': 'https://example.com/image with spaces.jpg',
      };

      // Act
      final productModel = ProductModel.fromJson(json);

      // Assert
      expect(productModel.title, equals('Product with émojis 🛍️ and symbols @#\$%'));
      expect(productModel.description, equals('Description with unicode: 中文 Español Français'));
      expect(productModel.image, equals('https://example.com/image with spaces.jpg'));
    });

    test('should handle very long strings', () {
      // Arrange
      final longTitle = 'A' * 1000;
      final longDescription = 'B' * 2000;
      final longImage = 'C' * 500;

      final json = {
        'id': 1,
        'title': longTitle,
        'description': longDescription,
        'price': 10.0,
        'image': longImage,
      };

      // Act
      final productModel = ProductModel.fromJson(json);

      // Assert
      expect(productModel.title, equals(longTitle));
      expect(productModel.description, equals(longDescription));
      expect(productModel.image, equals(longImage));
    });

    test('should handle maximum integer ID', () {
      // Arrange
      final json = {
        'id': 9223372036854775807, // max int64
        'title': 'Max ID Product',
        'description': 'Description',
        'price': 10.0,
        'image': 'https://example.com/maxid.jpg',
      };

      // Act
      final productModel = ProductModel.fromJson(json);

      // Assert
      expect(productModel.id, equals(9223372036854775807));
    });

    test('should handle minimum integer ID', () {
      // Arrange
      final json = {
        'id': -9223372036854775808, // min int64
        'title': 'Min ID Product',
        'description': 'Description',
        'price': 10.0,
        'image': 'https://example.com/minid.jpg',
      };

      // Act
      final productModel = ProductModel.fromJson(json);

      // Assert
      expect(productModel.id, equals(-9223372036854775808));
    });

    test('should handle zero ID', () {
      // Arrange
      final json = {
        'id': 0,
        'title': 'Zero ID Product',
        'description': 'Description',
        'price': 10.0,
        'image': 'https://example.com/zeroid.jpg',
      };

      // Act
      final productModel = ProductModel.fromJson(json);

      // Assert
      expect(productModel.id, equals(0));
    });

    test('should handle negative ID', () {
      // Arrange
      final json = {
        'id': -1,
        'title': 'Negative ID Product',
        'description': 'Description',
        'price': 10.0,
        'image': 'https://example.com/negativeid.jpg',
      };

      // Act
      final productModel = ProductModel.fromJson(json);

      // Assert
      expect(productModel.id, equals(-1));
    });

    test('should handle very small price values', () {
      // Arrange
      final json = {
        'id': 1,
        'title': 'Cheap Product',
        'description': 'Very cheap',
        'price': 0.01,
        'image': 'https://example.com/cheap.jpg',
      };

      // Act
      final productModel = ProductModel.fromJson(json);

      // Assert
      expect(productModel.price, equals(0.01));
    });

    test('should handle scientific notation in price', () {
      // Arrange
      final json = {
        'id': 1,
        'title': 'Scientific Price Product',
        'description': 'Description',
        'price': 1.23e-4,
        'image': 'https://example.com/scientific.jpg',
      };

      // Act
      final productModel = ProductModel.fromJson(json);

      // Assert
      expect(productModel.price, equals(1.23e-4));
    });

    test('should handle null values gracefully', () {
      // Arrange
      final json = {
        'id': 1,
        'title': null,
        'description': null,
        'price': 10.0,
        'image': null,
      };

      // Act & Assert
      expect(() => ProductModel.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('should handle missing required fields', () {
      // Arrange
      final json = {
        'id': 1,
        // missing title, description, price, image
      };

      // Act & Assert
      expect(() => ProductModel.fromJson(json), throwsA(isA<NoSuchMethodError>()));
    });

    test('should handle extra fields in JSON', () {
      // Arrange
      final json = {
        'id': 1,
        'title': 'Test Product',
        'description': 'Test Description',
        'price': 29.99,
        'image': 'https://example.com/image.jpg',
        'extra_field': 'extra_value',
        'another_field': 123,
      };

      // Act
      final productModel = ProductModel.fromJson(json);

      // Assert
      expect(productModel.id, equals(1));
      expect(productModel.title, equals('Test Product'));
      expect(productModel.description, equals('Test Description'));
      expect(productModel.price, equals(29.99));
      expect(productModel.image, equals('https://example.com/image.jpg'));
    });

    test('should handle whitespace in strings', () {
      // Arrange
      final json = {
        'id': 1,
        'title': '  Test Product  ',
        'description': '  Test Description  ',
        'price': 29.99,
        'image': '  https://example.com/image.jpg  ',
      };

      // Act
      final productModel = ProductModel.fromJson(json);

      // Assert
      expect(productModel.title, equals('  Test Product  '));
      expect(productModel.description, equals('  Test Description  '));
      expect(productModel.image, equals('  https://example.com/image.jpg  '));
    });

    test('should handle newlines in strings', () {
      // Arrange
      final json = {
        'id': 1,
        'title': 'Test\nProduct',
        'description': 'Test\nDescription\nwith\nnewlines',
        'price': 29.99,
        'image': 'https://example.com/image.jpg',
      };

      // Act
      final productModel = ProductModel.fromJson(json);

      // Assert
      expect(productModel.title, equals('Test\nProduct'));
      expect(productModel.description, equals('Test\nDescription\nwith\nnewlines'));
    });

    test('should handle tabs in strings', () {
      // Arrange
      final json = {
        'id': 1,
        'title': 'Test\tProduct',
        'description': 'Test\tDescription\twith\ttabs',
        'price': 29.99,
        'image': 'https://example.com/image.jpg',
      };

      // Act
      final productModel = ProductModel.fromJson(json);

      // Assert
      expect(productModel.title, equals('Test\tProduct'));
      expect(productModel.description, equals('Test\tDescription\twith\ttabs'));
    });
  });
}
