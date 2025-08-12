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
import 'package:shopsy/features/product/presentation/pages/product_detail_page.dart';
import 'package:shopsy/features/product/presentation/pages/cart_page.dart';

import 'app_integration_test.mocks.dart';

@GenerateMocks([GetProducts])
void main() {
  group('Shopsy App Integration Tests', () {
    late MockGetProducts mockGetProducts;
    late ProductProvider productProvider;
    late CartProvider cartProvider;

    setUp(() {
      mockGetProducts = MockGetProducts();
      productProvider = ProductProvider(mockGetProducts);
      cartProvider = CartProvider();
    });

    Widget createTestApp() {
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

    testWidgets('should complete full shopping workflow', (WidgetTester tester) async {
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

      // Act - Start app and load products
      await tester.pumpWidget(createTestApp());
      await productProvider.fetchProducts();
      await tester.pumpAndSettle();

      // Assert - Products are displayed
      expect(find.text('Test Product 1'), findsOneWidget);
      expect(find.text('Test Product 2'), findsOneWidget);

      // Act - Add first product to cart
      await tester.tap(find.text('Add to Cart').first);
      await tester.pumpAndSettle();

      // Assert - Product added to cart
      expect(cartProvider.items.length, equals(1));
      expect(cartProvider.items.first.product.id, equals(1));
      expect(cartProvider.items.first.quantity, equals(1));

      // Act - Navigate to product detail page
      await tester.tap(find.byType(Card).first);
      await tester.pumpAndSettle();

      // Assert - Product detail page is displayed
      expect(find.byType(ProductDetailPage), findsOneWidget);
      expect(find.text('Test Product 1'), findsOneWidget);
      expect(find.text('Test Description 1'), findsOneWidget);
      expect(find.text('\$29.99'), findsOneWidget);

      // Act - Add product to cart from detail page
      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      // Assert - Quantity increased
      expect(cartProvider.items.first.quantity, equals(2));

      // Act - Navigate back to product list
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Assert - Back to product list
      expect(find.byType(ProductListPage), findsOneWidget);

      // Act - Add second product to cart
      await tester.tap(find.text('Add to Cart').last);
      await tester.pumpAndSettle();

      // Assert - Second product added
      expect(cartProvider.items.length, equals(2));
      expect(cartProvider.items.last.product.id, equals(2));

      // Act - Navigate to cart
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();

      // Assert - Cart page displayed with items
      expect(find.byType(CartPage), findsOneWidget);
      expect(find.text('Test Product 1'), findsOneWidget);
      expect(find.text('Test Product 2'), findsOneWidget);
      expect(find.text('2'), findsOneWidget); // Quantity for first product

      // Act - Increase quantity of first product
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pumpAndSettle();

      // Assert - Quantity increased
      expect(cartProvider.items.first.quantity, equals(3));
      expect(find.text('3'), findsOneWidget);

      // Act - Decrease quantity of second product
      await tester.tap(find.byIcon(Icons.remove).last);
      await tester.pumpAndSettle();

      // Assert - Second product removed (quantity was 1)
      expect(cartProvider.items.length, equals(1));
      expect(find.text('Test Product 2'), findsNothing);

      // Act - Clear cart
      await tester.tap(find.text('Clear Cart'));
      await tester.pumpAndSettle();

      // Assert - Cart is empty
      expect(cartProvider.items.isEmpty, isTrue);
      expect(find.text('Your cart is empty'), findsOneWidget);

      // Act - Navigate back to product list
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Assert - Back to product list
      expect(find.byType(ProductListPage), findsOneWidget);
    });

    testWidgets('should handle product browsing and navigation', (WidgetTester tester) async {
      // Arrange
      final testProducts = List.generate(
        5,
        (index) => Product(
          id: index + 1,
          title: 'Product ${index + 1}',
          description: 'Description ${index + 1}',
          price: (index + 1) * 10.0,
          image: 'https://example.com/image${index + 1}.jpg',
        ),
      );

      when(mockGetProducts()).thenAnswer((_) async => testProducts);

      // Act - Load products
      await tester.pumpWidget(createTestApp());
      await productProvider.fetchProducts();
      await tester.pumpAndSettle();

      // Assert - All products displayed
      for (int i = 1; i <= 5; i++) {
        expect(find.text('Product $i'), findsOneWidget);
        expect(find.text('\$${(i * 10.0).toStringAsFixed(2)}'), findsOneWidget);
      }

      // Act - Navigate to each product detail page
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byType(Card).at(i));
        await tester.pumpAndSettle();

        // Assert - Correct product detail displayed
        expect(find.text('Product ${i + 1}'), findsOneWidget);
        expect(find.text('Description ${i + 1}'), findsOneWidget);
        expect(find.text('\${((i + 1) * 10.0).toStringAsFixed(2)}'), findsOneWidget);

        // Navigate back
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
      }

      // Assert - Back to product list
      expect(find.byType(ProductListPage), findsOneWidget);
    });

    testWidgets('should handle cart operations with multiple products', (WidgetTester tester) async {
      // Arrange
      final testProducts = [
        Product(
          id: 1,
          title: 'Product 1',
          description: 'Description 1',
          price: 10.0,
          image: 'https://example.com/image1.jpg',
        ),
        Product(
          id: 2,
          title: 'Product 2',
          description: 'Description 2',
          price: 20.0,
          image: 'https://example.com/image2.jpg',
        ),
        Product(
          id: 3,
          title: 'Product 3',
          description: 'Description 3',
          price: 30.0,
          image: 'https://example.com/image3.jpg',
        ),
      ];

      when(mockGetProducts()).thenAnswer((_) async => testProducts);

      // Act - Load products and add to cart
      await tester.pumpWidget(createTestApp());
      await productProvider.fetchProducts();
      await tester.pumpAndSettle();

      // Add products to cart
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Add to Cart').at(i));
        await tester.pumpAndSettle();
      }

      // Assert - All products in cart
      expect(cartProvider.items.length, equals(3));
      expect(cartProvider.totalPrice, equals(60.0));

      // Act - Navigate to cart
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();

      // Assert - Cart displays all items
      expect(find.text('Product 1'), findsOneWidget);
      expect(find.text('Product 2'), findsOneWidget);
      expect(find.text('Product 3'), findsOneWidget);
      expect(find.text('Total: \$60.00'), findsOneWidget);

      // Act - Increase quantities
      await tester.tap(find.byIcon(Icons.add).first); // Product 1
      await tester.tap(find.byIcon(Icons.add).at(1)); // Product 2
      await tester.tap(find.byIcon(Icons.add).at(2)); // Product 3
      await tester.pumpAndSettle();

      // Assert - Quantities increased
      expect(cartProvider.items[0].quantity, equals(2));
      expect(cartProvider.items[1].quantity, equals(2));
      expect(cartProvider.items[2].quantity, equals(2));
      expect(find.text('2'), findsNWidgets(3));

      // Act - Remove one product
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();

      // Assert - Product removed
      expect(cartProvider.items.length, equals(2));
      expect(find.text('Product 1'), findsNothing);
      expect(find.text('Product 2'), findsOneWidget);
      expect(find.text('Product 3'), findsOneWidget);

      // Act - Clear cart
      await tester.tap(find.text('Clear Cart'));
      await tester.pumpAndSettle();

      // Assert - Cart empty
      expect(cartProvider.items.isEmpty, isTrue);
      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('should handle edge cases in shopping workflow', (WidgetTester tester) async {
      // Arrange
      final testProducts = [
        Product(
          id: 1,
          title: 'Free Product',
          description: 'Free Description',
          price: 0.0,
          image: 'https://example.com/free.jpg',
        ),
        Product(
          id: 2,
          title: 'Expensive Product',
          description: 'Very expensive',
          price: 999999.99,
          image: 'https://example.com/expensive.jpg',
        ),
      ];

      when(mockGetProducts()).thenAnswer((_) async => testProducts);

      // Act - Load products
      await tester.pumpWidget(createTestApp());
      await productProvider.fetchProducts();
      await tester.pumpAndSettle();

      // Assert - Products displayed
      expect(find.text('Free Product'), findsOneWidget);
      expect(find.text('Expensive Product'), findsOneWidget);
      expect(find.text('\$0.00'), findsOneWidget);
      expect(find.text('\$999,999.99'), findsOneWidget);

      // Act - Add free product to cart
      await tester.tap(find.text('Add to Cart').first);
      await tester.pumpAndSettle();

      // Act - Add expensive product to cart
      await tester.tap(find.text('Add to Cart').last);
      await tester.pumpAndSettle();

      // Act - Navigate to cart
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();

      // Assert - Cart displays items with correct total
      expect(find.text('Free Product'), findsOneWidget);
      expect(find.text('Expensive Product'), findsOneWidget);
      expect(find.text('Total: \$999,999.99'), findsOneWidget);

      // Act - Add more expensive products
      await tester.tap(find.byIcon(Icons.add).last);
      await tester.tap(find.byIcon(Icons.add).last);
      await tester.pumpAndSettle();

      // Assert - Total updated
      final expectedTotal = 999999.99 * 3;
      expect(find.text('Total: \${expectedTotal.toStringAsFixed(2)}'), findsOneWidget);
    });

    testWidgets('should handle empty product list', (WidgetTester tester) async {
      // Arrange
      when(mockGetProducts()).thenAnswer((_) async => <Product>[]);

      // Act - Load empty product list
      await tester.pumpWidget(createTestApp());
      await productProvider.fetchProducts();
      await tester.pumpAndSettle();

      // Assert - Empty state displayed
      expect(find.text('No products available'), findsOneWidget);

      // Act - Try to navigate to cart
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();

      // Assert - Cart page shows empty cart
      expect(find.byType(CartPage), findsOneWidget);
      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('should handle error loading products', (WidgetTester tester) async {
      // Arrange
      when(mockGetProducts()).thenThrow(Exception('Failed to load products'));

      // Act - Try to load products
      await tester.pumpWidget(createTestApp());
      await productProvider.fetchProducts();
      await tester.pumpAndSettle();

      // Assert - Error message displayed
      expect(find.text('Error loading products'), findsOneWidget);

      // Act - Try to navigate to cart
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();

      // Assert - Cart page shows empty cart
      expect(find.byType(CartPage), findsOneWidget);
      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('should handle rapid cart operations', (WidgetTester tester) async {
      // Arrange
      final testProducts = [
        Product(
          id: 1,
          title: 'Test Product',
          description: 'Test Description',
          price: 10.0,
          image: 'https://example.com/image.jpg',
        ),
      ];

      when(mockGetProducts()).thenAnswer((_) async => testProducts);

      // Act - Load products
      await tester.pumpWidget(createTestApp());
      await productProvider.fetchProducts();
      await tester.pumpAndSettle();

      // Act - Rapidly add products to cart
      for (int i = 0; i < 10; i++) {
        await tester.tap(find.text('Add to Cart'));
        await tester.pump();
      }
      await tester.pumpAndSettle();

      // Assert - Correct quantity
      expect(cartProvider.items.first.quantity, equals(10));

      // Act - Navigate to cart
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();

      // Act - Rapidly increase quantity
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();
      }
      await tester.pumpAndSettle();

      // Assert - Correct final quantity
      expect(cartProvider.items.first.quantity, equals(15));
      expect(find.text('15'), findsOneWidget);
      expect(find.text('Total: \$150.00'), findsOneWidget);
    });

    testWidgets('should handle navigation between pages', (WidgetTester tester) async {
      // Arrange
      final testProducts = [
        Product(
          id: 1,
          title: 'Test Product',
          description: 'Test Description',
          price: 10.0,
          image: 'https://example.com/image.jpg',
        ),
      ];

      when(mockGetProducts()).thenAnswer((_) async => testProducts);

      // Act - Load products
      await tester.pumpWidget(createTestApp());
      await productProvider.fetchProducts();
      await tester.pumpAndSettle();

      // Act - Navigate to product detail
      await tester.tap(find.byType(Card));
      await tester.pumpAndSettle();

      // Assert - Product detail page
      expect(find.byType(ProductDetailPage), findsOneWidget);

      // Act - Navigate to cart
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();

      // Assert - Cart page
      expect(find.byType(CartPage), findsOneWidget);

      // Act - Navigate back to product list
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Assert - Product list page
      expect(find.byType(ProductListPage), findsOneWidget);
    });
  });
}


