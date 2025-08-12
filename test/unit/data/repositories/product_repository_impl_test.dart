import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shopsy/features/product/data/datasources/product_local_data_source.dart';
import 'package:shopsy/features/product/data/models/product_model.dart';
import 'package:shopsy/features/product/data/repositories/product_repository_impl.dart';
import 'package:shopsy/features/product/domain/entities/product.dart';

import 'product_repository_impl_test.mocks.dart';

@GenerateMocks([ProductLocalDataSource])
void main() {
  group('ProductRepositoryImpl', () {
    late ProductRepositoryImpl repository;
    late MockProductLocalDataSource mockDataSource;

    setUp(() {
      mockDataSource = MockProductLocalDataSource();
      repository = ProductRepositoryImpl(mockDataSource);
    });

    test('should get products from local data source', () async {
      // Arrange
      final testProductModels = [
        ProductModel(
          id: 1,
          title: 'Test Product 1',
          description: 'Test Description 1',
          price: 29.99,
          image: 'https://example.com/image1.jpg',
        ),
        ProductModel(
          id: 2,
          title: 'Test Product 2',
          description: 'Test Description 2',
          price: 39.99,
          image: 'https://example.com/image2.jpg',
        ),
      ];

      when(mockDataSource.getProductsFromJson()).thenAnswer((_) async => testProductModels);

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result, equals(testProductModels));
      verify(mockDataSource.getProductsFromJson()).called(1);
    });

    test('should return empty list when data source returns empty list', () async {
      // Arrange
      when(mockDataSource.getProductsFromJson()).thenAnswer((_) async => <ProductModel>[]);

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result, isEmpty);
      verify(mockDataSource.getProductsFromJson()).called(1);
    });

    test('should return single product when data source returns single product', () async {
      // Arrange
      final singleProductModel = [
        ProductModel(
          id: 1,
          title: 'Single Product',
          description: 'Single Description',
          price: 19.99,
          image: 'https://example.com/single.jpg',
        ),
      ];

      when(mockDataSource.getProductsFromJson()).thenAnswer((_) async => singleProductModel);

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result, hasLength(1));
      expect(result.first.id, equals(1));
      expect(result.first.title, equals('Single Product'));
      verify(mockDataSource.getProductsFromJson()).called(1);
    });

    test('should return large list of products', () async {
      // Arrange
      final largeProductModels = List.generate(
        100,
        (index) => ProductModel(
          id: index + 1,
          title: 'Product ${index + 1}',
          description: 'Description ${index + 1}',
          price: (index + 1) * 10.0,
          image: 'https://example.com/image${index + 1}.jpg',
        ),
      );

      when(mockDataSource.getProductsFromJson()).thenAnswer((_) async => largeProductModels);

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result, hasLength(100));
      expect(result.first.id, equals(1));
      expect(result.last.id, equals(100));
      verify(mockDataSource.getProductsFromJson()).called(1);
    });

    test('should handle products with zero price', () async {
      // Arrange
      final freeProductModels = [
        ProductModel(
          id: 1,
          title: 'Free Product',
          description: 'Free Description',
          price: 0.0,
          image: 'https://example.com/free.jpg',
        ),
      ];

      when(mockDataSource.getProductsFromJson()).thenAnswer((_) async => freeProductModels);

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result.first.price, equals(0.0));
      verify(mockDataSource.getProductsFromJson()).called(1);
    });

    test('should handle products with negative price', () async {
      // Arrange
      final discountedProductModels = [
        ProductModel(
          id: 1,
          title: 'Discounted Product',
          description: 'Discounted Description',
          price: -5.0,
          image: 'https://example.com/discounted.jpg',
        ),
      ];

      when(mockDataSource.getProductsFromJson()).thenAnswer((_) async => discountedProductModels);

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result.first.price, equals(-5.0));
      verify(mockDataSource.getProductsFromJson()).called(1);
    });

    test('should handle products with very high price', () async {
      // Arrange
      final expensiveProductModels = [
        ProductModel(
          id: 1,
          title: 'Expensive Product',
          description: 'Very expensive',
          price: 999999.99,
          image: 'https://example.com/expensive.jpg',
        ),
      ];

      when(mockDataSource.getProductsFromJson()).thenAnswer((_) async => expensiveProductModels);

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result.first.price, equals(999999.99));
      verify(mockDataSource.getProductsFromJson()).called(1);
    });

    test('should handle products with empty strings', () async {
      // Arrange
      final emptyProductModels = [
        ProductModel(
          id: 1,
          title: '',
          description: '',
          price: 10.0,
          image: '',
        ),
      ];

      when(mockDataSource.getProductsFromJson()).thenAnswer((_) async => emptyProductModels);

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result.first.title, equals(''));
      expect(result.first.description, equals(''));
      expect(result.first.image, equals(''));
      verify(mockDataSource.getProductsFromJson()).called(1);
    });

    test('should handle products with special characters', () async {
      // Arrange
      final specialProductModels = [
        ProductModel(
          id: 1,
          title: 'Product with émojis 🛍️',
          description: 'Description with unicode: 中文 Español',
          price: 10.0,
          image: 'https://example.com/special.jpg',
        ),
      ];

      when(mockDataSource.getProductsFromJson()).thenAnswer((_) async => specialProductModels);

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result.first.title, equals('Product with émojis 🛍️'));
      expect(result.first.description, equals('Description with unicode: 中文 Español'));
      verify(mockDataSource.getProductsFromJson()).called(1);
    });

    test('should handle products with maximum integer ID', () async {
      // Arrange
      final maxIdProductModels = [
        ProductModel(
          id: 9223372036854775807,
          title: 'Max ID Product',
          description: 'Description',
          price: 10.0,
          image: 'https://example.com/maxid.jpg',
        ),
      ];

      when(mockDataSource.getProductsFromJson()).thenAnswer((_) async => maxIdProductModels);

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result.first.id, equals(9223372036854775807));
      verify(mockDataSource.getProductsFromJson()).called(1);
    });

    test('should handle products with minimum integer ID', () async {
      // Arrange
      final minIdProductModels = [
        ProductModel(
          id: -9223372036854775808,
          title: 'Min ID Product',
          description: 'Description',
          price: 10.0,
          image: 'https://example.com/minid.jpg',
        ),
      ];

      when(mockDataSource.getProductsFromJson()).thenAnswer((_) async => minIdProductModels);

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result.first.id, equals(-9223372036854775808));
      verify(mockDataSource.getProductsFromJson()).called(1);
    });

    test('should propagate data source exceptions', () async {
      // Arrange
      when(mockDataSource.getProductsFromJson()).thenThrow(Exception('Data source error'));

      // Act & Assert
      expect(() => repository.getProducts(), throwsException);
      verify(mockDataSource.getProductsFromJson()).called(1);
    });

    test('should handle data source timeout', () async {
      // Arrange
      when(mockDataSource.getProductsFromJson()).thenAnswer(
        (_) => Future.delayed(Duration(seconds: 5), () => <ProductModel>[]),
      );

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result, isEmpty);
      verify(mockDataSource.getProductsFromJson()).called(1);
    });

    test('should call data source multiple times when repository is called multiple times', () async {
      // Arrange
      final testProductModels = [
        ProductModel(
          id: 1,
          title: 'Test Product',
          description: 'Test Description',
          price: 29.99,
          image: 'https://example.com/image.jpg',
        ),
      ];

      when(mockDataSource.getProductsFromJson()).thenAnswer((_) async => testProductModels);

      // Act
      await repository.getProducts();
      await repository.getProducts();
      await repository.getProducts();

      // Assert
      verify(mockDataSource.getProductsFromJson()).called(3);
    });

    test('should handle data source returning null', () async {
      // Arrange
      when(mockDataSource.getProductsFromJson()).thenAnswer((_) async => null);

      // Act & Assert
      expect(() => repository.getProducts(), throwsA(isA<TypeError>()));
      verify(mockDataSource.getProductsFromJson()).called(1);
    });

    test('should handle data source returning list with null elements', () async {
      // Arrange
      final listWithNulls = [
        ProductModel(
          id: 1,
          title: 'Valid Product',
          description: 'Valid Description',
          price: 29.99,
          image: 'https://example.com/valid.jpg',
        ),
        null, // This would cause issues in real implementation
      ];

      when(mockDataSource.getProductsFromJson()).thenAnswer((_) async => listWithNulls );

      // Act & Assert
      expect(() => repository.getProducts(), throwsA(isA<TypeError>()));
      verify(mockDataSource.getProductsFromJson()).called(1);
    });

    test('should handle data source returning mixed data types', () async {
      // Arrange
      final mixedData = [
        ProductModel(
          id: 1,
          title: 'Valid Product',
          description: 'Valid Description',
          price: 29.99,
          image: 'https://example.com/valid.jpg',
        ),
        'invalid_string', // This would cause issues in real implementation
      ];

      when(mockDataSource.getProductsFromJson()).thenAnswer((_) async => mixedData);

      // Act & Assert
      expect(() => repository.getProducts(), throwsA(isA<TypeError>()));
      verify(mockDataSource.getProductsFromJson()).called(1);
    });

    test('should handle data source returning empty list multiple times', () async {
      // Arrange
      when(mockDataSource.getProductsFromJson()).thenAnswer((_) async => <ProductModel>[]);

      // Act
      final result1 = await repository.getProducts();
      final result2 = await repository.getProducts();
      final result3 = await repository.getProducts();

      // Assert
      expect(result1, isEmpty);
      expect(result2, isEmpty);
      expect(result3, isEmpty);
      verify(mockDataSource.getProductsFromJson()).called(3);
    });

    test('should handle data source returning different results on subsequent calls', () async {
      // Arrange
      final firstCall = [
        ProductModel(
          id: 1,
          title: 'First Product',
          description: 'First Description',
          price: 19.99,
          image: 'https://example.com/first.jpg',
        ),
      ];

      final secondCall = [
        ProductModel(
          id: 2,
          title: 'Second Product',
          description: 'Second Description',
          price: 29.99,
          image: 'https://example.com/second.jpg',
        ),
      ];

      when(mockDataSource.getProductsFromJson())
          .thenAnswer((_) async => firstCall)
          .thenAnswer((_) async => secondCall);

      // Act
      final result1 = await repository.getProducts();
      final result2 = await repository.getProducts();

      // Assert
      expect(result1.first.id, equals(1));
      expect(result1.first.title, equals('First Product'));
      expect(result2.first.id, equals(2));
      expect(result2.first.title, equals('Second Product'));
      verify(mockDataSource.getProductsFromJson()).called(2);
    });

    test('should handle data source returning very large list', () async {
      // Arrange
      final veryLargeList = List.generate(
        10000,
        (index) => ProductModel(
          id: index + 1,
          title: 'Product ${index + 1}',
          description: 'Description ${index + 1}',
          price: (index + 1) * 0.01,
          image: 'https://example.com/image${index + 1}.jpg',
        ),
      );

      when(mockDataSource.getProductsFromJson()).thenAnswer((_) async => veryLargeList);

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result, hasLength(10000));
      expect(result.first.id, equals(1));
      expect(result.last.id, equals(10000));
      verify(mockDataSource.getProductsFromJson()).called(1);
    });

    test('should handle data source returning products with very long strings', () async {
      // Arrange
      final longTitle = 'A' * 10000;
      final longDescription = 'B' * 20000;
      final longImage = 'C' * 5000;

      final longStringProducts = [
        ProductModel(
          id: 1,
          title: longTitle,
          description: longDescription,
          price: 10.0,
          image: longImage,
        ),
      ];

      when(mockDataSource.getProductsFromJson()).thenAnswer((_) async => longStringProducts);

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result.first.title, equals(longTitle));
      expect(result.first.description, equals(longDescription));
      expect(result.first.image, equals(longImage));
      verify(mockDataSource.getProductsFromJson()).called(1);
    });
  });
}


