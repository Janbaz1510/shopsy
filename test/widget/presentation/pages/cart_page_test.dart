import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shopsy/features/product/domain/entities/product.dart';
import 'package:shopsy/features/product/presentation/state/cart_provider.dart';
import 'package:shopsy/features/product/presentation/pages/cart_page.dart';

void main() {
  group('CartPage', () {
    late CartProvider cartProvider;
    late Product testProduct1;
    late Product testProduct2;

    setUp(() {
      cartProvider = CartProvider();
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

    Widget createTestWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<CartProvider>.value(
          value: cartProvider,
          child: CartPage(),
        ),
      );
    }

    testWidgets('should display empty cart message when cart is empty', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('Add some products to get started!'), findsOneWidget);
    });

    testWidgets('should display app bar with title', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Cart'), findsOneWidget);
    });

    testWidgets('should display back button in app bar', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should display cart items when cart has products', (WidgetTester tester) async {
      // Arrange
      cartProvider.addProduct(testProduct1);
      cartProvider.addProduct(testProduct2);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Test Product 1'), findsOneWidget);
      expect(find.text('Test Product 2'), findsOneWidget);
      expect(find.text('\$29.99'), findsOneWidget);
      expect(find.text('\$39.99'), findsOneWidget);
    });

    testWidgets('should display quantity for cart items', (WidgetTester tester) async {
      // Arrange
      cartProvider.addProduct(testProduct1);
      cartProvider.addProduct(testProduct1); // quantity = 2

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('should display total price correctly', (WidgetTester tester) async {
      // Arrange
      cartProvider.addProduct(testProduct1);
      cartProvider.addProduct(testProduct2);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Total: \${(29.99 + 39.99).toStringAsFixed(2)}'), findsOneWidget);
    });

    testWidgets('should display increase quantity button', (WidgetTester tester) async {
      // Arrange
      cartProvider.addProduct(testProduct1);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should increase quantity when add button is tapped', (WidgetTester tester) async {
      // Arrange
      cartProvider.addProduct(testProduct1);

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Assert
      expect(cartProvider.items.first.quantity, equals(2));
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('should display decrease quantity button', (WidgetTester tester) async {
      // Arrange
      cartProvider.addProduct(testProduct1);
      cartProvider.addProduct(testProduct1); // quantity = 2

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byIcon(Icons.remove), findsOneWidget);
    });

    testWidgets('should decrease quantity when remove button is tapped', (WidgetTester tester) async {
      // Arrange
      cartProvider.addProduct(testProduct1);
      cartProvider.addProduct(testProduct1); // quantity = 2

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      // Assert
      expect(cartProvider.items.first.quantity, equals(1));
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('should remove item when quantity becomes zero', (WidgetTester tester) async {
      // Arrange
      cartProvider.addProduct(testProduct1);

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      // Assert
      expect(cartProvider.items.isEmpty, isTrue);
      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('should display remove item button', (WidgetTester tester) async {
      // Arrange
      cartProvider.addProduct(testProduct1);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('should remove item when delete button is tapped', (WidgetTester tester) async {
      // Arrange
      cartProvider.addProduct(testProduct1);

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Assert
      expect(cartProvider.items.isEmpty, isTrue);
      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('should display clear cart button when cart has items', (WidgetTester tester) async {
      // Arrange
      cartProvider.addProduct(testProduct1);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Clear Cart'), findsOneWidget);
    });

    testWidgets('should clear cart when clear cart button is tapped', (WidgetTester tester) async {
      // Arrange
      cartProvider.addProduct(testProduct1);
      cartProvider.addProduct(testProduct2);

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.text('Clear Cart'));
      await tester.pumpAndSettle();

      // Assert
      expect(cartProvider.items.isEmpty, isTrue);
      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('should navigate back when back button is tapped', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CartPage), findsNothing);
    });

    testWidgets('should handle multiple items with different quantities', (WidgetTester tester) async {
      // Arrange
      cartProvider.addProduct(testProduct1);
      cartProvider.addProduct(testProduct1); // quantity = 2
      cartProvider.addProduct(testProduct2);
      cartProvider.addProduct(testProduct2); // quantity = 2
      cartProvider.addProduct(testProduct2); // quantity = 3

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('2'), findsOneWidget); // quantity for product 1
      expect(find.text('3'), findsOneWidget); // quantity for product 2
      final expectedTotal = (29.99 * 2) + (39.99 * 3);
      expect(find.text('Total: \${expectedTotal.toStringAsFixed(2)}'), findsOneWidget);
    });

    testWidgets('should handle products with zero price', (WidgetTester tester) async {
      // Arrange
      final freeProduct = Product(
        id: 3,
        title: 'Free Product',
        description: 'Free Description',
        price: 0.0,
        image: 'https://example.com/free.jpg',
      );
      cartProvider.addProduct(freeProduct);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Free Product'), findsOneWidget);
      expect(find.text('\$0.00'), findsOneWidget);
      expect(find.text('Total: \$0.00'), findsOneWidget);
    });

    testWidgets('should handle products with negative price', (WidgetTester tester) async {
      // Arrange
      final discountedProduct = Product(
        id: 4,
        title: 'Discounted Product',
        description: 'Discounted Description',
        price: -5.0,
        image: 'https://example.com/discounted.jpg',
      );
      cartProvider.addProduct(discountedProduct);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Discounted Product'), findsOneWidget);
      expect(find.text('-\$5.00'), findsOneWidget);
      expect(find.text('Total: -\$5.00'), findsOneWidget);
    });

    testWidgets('should handle products with very high price', (WidgetTester tester) async {
      // Arrange
      final expensiveProduct = Product(
        id: 5,
        title: 'Expensive Product',
        description: 'Very expensive',
        price: 999999.99,
        image: 'https://example.com/expensive.jpg',
      );
      cartProvider.addProduct(expensiveProduct);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Expensive Product'), findsOneWidget);
      expect(find.text('\$999,999.99'), findsOneWidget);
      expect(find.text('Total: \$999,999.99'), findsOneWidget);
    });

    testWidgets('should handle products with empty strings', (WidgetTester tester) async {
      // Arrange
      final emptyProduct = Product(
        id: 6,
        title: '',
        description: '',
        price: 10.0,
        image: '',
      );
      cartProvider.addProduct(emptyProduct);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('\$10.00'), findsOneWidget);
      expect(find.text('Total: \$10.00'), findsOneWidget);
    });

    testWidgets('should handle products with special characters', (WidgetTester tester) async {
      // Arrange
      final specialProduct = Product(
        id: 7,
        title: 'Product with émojis 🛍️',
        description: 'Description with unicode: 中文 Español',
        price: 10.0,
        image: 'https://example.com/special.jpg',
      );
      cartProvider.addProduct(specialProduct);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Product with émojis 🛍️'), findsOneWidget);
      expect(find.text('Description with unicode: 中文 Español'), findsOneWidget);
      expect(find.text('\$10.00'), findsOneWidget);
    });

    testWidgets('should handle products with maximum integer ID', (WidgetTester tester) async {
      // Arrange
      final maxIdProduct = Product(
        id: 9223372036854775807,
        title: 'Max ID Product',
        description: 'Description',
        price: 10.0,
        image: 'https://example.com/maxid.jpg',
      );
      cartProvider.addProduct(maxIdProduct);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Max ID Product'), findsOneWidget);
      expect(find.text('\$10.00'), findsOneWidget);
    });

    testWidgets('should handle products with minimum integer ID', (WidgetTester tester) async {
      // Arrange
      final minIdProduct = Product(
        id: -9223372036854775808,
        title: 'Min ID Product',
        description: 'Description',
        price: 10.0,
        image: 'https://example.com/minid.jpg',
      );
      cartProvider.addProduct(minIdProduct);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Min ID Product'), findsOneWidget);
      expect(find.text('\$10.00'), findsOneWidget);
    });

    testWidgets('should handle very large quantities', (WidgetTester tester) async {
      // Arrange
      for (int i = 0; i < 100; i++) {
        cartProvider.addProduct(testProduct1);
      }

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('100'), findsOneWidget);
      final expectedTotal = 29.99 * 100;
      expect(find.text('Total: \${expectedTotal.toStringAsFixed(2)}'), findsOneWidget);
    });

    testWidgets('should handle very small price values', (WidgetTester tester) async {
      // Arrange
      final cheapProduct = Product(
        id: 8,
        title: 'Cheap Product',
        description: 'Very cheap',
        price: 0.01,
        image: 'https://example.com/cheap.jpg',
      );
      cartProvider.addProduct(cheapProduct);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Cheap Product'), findsOneWidget);
      expect(find.text('\$0.01'), findsOneWidget);
      expect(find.text('Total: \$0.01'), findsOneWidget);
    });

    testWidgets('should handle precise price calculations', (WidgetTester tester) async {
      // Arrange
      final preciseProduct = Product(
        id: 9,
        title: 'Precise Product',
        description: 'Precise Description',
        price: 0.3333333333333333,
        image: 'https://example.com/precise.jpg',
      );
      cartProvider.addProduct(preciseProduct);
      cartProvider.addProduct(preciseProduct); // quantity = 2

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Precise Product'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      final expectedTotal = 0.3333333333333333 * 2;
      expect(find.text('Total: \${expectedTotal.toStringAsFixed(2)}'), findsOneWidget);
    });

    testWidgets('should handle complex cart operations', (WidgetTester tester) async {
      // Arrange
      cartProvider.addProduct(testProduct1);
      cartProvider.addProduct(testProduct2);
      cartProvider.addProduct(testProduct1); // quantity = 2
      cartProvider.addProduct(testProduct2); // quantity = 2

      // Act
      await tester.pumpWidget(createTestWidget());
      
      // Remove one item from product 1
      await tester.tap(find.byIcon(Icons.remove).first);
      await tester.pumpAndSettle();

      // Remove one item from product 2
      await tester.tap(find.byIcon(Icons.remove).last);
      await tester.pumpAndSettle();

      // Assert
      expect(cartProvider.items.length, equals(2));
      expect(cartProvider.items.first.quantity, equals(1));
      expect(cartProvider.items.last.quantity, equals(1));
      final expectedTotal = 29.99 + 39.99;
      expect(find.text('Total: \${expectedTotal.toStringAsFixed(2)}'), findsOneWidget);
    });

    testWidgets('should handle products with very long strings', (WidgetTester tester) async {
      // Arrange
      final longTitle = 'A' * 1000;
      final longDescription = 'B' * 2000;
      final longStringProduct = Product(
        id: 10,
        title: longTitle,
        description: longDescription,
        price: 10.0,
        image: 'https://example.com/long.jpg',
      );
      cartProvider.addProduct(longStringProduct);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text(longTitle), findsOneWidget);
      expect(find.text(longDescription), findsOneWidget);
      expect(find.text('\$10.00'), findsOneWidget);
    });

    testWidgets('should handle products with newlines in description', (WidgetTester tester) async {
      // Arrange
      final newlineProduct = Product(
        id: 11,
        title: 'Newline Product',
        description: 'Line 1\nLine 2\nLine 3',
        price: 10.0,
        image: 'https://example.com/newline.jpg',
      );
      cartProvider.addProduct(newlineProduct);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Newline Product'), findsOneWidget);
      expect(find.text('Line 1\nLine 2\nLine 3'), findsOneWidget);
    });

    testWidgets('should handle products with tabs in description', (WidgetTester tester) async {
      // Arrange
      final tabProduct = Product(
        id: 12,
        title: 'Tab Product',
        description: 'Tab\tSeparated\tDescription',
        price: 10.0,
        image: 'https://example.com/tab.jpg',
      );
      cartProvider.addProduct(tabProduct);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Tab Product'), findsOneWidget);
      expect(find.text('Tab\tSeparated\tDescription'), findsOneWidget);
    });
  });
}
