import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shopsy/features/product/domain/entities/product.dart';
import 'package:shopsy/features/product/domain/usecases/get_products.dart';
import 'package:shopsy/features/product/presentation/state/product_provider.dart';
import 'package:shopsy/features/product/presentation/state/cart_provider.dart';
import 'package:shopsy/features/product/presentation/pages/product_list_page.dart';
import 'package:shopsy/features/product/presentation/pages/cart_page.dart';
import 'package:shopsy/features/product/presentation/pages/product_detail_page.dart';

import 'product_list_page_test.mocks.dart';

@GenerateMocks([GetProducts])
void main() {
  group('ProductListPage', () {
    late MockGetProducts mockGetProducts;
    late ProductProvider productProvider;
    late CartProvider cartProvider;

    setUp(() {
      mockGetProducts = MockGetProducts();
      productProvider = ProductProvider(mockGetProducts);
      cartProvider = CartProvider();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<ProductProvider>.value(value: productProvider),
            ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
          ],
          child: ProductListPage(),
        ),
      );
    }

    testWidgets('should display loading indicator when products are loading', (WidgetTester tester) async {
      // Arrange
      when(mockGetProducts()).thenAnswer((_) async {
        await Future.delayed(Duration(seconds: 1));
        return <Product>[];
      });

      // Act
      await tester.pumpWidget(createTestWidget());
      await productProvider.fetchProducts();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display products when loaded successfully', (WidgetTester tester) async {
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
      await tester.pumpWidget(createTestWidget());
      await productProvider.fetchProducts();
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test Product 1'), findsOneWidget);
      expect(find.text('Test Product 2'), findsOneWidget);
      expect(find.text('\$29.99'), findsOneWidget);
      expect(find.text('\$39.99'), findsOneWidget);
    });

    testWidgets('should display empty state when no products', (WidgetTester tester) async {
      // Arrange
      when(mockGetProducts()).thenAnswer((_) async => <Product>[]);

      // Act
      await tester.pumpWidget(createTestWidget());
      await productProvider.fetchProducts();
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No products available'), findsOneWidget);
    });

    testWidgets('should display app bar with title', (WidgetTester tester) async {
      // Arrange
      when(mockGetProducts()).thenAnswer((_) async => <Product>[]);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Shopsy'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display cart icon in app bar', (WidgetTester tester) async {
      // Arrange
      when(mockGetProducts()).thenAnswer((_) async => <Product>[]);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    });

    testWidgets('should navigate to cart page when cart icon is tapped', (WidgetTester tester) async {
      // Arrange
      when(mockGetProducts()).thenAnswer((_) async => <Product>[]);

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CartPage), findsOneWidget);
    });

    testWidgets('should display product cards with correct information', (WidgetTester tester) async {
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
      await tester.pumpWidget(createTestWidget());
      await productProvider.fetchProducts();
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('\$29.99'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should navigate to product detail page when product is tapped', (WidgetTester tester) async {
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
      await tester.pumpWidget(createTestWidget());
      await productProvider.fetchProducts();
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Card));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ProductDetailPage), findsOneWidget);
    });

    testWidgets('should display add to cart button for each product', (WidgetTester tester) async {
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
      await tester.pumpWidget(createTestWidget());
      await productProvider.fetchProducts();
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Add to Cart'), findsOneWidget);
    });

    testWidgets('should add product to cart when add to cart button is tapped', (WidgetTester tester) async {
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
      await tester.pumpWidget(createTestWidget());
      await productProvider.fetchProducts();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      // Assert
      expect(cartProvider.items.length, equals(1));
      expect(cartProvider.items.first.product.id, equals(1));
      expect(cartProvider.items.first.quantity, equals(1));
    });

    testWidgets('should display error message when products fail to load', (WidgetTester tester) async {
      // Arrange
      when(mockGetProducts()).thenThrow(Exception('Failed to load products'));

      // Act
      await tester.pumpWidget(createTestWidget());
      await productProvider.fetchProducts();
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Error loading products'), findsOneWidget);
    });

    testWidgets('should display multiple products in grid layout', (WidgetTester tester) async {
      // Arrange
      final testProducts = List.generate(
        6,
        (index) => Product(
          id: index + 1,
          title: 'Product ${index + 1}',
          description: 'Description ${index + 1}',
          price: (index + 1) * 10.0,
          image: 'https://example.com/image${index + 1}.jpg',
        ),
      );

      when(mockGetProducts()).thenAnswer((_) async => testProducts);

      // Act
      await tester.pumpWidget(createTestWidget());
      await productProvider.fetchProducts();
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsNWidgets(6));
      expect(find.text('Product 1'), findsOneWidget);
      expect(find.text('Product 6'), findsOneWidget);
    });

    testWidgets('should display products with zero price', (WidgetTester tester) async {
      // Arrange
      final testProducts = [
        Product(
          id: 1,
          title: 'Free Product',
          description: 'Free Description',
          price: 0.0,
          image: 'https://example.com/free.jpg',
        ),
      ];

      when(mockGetProducts()).thenAnswer((_) async => testProducts);

      // Act
      await tester.pumpWidget(createTestWidget());
      await productProvider.fetchProducts();
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Free Product'), findsOneWidget);
      expect(find.text('\$0.00'), findsOneWidget);
    });

    testWidgets('should display products with negative price', (WidgetTester tester) async {
      // Arrange
      final testProducts = [
        Product(
          id: 1,
          title: 'Discounted Product',
          description: 'Discounted Description',
          price: -5.0,
          image: 'https://example.com/discounted.jpg',
        ),
      ];

      when(mockGetProducts()).thenAnswer((_) async => testProducts);

      // Act
      await tester.pumpWidget(createTestWidget());
      await productProvider.fetchProducts();
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Discounted Product'), findsOneWidget);
      expect(find.text('-\$5.00'), findsOneWidget);
    });

    testWidgets('should display products with very high price', (WidgetTester tester) async {
      // Arrange
      final testProducts = [
        Product(
          id: 1,
          title: 'Expensive Product',
          description: 'Very expensive',
          price: 999999.99,
          image: 'https://example.com/expensive.jpg',
        ),
      ];

      when(mockGetProducts()).thenAnswer((_) async => testProducts);

      // Act
      await tester.pumpWidget(createTestWidget());
      await productProvider.fetchProducts();
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Expensive Product'), findsOneWidget);
      expect(find.text('\$999,999.99'), findsOneWidget);
    });

    testWidgets('should display products with empty strings', (WidgetTester tester) async {
      // Arrange
      final testProducts = [
        Product(
          id: 1,
          title: '',
          description: '',
          price: 10.0,
          image: '',
        ),
      ];

      when(mockGetProducts()).thenAnswer((_) async => testProducts);

      // Act
      await tester.pumpWidget(createTestWidget());
      await productProvider.fetchProducts();
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should display products with special characters', (WidgetTester tester) async {
      // Arrange
      final testProducts = [
        Product(
          id: 1,
          title: 'Product with émojis 🛍️',
          description: 'Description with unicode: 中文 Español',
          price: 10.0,
          image: 'https://example.com/special.jpg',
        ),
      ];

      when(mockGetProducts()).thenAnswer((_) async => testProducts);

      // Act
      await tester.pumpWidget(createTestWidget());
      await productProvider.fetchProducts();
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Product with émojis 🛍️'), findsOneWidget);
      expect(find.text('Description with unicode: 中文 Español'), findsOneWidget);
    });

    testWidgets('should handle very large number of products', (WidgetTester tester) async {
      // Arrange
      final testProducts = List.generate(
        100,
        (index) => Product(
          id: index + 1,
          title: 'Product ${index + 1}',
          description: 'Description ${index + 1}',
          price: (index + 1) * 0.01,
          image: 'https://example.com/image${index + 1}.jpg',
        ),
      );

      when(mockGetProducts()).thenAnswer((_) async => testProducts);

      // Act
      await tester.pumpWidget(createTestWidget());
      await productProvider.fetchProducts();
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsNWidgets(100));
    });
  });
}


