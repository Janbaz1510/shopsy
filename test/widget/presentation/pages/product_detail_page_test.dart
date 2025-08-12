import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shopsy/features/product/domain/entities/product.dart';
import 'package:shopsy/features/product/presentation/state/cart_provider.dart';
import 'package:shopsy/features/product/presentation/pages/product_detail_page.dart';

void main() {
  group('ProductDetailPage', () {
    late CartProvider cartProvider;
    late Product testProduct;

    setUp(() {
      cartProvider = CartProvider();
      testProduct = Product(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        price: 29.99,
        image: 'https://example.com/image.jpg',
      );
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<CartProvider>.value(
          value: cartProvider,
          child: ProductDetailPage(product: testProduct),
        ),
      );
    }

    testWidgets('should display product details correctly', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('\$29.99'), findsOneWidget);
    });

    testWidgets('should display app bar with back button', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should display product image', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should display add to cart button', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Add to Cart'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should add product to cart when add to cart button is tapped', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      // Assert
      expect(cartProvider.items.length, equals(1));
      expect(cartProvider.items.first.product.id, equals(1));
      expect(cartProvider.items.first.quantity, equals(1));
    });

    testWidgets('should increase quantity when add to cart button is tapped multiple times', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.text('Add to Cart'));
      await tester.tap(find.text('Add to Cart'));
      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      // Assert
      expect(cartProvider.items.length, equals(1));
      expect(cartProvider.items.first.quantity, equals(3));
    });

    testWidgets('should navigate back when back button is tapped', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ProductDetailPage), findsNothing);
    });

    testWidgets('should display product with zero price', (WidgetTester tester) async {
      // Arrange
      final freeProduct = Product(
        id: 2,
        title: 'Free Product',
        description: 'Free Description',
        price: 0.0,
        image: 'https://example.com/free.jpg',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CartProvider>.value(
            value: cartProvider,
            child: ProductDetailPage(product: freeProduct),
          ),
        ),
      );

      // Assert
      expect(find.text('Free Product'), findsOneWidget);
      expect(find.text('\$0.00'), findsOneWidget);
    });

    testWidgets('should display product with negative price', (WidgetTester tester) async {
      // Arrange
      final discountedProduct = Product(
        id: 3,
        title: 'Discounted Product',
        description: 'Discounted Description',
        price: -5.0,
        image: 'https://example.com/discounted.jpg',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CartProvider>.value(
            value: cartProvider,
            child: ProductDetailPage(product: discountedProduct),
          ),
        ),
      );

      // Assert
      expect(find.text('Discounted Product'), findsOneWidget);
      expect(find.text('-\$5.00'), findsOneWidget);
    });

    testWidgets('should display product with very high price', (WidgetTester tester) async {
      // Arrange
      final expensiveProduct = Product(
        id: 4,
        title: 'Expensive Product',
        description: 'Very expensive',
        price: 999999.99,
        image: 'https://example.com/expensive.jpg',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CartProvider>.value(
            value: cartProvider,
            child: ProductDetailPage(product: expensiveProduct),
          ),
        ),
      );

      // Assert
      expect(find.text('Expensive Product'), findsOneWidget);
      expect(find.text('\$999,999.99'), findsOneWidget);
    });

    testWidgets('should display product with empty strings', (WidgetTester tester) async {
      // Arrange
      final emptyProduct = Product(
        id: 5,
        title: '',
        description: '',
        price: 10.0,
        image: '',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CartProvider>.value(
            value: cartProvider,
            child: ProductDetailPage(product: emptyProduct),
          ),
        ),
      );

      // Assert
      expect(find.text('\$10.00'), findsOneWidget);
    });

    testWidgets('should display product with special characters', (WidgetTester tester) async {
      // Arrange
      final specialProduct = Product(
        id: 6,
        title: 'Product with émojis 🛍️',
        description: 'Description with unicode: 中文 Español Français',
        price: 10.0,
        image: 'https://example.com/special.jpg',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CartProvider>.value(
            value: cartProvider,
            child: ProductDetailPage(product: specialProduct),
          ),
        ),
      );

      // Assert
      expect(find.text('Product with émojis 🛍️'), findsOneWidget);
      expect(find.text('Description with unicode: 中文 Español Français'), findsOneWidget);
    });

    testWidgets('should display product with very long description', (WidgetTester tester) async {
      // Arrange
      final longDescription = 'A' * 1000;
      final longProduct = Product(
        id: 7,
        title: 'Long Description Product',
        description: longDescription,
        price: 10.0,
        image: 'https://example.com/long.jpg',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CartProvider>.value(
            value: cartProvider,
            child: ProductDetailPage(product: longProduct),
          ),
        ),
      );

      // Assert
      expect(find.text('Long Description Product'), findsOneWidget);
      expect(find.text(longDescription), findsOneWidget);
    });

    testWidgets('should display product with maximum integer ID', (WidgetTester tester) async {
      // Arrange
      final maxIdProduct = Product(
        id: 9223372036854775807,
        title: 'Max ID Product',
        description: 'Description',
        price: 10.0,
        image: 'https://example.com/maxid.jpg',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CartProvider>.value(
            value: cartProvider,
            child: ProductDetailPage(product: maxIdProduct),
          ),
        ),
      );

      // Assert
      expect(find.text('Max ID Product'), findsOneWidget);
      expect(find.text('\$10.00'), findsOneWidget);
    });

    testWidgets('should display product with minimum integer ID', (WidgetTester tester) async {
      // Arrange
      final minIdProduct = Product(
        id: -9223372036854775808,
        title: 'Min ID Product',
        description: 'Description',
        price: 10.0,
        image: 'https://example.com/minid.jpg',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CartProvider>.value(
            value: cartProvider,
            child: ProductDetailPage(product: minIdProduct),
          ),
        ),
      );

      // Assert
      expect(find.text('Min ID Product'), findsOneWidget);
      expect(find.text('\$10.00'), findsOneWidget);
    });

    testWidgets('should display product with very small price', (WidgetTester tester) async {
      // Arrange
      final cheapProduct = Product(
        id: 8,
        title: 'Cheap Product',
        description: 'Very cheap',
        price: 0.01,
        image: 'https://example.com/cheap.jpg',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CartProvider>.value(
            value: cartProvider,
            child: ProductDetailPage(product: cheapProduct),
          ),
        ),
      );

      // Assert
      expect(find.text('Cheap Product'), findsOneWidget);
      expect(find.text('\$0.01'), findsOneWidget);
    });

    testWidgets('should display product with precise price', (WidgetTester tester) async {
      // Arrange
      final preciseProduct = Product(
        id: 9,
        title: 'Precise Product',
        description: 'Precise Description',
        price: 0.3333333333333333,
        image: 'https://example.com/precise.jpg',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CartProvider>.value(
            value: cartProvider,
            child: ProductDetailPage(product: preciseProduct),
          ),
        ),
      );

      // Assert
      expect(find.text('Precise Product'), findsOneWidget);
      expect(find.text('\$0.33'), findsOneWidget);
    });

    testWidgets('should handle multiple add to cart operations', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      
      // Add product multiple times
      for (int i = 0; i < 10; i++) {
        await tester.tap(find.text('Add to Cart'));
        await tester.pumpAndSettle();
      }

      // Assert
      expect(cartProvider.items.length, equals(1));
      expect(cartProvider.items.first.quantity, equals(10));
      expect(cartProvider.totalPrice, equals(29.99 * 10));
    });

    testWidgets('should display product with newlines in description', (WidgetTester tester) async {
      // Arrange
      final newlineProduct = Product(
        id: 10,
        title: 'Newline Product',
        description: 'Line 1\nLine 2\nLine 3',
        price: 10.0,
        image: 'https://example.com/newline.jpg',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CartProvider>.value(
            value: cartProvider,
            child: ProductDetailPage(product: newlineProduct),
          ),
        ),
      );

      // Assert
      expect(find.text('Newline Product'), findsOneWidget);
      expect(find.text('Line 1\nLine 2\nLine 3'), findsOneWidget);
    });

    testWidgets('should display product with tabs in description', (WidgetTester tester) async {
      // Arrange
      final tabProduct = Product(
        id: 11,
        title: 'Tab Product',
        description: 'Tab\tSeparated\tDescription',
        price: 10.0,
        image: 'https://example.com/tab.jpg',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CartProvider>.value(
            value: cartProvider,
            child: ProductDetailPage(product: tabProduct),
          ),
        ),
      );

      // Assert
      expect(find.text('Tab Product'), findsOneWidget);
      expect(find.text('Tab\tSeparated\tDescription'), findsOneWidget);
    });

    testWidgets('should display product with whitespace in title', (WidgetTester tester) async {
      // Arrange
      final whitespaceProduct = Product(
        id: 12,
        title: '  Product with Whitespace  ',
        description: 'Description',
        price: 10.0,
        image: 'https://example.com/whitespace.jpg',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CartProvider>.value(
            value: cartProvider,
            child: ProductDetailPage(product: whitespaceProduct),
          ),
        ),
      );

      // Assert
      expect(find.text('  Product with Whitespace  '), findsOneWidget);
    });

    testWidgets('should handle product with very long title', (WidgetTester tester) async {
      // Arrange
      final longTitle = 'A' * 500;
      final longTitleProduct = Product(
        id: 13,
        title: longTitle,
        description: 'Description',
        price: 10.0,
        image: 'https://example.com/longtitle.jpg',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CartProvider>.value(
            value: cartProvider,
            child: ProductDetailPage(product: longTitleProduct),
          ),
        ),
      );

      // Assert
      expect(find.text(longTitle), findsOneWidget);
    });

    testWidgets('should handle product with very long image URL', (WidgetTester tester) async {
      // Arrange
      final longImageUrl = 'https://example.com/' + 'a' * 1000 + '.jpg';
      final longImageProduct = Product(
        id: 14,
        title: 'Long Image Product',
        description: 'Description',
        price: 10.0,
        image: longImageUrl,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CartProvider>.value(
            value: cartProvider,
            child: ProductDetailPage(product: longImageProduct),
          ),
        ),
      );

      // Assert
      expect(find.text('Long Image Product'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });
  });
}
