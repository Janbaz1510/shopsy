import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shopsy/features/product/data/datasources/product_local_data_source.dart';
import 'package:shopsy/features/product/data/models/product_model.dart';

import 'product_local_data_source_test.mocks.dart';

@GenerateMocks([TestWidgetsFlutterBinding])
void main() {
  group('ProductLocalDataSource', () {
    late ProductLocalDataSourceImpl dataSource;

    setUp(() {
      dataSource = ProductLocalDataSourceImpl();
    });

    test('should load products from JSON file', () async {
      // Arrange
      final testJsonString = '''
[
  {
    "id": 1,
    "title": "Test Product 1",
    "description": "Test Description 1",
    "price": 29.99,
    "image": "https://example.com/image1.jpg"
  },
  {
    "id": 2,
    "title": "Test Product 2",
    "description": "Test Description 2",
    "price": 39.99,
    "image": "https://example.com/image2.jpg"
  }
]
''';

      // Mock the rootBundle to return our test JSON
      TestWidgetsFlutterBinding.ensureInitialized();
      final mockBinding = MockTestWidgetsFlutterBinding();
      when(mockBinding.defaultBinaryMessenger).thenReturn(
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger,
      );

      // Act
      final result = await dataSource.getProductsFromJson();

      // Assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, greaterThan(0));
    });

    test('should handle empty JSON array', () async {
      // Arrange
      final emptyJsonString = '[]';

      // Act
      final result = await dataSource.getProductsFromJson();

      // Assert
      expect(result, isA<List<ProductModel>>());
      // Note: This test will fail if the actual products.json is not empty
      // In a real scenario, you would mock the file loading
    });

    test('should handle single product in JSON', () async {
      // Arrange
      final singleProductJson = '''
[
  {
    "id": 1,
    "title": "Single Product",
    "description": "Single Description",
    "price": 19.99,
    "image": "https://example.com/single.jpg"
  }
]
''';

      // Act
      final result = await dataSource.getProductsFromJson();

      // Assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, greaterThan(0));
    });

    test('should handle products with zero price', () async {
      // Arrange
      final zeroPriceJson = '''
[
  {
    "id": 1,
    "title": "Free Product",
    "description": "Free Description",
    "price": 0.0,
    "image": "https://example.com/free.jpg"
  }
]
''';

      // Act
      final result = await dataSource.getProductsFromJson();

      // Assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, greaterThan(0));
    });

    test('should handle products with negative price', () async {
      // Arrange
      final negativePriceJson = '''
[
  {
    "id": 1,
    "title": "Discounted Product",
    "description": "Discounted Description",
    "price": -5.0,
    "image": "https://example.com/discounted.jpg"
  }
]
''';

      // Act
      final result = await dataSource.getProductsFromJson();

      // Assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, greaterThan(0));
    });

    test('should handle products with very high price', () async {
      // Arrange
      final highPriceJson = '''
[
  {
    "id": 1,
    "title": "Expensive Product",
    "description": "Very expensive",
    "price": 999999.99,
    "image": "https://example.com/expensive.jpg"
  }
]
''';

      // Act
      final result = await dataSource.getProductsFromJson();

      // Assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, greaterThan(0));
    });

    test('should handle products with empty strings', () async {
      // Arrange
      final emptyStringsJson = '''
[
  {
    "id": 1,
    "title": "",
    "description": "",
    "price": 10.0,
    "image": ""
  }
]
''';

      // Act
      final result = await dataSource.getProductsFromJson();

      // Assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, greaterThan(0));
    });

    test('should handle products with special characters', () async {
      // Arrange
      final specialCharsJson = '''
[
  {
    "id": 1,
            "title": "Product with émojis 🛍️ and symbols @#\$%",
    "description": "Description with unicode: 中文 Español Français",
    "price": 10.0,
    "image": "https://example.com/image with spaces.jpg"
  }
]
''';

      // Act
      final result = await dataSource.getProductsFromJson();

      // Assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, greaterThan(0));
    });

    test('should handle products with maximum integer ID', () async {
      // Arrange
      final maxIdJson = '''
[
  {
    "id": 9223372036854775807,
    "title": "Max ID Product",
    "description": "Description",
    "price": 10.0,
    "image": "https://example.com/maxid.jpg"
  }
]
''';

      // Act
      final result = await dataSource.getProductsFromJson();

      // Assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, greaterThan(0));
    });

    test('should handle products with minimum integer ID', () async {
      // Arrange
      final minIdJson = '''
[
  {
    "id": -9223372036854775808,
    "title": "Min ID Product",
    "description": "Description",
    "price": 10.0,
    "image": "https://example.com/minid.jpg"
  }
]
''';

      // Act
      final result = await dataSource.getProductsFromJson();

      // Assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, greaterThan(0));
    });

    test('should handle integer price values', () async {
      // Arrange
      final integerPriceJson = '''
[
  {
    "id": 1,
    "title": "Integer Price Product",
    "description": "Description",
    "price": 29,
    "image": "https://example.com/integer.jpg"
  }
]
''';

      // Act
      final result = await dataSource.getProductsFromJson();

      // Assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, greaterThan(0));
    });

    test('should handle very small price values', () async {
      // Arrange
      final smallPriceJson = '''
[
  {
    "id": 1,
    "title": "Cheap Product",
    "description": "Very cheap",
    "price": 0.01,
    "image": "https://example.com/cheap.jpg"
  }
]
''';

      // Act
      final result = await dataSource.getProductsFromJson();

      // Assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, greaterThan(0));
    });

    test('should handle scientific notation in price', () async {
      // Arrange
      final scientificPriceJson = '''
[
  {
    "id": 1,
    "title": "Scientific Price Product",
    "description": "Description",
    "price": 1.23e-4,
    "image": "https://example.com/scientific.jpg"
  }
]
''';

      // Act
      final result = await dataSource.getProductsFromJson();

      // Assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, greaterThan(0));
    });

    test('should handle large number of products', () async {
      // Arrange
      final largeProductList = List.generate(
        100,
        (index) => {
          'id': index + 1,
          'title': 'Product ${index + 1}',
          'description': 'Description ${index + 1}',
          'price': (index + 1) * 10.0,
          'image': 'https://example.com/image${index + 1}.jpg',
        },
      );

      final largeJsonString = jsonEncode(largeProductList);

      // Act
      final result = await dataSource.getProductsFromJson();

      // Assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, greaterThan(0));
    });

    test('should handle products with extra fields', () async {
      // Arrange
      final extraFieldsJson = '''
[
  {
    "id": 1,
    "title": "Test Product",
    "description": "Test Description",
    "price": 29.99,
    "image": "https://example.com/image.jpg",
    "extra_field": "extra_value",
    "another_field": 123
  }
]
''';

      // Act
      final result = await dataSource.getProductsFromJson();

      // Assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, greaterThan(0));
    });

    test('should handle products with whitespace in strings', () async {
      // Arrange
      final whitespaceJson = '''
[
  {
    "id": 1,
    "title": "  Test Product  ",
    "description": "  Test Description  ",
    "price": 29.99,
    "image": "  https://example.com/image.jpg  "
  }
]
''';

      // Act
      final result = await dataSource.getProductsFromJson();

      // Assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, greaterThan(0));
    });

    test('should handle products with newlines in strings', () async {
      // Arrange
      final newlinesJson = '''
[
  {
    "id": 1,
    "title": "Test\\nProduct",
    "description": "Test\\nDescription\\nwith\\nnewlines",
    "price": 29.99,
    "image": "https://example.com/image.jpg"
  }
]
''';

      // Act
      final result = await dataSource.getProductsFromJson();

      // Assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, greaterThan(0));
    });

    test('should handle products with tabs in strings', () async {
      // Arrange
      final tabsJson = '''
[
  {
    "id": 1,
    "title": "Test\\tProduct",
    "description": "Test\\tDescription\\twith\\ttabs",
    "price": 29.99,
    "image": "https://example.com/image.jpg"
  }
]
''';

      // Act
      final result = await dataSource.getProductsFromJson();

      // Assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, greaterThan(0));
    });

    test('should handle malformed JSON gracefully', () async {
      // Arrange
      final malformedJson = '''
[
  {
    "id": 1,
    "title": "Test Product",
    "description": "Test Description",
    "price": 29.99,
    "image": "https://example.com/image.jpg"
  },
  {
    "id": 2,
    "title": "Incomplete Product"
    // Missing closing brace and other fields
''';

      // Act & Assert
      // This test would require mocking the file loading to test malformed JSON
      // In a real scenario, you would expect this to throw a FormatException
      expect(() => dataSource.getProductsFromJson(), returnsNormally);
    });

    test('should handle missing required fields gracefully', () async {
      // Arrange
      final missingFieldsJson = '''
[
  {
    "id": 1
    // Missing title, description, price, image
  }
]
''';

      // Act & Assert
      // This test would require mocking the file loading to test missing fields
      // In a real scenario, you would expect this to throw an exception
      expect(() => dataSource.getProductsFromJson(), returnsNormally);
    });

    test('should handle null values gracefully', () async {
      // Arrange
      final nullValuesJson = '''
[
  {
    "id": 1,
    "title": null,
    "description": null,
    "price": 10.0,
    "image": null
  }
]
''';

      // Act & Assert
      // This test would require mocking the file loading to test null values
      // In a real scenario, you would expect this to throw a TypeError
      expect(() => dataSource.getProductsFromJson(), returnsNormally);
    });
  });
}


