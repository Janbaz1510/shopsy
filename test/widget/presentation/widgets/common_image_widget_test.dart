import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopsy/features/product/presentation/widgets/common_image_widget.dart';

void main() {
  group('CommonImageWidget', () {
    testWidgets('should display image with default properties', (WidgetTester tester) async {
      // Arrange
      const imageUrl = 'https://example.com/image.jpg';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonImageWidget(imageURL: imageUrl),
          ),
        ),
      );

      // Assert
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('should display image with custom width and height', (WidgetTester tester) async {
      // Arrange
      const imageUrl = 'https://example.com/image.jpg';
      const width = 200.0;
      const height = 150.0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonImageWidget(
              imageURL: imageUrl,
              width: width,
              height: height,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Image), findsOneWidget);
      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.width, equals(width));
      expect(imageWidget.height, equals(height));
    });

    testWidgets('should display image with custom border radius', (WidgetTester tester) async {
      // Arrange
      const imageUrl = 'https://example.com/image.jpg';
      const borderRadius = 16.0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonImageWidget(
              imageURL: imageUrl,
              borderRadius: borderRadius,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(ClipRRect), findsOneWidget);
      final clipRRectWidget = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clipRRectWidget.borderRadius, equals(BorderRadius.circular(borderRadius)));
    });

    testWidgets('should display image with all custom properties', (WidgetTester tester) async {
      // Arrange
      const imageUrl = 'https://example.com/image.jpg';
      const width = 300.0;
      const height = 200.0;
      const borderRadius = 20.0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonImageWidget(
              imageURL: imageUrl,
              width: width,
              height: height,
              borderRadius: borderRadius,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(ClipRRect), findsOneWidget);
      
      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.width, equals(width));
      expect(imageWidget.height, equals(height));
      
      final clipRRectWidget = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clipRRectWidget.borderRadius, equals(BorderRadius.circular(borderRadius)));
    });

    testWidgets('should display image with zero border radius', (WidgetTester tester) async {
      // Arrange
      const imageUrl = 'https://example.com/image.jpg';
      const borderRadius = 0.0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonImageWidget(
              imageURL: imageUrl,
              borderRadius: borderRadius,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(ClipRRect), findsOneWidget);
      final clipRRectWidget = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clipRRectWidget.borderRadius, equals(BorderRadius.circular(borderRadius)));
    });

    testWidgets('should display image with very large border radius', (WidgetTester tester) async {
      // Arrange
      const imageUrl = 'https://example.com/image.jpg';
      const borderRadius = 100.0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonImageWidget(
              imageURL: imageUrl,
              borderRadius: borderRadius,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(ClipRRect), findsOneWidget);
      final clipRRectWidget = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clipRRectWidget.borderRadius, equals(BorderRadius.circular(borderRadius)));
    });

    testWidgets('should display image with very small dimensions', (WidgetTester tester) async {
      // Arrange
      const imageUrl = 'https://example.com/image.jpg';
      const width = 10.0;
      const height = 10.0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonImageWidget(
              imageURL: imageUrl,
              width: width,
              height: height,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Image), findsOneWidget);
      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.width, equals(width));
      expect(imageWidget.height, equals(height));
    });

    testWidgets('should display image with very large dimensions', (WidgetTester tester) async {
      // Arrange
      const imageUrl = 'https://example.com/image.jpg';
      const width = 1000.0;
      const height = 800.0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonImageWidget(
              imageURL: imageUrl,
              width: width,
              height: height,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Image), findsOneWidget);
      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.width, equals(width));
      expect(imageWidget.height, equals(height));
    });

    testWidgets('should display image with zero dimensions', (WidgetTester tester) async {
      // Arrange
      const imageUrl = 'https://example.com/image.jpg';
      const width = 0.0;
      const height = 0.0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonImageWidget(
              imageURL: imageUrl,
              width: width,
              height: height,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Image), findsOneWidget);
      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.width, equals(width));
      expect(imageWidget.height, equals(height));
    });

    testWidgets('should display image with negative dimensions', (WidgetTester tester) async {
      // Arrange
      const imageUrl = 'https://example.com/image.jpg';
      const width = -50.0;
      const height = -30.0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonImageWidget(
              imageURL: imageUrl,
              width: width,
              height: height,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Image), findsOneWidget);
      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.width, equals(width));
      expect(imageWidget.height, equals(height));
    });

    testWidgets('should display image with empty URL', (WidgetTester tester) async {
      // Arrange
      const imageUrl = '';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonImageWidget(imageURL: imageUrl),
          ),
        ),
      );

      // Assert
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should display image with URL containing special characters', (WidgetTester tester) async {
      // Arrange
      const imageUrl = 'https://example.com/image with spaces & symbols.jpg';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonImageWidget(imageURL: imageUrl),
          ),
        ),
      );

      // Assert
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should display image with URL containing unicode characters', (WidgetTester tester) async {
      // Arrange
      const imageUrl = 'https://example.com/中文-image-émojis-🛍️.jpg';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonImageWidget(imageURL: imageUrl),
          ),
        ),
      );

      // Assert
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should display image with very long URL', (WidgetTester tester) async {
      // Arrange
      final longUrl = 'https://example.com/' + 'a' * 1000 + '.jpg';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonImageWidget(imageURL: longUrl),
          ),
        ),
      );

      // Assert
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should handle null image URL gracefully', (WidgetTester tester) async {
      // Arrange
      const nullImageUrl = null;

      // Act & Assert
      expect(() => CommonImageWidget(imageURL: nullImageUrl), throwsA(isA<TypeError>()));
    });

    testWidgets('should display multiple images with different properties', (WidgetTester tester) async {
      // Arrange
      const imageUrl1 = 'https://example.com/image1.jpg';
      const imageUrl2 = 'https://example.com/image2.jpg';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CommonImageWidget(
                  imageURL: imageUrl1,
                  width: 100.0,
                  height: 100.0,
                  borderRadius: 8.0,
                ),
                CommonImageWidget(
                  imageURL: imageUrl2,
                  width: 200.0,
                  height: 150.0,
                  borderRadius: 16.0,
                ),
              ],
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Image), findsNWidgets(2));
      expect(find.byType(ClipRRect), findsNWidgets(2));
    });

    testWidgets('should display image with fit property', (WidgetTester tester) async {
      // Arrange
      const imageUrl = 'https://example.com/image.jpg';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonImageWidget(imageURL: imageUrl),
          ),
        ),
      );

      // Assert
      expect(find.byType(Image), findsOneWidget);
      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.fit, equals(BoxFit.cover));
    });

    testWidgets('should display image with network image source', (WidgetTester tester) async {
      // Arrange
      const imageUrl = 'https://example.com/image.jpg';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonImageWidget(imageURL: imageUrl),
          ),
        ),
      );

      // Assert
      expect(find.byType(Image), findsOneWidget);
      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.image, isA<NetworkImage>());
      expect((imageWidget.image as NetworkImage).url, equals(imageUrl));
    });
  });
}
