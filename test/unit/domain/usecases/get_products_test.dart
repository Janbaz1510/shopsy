import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shopsy/features/product/domain/entities/product.dart';
import 'package:shopsy/features/product/domain/repositories/product_repository.dart';
import 'package:shopsy/features/product/domain/usecases/get_products.dart';

import 'get_products_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  group('GetProducts Use Case', () {
    late GetProducts useCase;
    late MockProductRepository mockRepository;

    setUp(() {
      mockRepository = MockProductRepository();
      useCase = GetProducts(mockRepository);
    });

    test('should get products from repository', () async {
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

      when(mockRepository.getProducts()).thenAnswer((_) async => testProducts);

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(testProducts));
      verify(mockRepository.getProducts()).called(1);
    });

    test('should return empty list when repository returns empty list', () async {
      // Arrange
      when(mockRepository.getProducts()).thenAnswer((_) async => <Product>[]);

      // Act
      final result = await useCase();

      // Assert
      expect(result, isEmpty);
      verify(mockRepository.getProducts()).called(1);
    });

    test('should return single product when repository returns single product', () async {
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

      when(mockRepository.getProducts()).thenAnswer((_) async => singleProduct);

      // Act
      final result = await useCase();

      // Assert
      expect(result, hasLength(1));
      expect(result.first.id, equals(1));
      expect(result.first.title, equals('Single Product'));
      verify(mockRepository.getProducts()).called(1);
    });

    test('should return large list of products', () async {
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

      when(mockRepository.getProducts()).thenAnswer((_) async => largeProductList);

      // Act
      final result = await useCase();

      // Assert
      expect(result, hasLength(100));
      expect(result.first.id, equals(1));
      expect(result.last.id, equals(100));
      verify(mockRepository.getProducts()).called(1);
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

      when(mockRepository.getProducts()).thenAnswer((_) async => freeProducts);

      // Act
      final result = await useCase();

      // Assert
      expect(result.first.price, equals(0.0));
      verify(mockRepository.getProducts()).called(1);
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

      when(mockRepository.getProducts()).thenAnswer((_) async => discountedProducts);

      // Act
      final result = await useCase();

      // Assert
      expect(result.first.price, equals(-5.0));
      verify(mockRepository.getProducts()).called(1);
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

      when(mockRepository.getProducts()).thenAnswer((_) async => expensiveProducts);

      // Act
      final result = await useCase();

      // Assert
      expect(result.first.price, equals(999999.99));
      verify(mockRepository.getProducts()).called(1);
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

      when(mockRepository.getProducts()).thenAnswer((_) async => emptyProducts);

      // Act
      final result = await useCase();

      // Assert
      expect(result.first.title, equals(''));
      expect(result.first.description, equals(''));
      expect(result.first.image, equals(''));
      verify(mockRepository.getProducts()).called(1);
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

      when(mockRepository.getProducts()).thenAnswer((_) async => specialProducts);

      // Act
      final result = await useCase();

      // Assert
      expect(result.first.title, equals('Product with émojis 🛍️'));
      expect(result.first.description, equals('Description with unicode: 中文 Español'));
      verify(mockRepository.getProducts()).called(1);
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

      when(mockRepository.getProducts()).thenAnswer((_) async => maxIdProducts);

      // Act
      final result = await useCase();

      // Assert
      expect(result.first.id, equals(9223372036854775807));
      verify(mockRepository.getProducts()).called(1);
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

      when(mockRepository.getProducts()).thenAnswer((_) async => minIdProducts);

      // Act
      final result = await useCase();

      // Assert
      expect(result.first.id, equals(-9223372036854775808));
      verify(mockRepository.getProducts()).called(1);
    });

    test('should propagate repository exceptions', () async {
      // Arrange
      when(mockRepository.getProducts()).thenThrow(Exception('Repository error'));

      // Act & Assert
      expect(() => useCase(), throwsException);
      verify(mockRepository.getProducts()).called(1);
    });

    test('should handle repository timeout', () async {
      // Arrange
      when(mockRepository.getProducts()).thenAnswer(
        (_) => Future.delayed(Duration(seconds: 5), () => <Product>[]),
      );

      // Act
      final result = await useCase();

      // Assert
      expect(result, isEmpty);
      verify(mockRepository.getProducts()).called(1);
    });

    test('should call repository multiple times when use case is called multiple times', () async {
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

      when(mockRepository.getProducts()).thenAnswer((_) async => testProducts);

      // Act
      await useCase();
      await useCase();
      await useCase();

      // Assert
      verify(mockRepository.getProducts()).called(3);
    });
  });
}


