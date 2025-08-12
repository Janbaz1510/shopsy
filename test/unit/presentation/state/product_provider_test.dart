import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shopsy/features/product/domain/entities/product.dart';
import 'package:shopsy/features/product/domain/usecases/get_products.dart';
import 'package:shopsy/features/product/presentation/state/product_provider.dart';

import 'product_provider_test.mocks.dart';

@GenerateMocks([GetProducts])
void main() {
  group('ProductProvider', () {
    late ProductProvider provider;
    late MockGetProducts mockGetProducts;

    setUp(() {
      mockGetProducts = MockGetProducts();
      provider = ProductProvider(mockGetProducts);
    });

    test('should initialize with empty products list and not loading', () {
      // Assert
      expect(provider.products, isEmpty);
      expect(provider.isLoading, isFalse);
    });

    test('should fetch products successfully', () async {
      // Arrange
      final testProducts = [
        Product(
          id: 1,
          title: 'Test Product 1',
          description: 'Test Description 1',
          price: 29.99,
          image: 'https://example.com/image1.jpg',
        ),
        Product(
          id: 2,
          title: 'Test Product 2',
          description: 'Test Description 2',
          price: 39.99,
          image: 'https://example.com/image2.jpg',
        ),
      ];

      when(mockGetProducts()).thenAnswer((_) async => testProducts);

      // Act
      await provider.fetchProducts();

      // Assert
      expect(provider.products, equals(testProducts));
      expect(provider.isLoading, isFalse);
      verify(mockGetProducts()).called(1);
    });

    test('should set loading state during fetch', () async {
      // Arrange
      final testProducts = [
        Product(
          id: 1,
          title: 'Test Product',
          description: 'Test Description',
          price: 29.99,
          image: 'https://example.com/image.jpg',
        ),
      ];

      when(mockGetProducts()).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 100));
        return testProducts;
      });

      // Act
      final future = provider.fetchProducts();

      // Assert - should be loading immediately after calling fetchProducts
      expect(provider.isLoading, isTrue);

      // Wait for the future to complete
      await future;

      // Assert - should not be loading after completion
      expect(provider.isLoading, isFalse);
      expect(provider.products, equals(testProducts));
    });

    test('should handle empty products list', () async {
      // Arrange
      when(mockGetProducts()).thenAnswer((_) async => <Product>[]);

      // Act
      await provider.fetchProducts();

      // Assert
      expect(provider.products, isEmpty);
      expect(provider.isLoading, isFalse);
      verify(mockGetProducts()).called(1);
    });

    test('should handle single product', () async {
      // Arrange
      final singleProduct = [
        Product(
          id: 1,
          title: 'Single Product',
          description: 'Single Description',
          price: 19.99,
          image: 'https://example.com/single.jpg',
        ),
      ];

      when(mockGetProducts()).thenAnswer((_) async => singleProduct);

      // Act
      await provider.fetchProducts();

      // Assert
      expect(provider.products, hasLength(1));
      expect(provider.products.first.id, equals(1));
      expect(provider.products.first.title, equals('Single Product'));
      expect(provider.isLoading, isFalse);
      verify(mockGetProducts()).called(1);
    });

    test('should handle large list of products', () async {
      // Arrange
      final largeProductList = List.generate(
        100,
        (index) => Product(
          id: index + 1,
          title: 'Product ${index + 1}',
          description: 'Description ${index + 1}',
          price: (index + 1) * 10.0,
          image: 'https://example.com/image${index + 1}.jpg',
        ),
      );

      when(mockGetProducts()).thenAnswer((_) async => largeProductList);

      // Act
      await provider.fetchProducts();

      // Assert
      expect(provider.products, hasLength(100));
      expect(provider.products.first.id, equals(1));
      expect(provider.products.last.id, equals(100));
      expect(provider.isLoading, isFalse);
      verify(mockGetProducts()).called(1);
    });

    test('should handle products with zero price', () async {
      // Arrange
      final freeProducts = [
        Product(
          id: 1,
          title: 'Free Product',
          description: 'Free Description',
          price: 0.0,
          image: 'https://example.com/free.jpg',
        ),
      ];

      when(mockGetProducts()).thenAnswer((_) async => freeProducts);

      // Act
      await provider.fetchProducts();

      // Assert
      expect(provider.products.first.price, equals(0.0));
      expect(provider.isLoading, isFalse);
      verify(mockGetProducts()).called(1);
    });

    test('should handle products with negative price', () async {
      // Arrange
      final discountedProducts = [
        Product(
          id: 1,
          title: 'Discounted Product',
          description: 'Discounted Description',
          price: -5.0,
          image: 'https://example.com/discounted.jpg',
        ),
      ];

      when(mockGetProducts()).thenAnswer((_) async => discountedProducts);

      // Act
      await provider.fetchProducts();

      // Assert
      expect(provider.products.first.price, equals(-5.0));
      expect(provider.isLoading, isFalse);
      verify(mockGetProducts()).called(1);
    });

    test('should handle products with very high price', () async {
      // Arrange
      final expensiveProducts = [
        Product(
          id: 1,
          title: 'Expensive Product',
          description: 'Very expensive',
          price: 999999.99,
          image: 'https://example.com/expensive.jpg',
        ),
      ];

      when(mockGetProducts()).thenAnswer((_) async => expensiveProducts);

      // Act
      await provider.fetchProducts();

      // Assert
      expect(provider.products.first.price, equals(999999.99));
      expect(provider.isLoading, isFalse);
      verify(mockGetProducts()).called(1);
    });

    test('should handle products with empty strings', () async {
      // Arrange
      final emptyProducts = [
        Product(
          id: 1,
          title: '',
          description: '',
          price: 10.0,
          image: '',
        ),
      ];

      when(mockGetProducts()).thenAnswer((_) async => emptyProducts);

      // Act
      await provider.fetchProducts();

      // Assert
      expect(provider.products.first.title, equals(''));
      expect(provider.products.first.description, equals(''));
      expect(provider.products.first.image, equals(''));
      expect(provider.isLoading, isFalse);
      verify(mockGetProducts()).called(1);
    });

    test('should handle products with special characters', () async {
      // Arrange
      final specialProducts = [
        Product(
          id: 1,
          title: 'Product with émojis 🛍️',
          description: 'Description with unicode: 中文 Español',
          price: 10.0,
          image: 'https://example.com/special.jpg',
        ),
      ];

      when(mockGetProducts()).thenAnswer((_) async => specialProducts);

      // Act
      await provider.fetchProducts();

      // Assert
      expect(provider.products.first.title, equals('Product with émojis 🛍️'));
      expect(provider.products.first.description, equals('Description with unicode: 中文 Español'));
      expect(provider.isLoading, isFalse);
      verify(mockGetProducts()).called(1);
    });

    test('should handle products with maximum integer ID', () async {
      // Arrange
      final maxIdProducts = [
        Product(
          id: 9223372036854775807,
          title: 'Max ID Product',
          description: 'Description',
          price: 10.0,
          image: 'https://example.com/maxid.jpg',
        ),
      ];

      when(mockGetProducts()).thenAnswer((_) async => maxIdProducts);

      // Act
      await provider.fetchProducts();

      // Assert
      expect(provider.products.first.id, equals(9223372036854775807));
      expect(provider.isLoading, isFalse);
      verify(mockGetProducts()).called(1);
    });

    test('should handle products with minimum integer ID', () async {
      // Arrange
      final minIdProducts = [
        Product(
          id: -9223372036854775808,
          title: 'Min ID Product',
          description: 'Description',
          price: 10.0,
          image: 'https://example.com/minid.jpg',
        ),
      ];

      when(mockGetProducts()).thenAnswer((_) async => minIdProducts);

      // Act
      await provider.fetchProducts();

      // Assert
      expect(provider.products.first.id, equals(-9223372036854775808));
      expect(provider.isLoading, isFalse);
      verify(mockGetProducts()).called(1);
    });

    test('should handle use case exceptions', () async {
      // Arrange
      when(mockGetProducts()).thenThrow(Exception('Use case error'));

      // Act & Assert
      expect(() => provider.fetchProducts(), throwsException);
      expect(provider.isLoading, isFalse);
      verify(mockGetProducts()).called(1);
    });

    test('should handle use case timeout', () async {
      // Arrange
      when(mockGetProducts()).thenAnswer(
        (_) => Future.delayed(Duration(seconds: 5), () => <Product>[]),
      );

      // Act
      await provider.fetchProducts();

      // Assert
      expect(provider.products, isEmpty);
      expect(provider.isLoading, isFalse);
      verify(mockGetProducts()).called(1);
    });

    test('should call use case multiple times when fetchProducts is called multiple times', () async {
      // Arrange
      final testProducts = [
        Product(
          id: 1,
          title: 'Test Product',
          description: 'Test Description',
          price: 29.99,
          image: 'https://example.com/image.jpg',
        ),
      ];

      when(mockGetProducts()).thenAnswer((_) async => testProducts);

      // Act
      await provider.fetchProducts();
      await provider.fetchProducts();
      await provider.fetchProducts();

      // Assert
      verify(mockGetProducts()).called(3);
    });

    test('should update products when fetchProducts is called multiple times with different data', () async {
      // Arrange
      final firstProducts = [
        Product(
          id: 1,
          title: 'First Product',
          description: 'First Description',
          price: 19.99,
          image: 'https://example.com/first.jpg',
        ),
      ];

      final secondProducts = [
        Product(
          id: 2,
          title: 'Second Product',
          description: 'Second Description',
          price: 29.99,
          image: 'https://example.com/second.jpg',
        ),
      ];

      when(mockGetProducts())
          .thenAnswer((_) async => firstProducts)
          .thenAnswer((_) async => secondProducts);

      // Act
      await provider.fetchProducts();

      // Assert first call
      expect(provider.products.first.id, equals(1));
      expect(provider.products.first.title, equals('First Product'));

      // Act second call
      await provider.fetchProducts();

      // Assert second call
      expect(provider.products.first.id, equals(2));
      expect(provider.products.first.title, equals('Second Product'));
      verify(mockGetProducts()).called(2);
    });

    test('should maintain loading state during concurrent fetchProducts calls', () async {
      // Arrange
      final testProducts = [
        Product(
          id: 1,
          title: 'Test Product',
          description: 'Test Description',
          price: 29.99,
          image: 'https://example.com/image.jpg',
        ),
      ];

      when(mockGetProducts()).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 100));
        return testProducts;
      });

      // Act
      final future1 = provider.fetchProducts();
      final future2 = provider.fetchProducts();

      // Assert - should be loading during concurrent calls
      expect(provider.isLoading, isTrue);

      // Wait for both futures to complete
      await future1;
      await future2;

      // Assert - should not be loading after completion
      expect(provider.isLoading, isFalse);
      expect(provider.products, equals(testProducts));
    });

    test('should handle very large list of products', () async {
      // Arrange
      final veryLargeList = List.generate(
        10000,
        (index) => Product(
          id: index + 1,
          title: 'Product ${index + 1}',
          description: 'Description ${index + 1}',
          price: (index + 1) * 0.01,
          image: 'https://example.com/image${index + 1}.jpg',
        ),
      );

      when(mockGetProducts()).thenAnswer((_) async => veryLargeList);

      // Act
      await provider.fetchProducts();

      // Assert
      expect(provider.products, hasLength(10000));
      expect(provider.products.first.id, equals(1));
      expect(provider.products.last.id, equals(10000));
      expect(provider.isLoading, isFalse);
      verify(mockGetProducts()).called(1);
    });

    test('should handle products with very long strings', () async {
      // Arrange
      final longTitle = 'A' * 10000;
      final longDescription = 'B' * 20000;
      final longImage = 'C' * 5000;

      final longStringProducts = [
        Product(
          id: 1,
          title: longTitle,
          description: longDescription,
          price: 10.0,
          image: longImage,
        ),
      ];

      when(mockGetProducts()).thenAnswer((_) async => longStringProducts);

      // Act
      await provider.fetchProducts();

      // Assert
      expect(provider.products.first.title, equals(longTitle));
      expect(provider.products.first.description, equals(longDescription));
      expect(provider.products.first.image, equals(longImage));
      expect(provider.isLoading, isFalse);
      verify(mockGetProducts()).called(1);
    });

    test('should reset loading state when use case throws exception', () async {
      // Arrange
      when(mockGetProducts()).thenThrow(Exception('Use case error'));

      // Act & Assert
      expect(() => provider.fetchProducts(), throwsException);
      expect(provider.isLoading, isFalse);
      expect(provider.products, isEmpty);
      verify(mockGetProducts()).called(1);
    });

    test('should maintain empty products list when use case returns empty list', () async {
      // Arrange
      when(mockGetProducts()).thenAnswer((_) async => <Product>[]);

      // Act
      await provider.fetchProducts();

      // Assert
      expect(provider.products, isEmpty);
      expect(provider.isLoading, isFalse);
      verify(mockGetProducts()).called(1);
    });
  });
}


