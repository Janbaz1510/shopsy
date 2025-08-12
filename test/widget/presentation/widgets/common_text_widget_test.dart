import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopsy/features/product/presentation/widgets/common_text_widget.dart';

void main() {
  group('CommonTextWidget', () {
    testWidgets('should display text with default properties', (WidgetTester tester) async {
      // Arrange
      const testText = 'Test Text';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonTextWidget(title: testText),
          ),
        ),
      );

      // Assert
      expect(find.text(testText), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('should display text with custom font weight', (WidgetTester tester) async {
      // Arrange
      const testText = 'Bold Text';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonTextWidget(
              title: testText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testText), findsOneWidget);
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.fontWeight, equals(FontWeight.bold));
    });

    testWidgets('should display text with custom font size', (WidgetTester tester) async {
      // Arrange
      const testText = 'Large Text';
      const fontSize = 24.0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonTextWidget(
              title: testText,
              fontSize: fontSize,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testText), findsOneWidget);
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.fontSize, equals(fontSize));
    });

    testWidgets('should display text with custom color', (WidgetTester tester) async {
      // Arrange
      const testText = 'Colored Text';
      const textColor = Colors.red;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonTextWidget(
              title: testText,
              color: textColor,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testText), findsOneWidget);
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.color, equals(textColor));
    });

    testWidgets('should display text with custom padding', (WidgetTester tester) async {
      // Arrange
      const testText = 'Padded Text';
      const padding = 16.0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonTextWidget(
              title: testText,
              padding: padding,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testText), findsOneWidget);
      expect(find.byType(Padding), findsOneWidget);
      final paddingWidget = tester.widget<Padding>(find.byType(Padding));
      expect(paddingWidget.padding, equals(padding));
    });

    testWidgets('should display text with max lines constraint', (WidgetTester tester) async {
      // Arrange
      const testText = 'Text with max lines';
      const maxLines = 2;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonTextWidget(
              title: testText,
              maxLines: maxLines,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testText), findsOneWidget);
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.maxLines, equals(maxLines));
    });

    testWidgets('should display text with custom text alignment', (WidgetTester tester) async {
      // Arrange
      const testText = 'Centered Text';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonTextWidget(
              title: testText,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testText), findsOneWidget);
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.textAlign, equals(TextAlign.center));
    });

    testWidgets('should display empty text', (WidgetTester tester) async {
      // Arrange
      const testText = '';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonTextWidget(title: testText),
          ),
        ),
      );

      // Assert
      expect(find.text(testText), findsOneWidget);
    });

    testWidgets('should display text with all custom properties', (WidgetTester tester) async {
      // Arrange
      const testText = 'Custom Text';
      const fontWeight = FontWeight.w600;
      const fontSize = 18.0;
      const color = Colors.blue;
      const padding = 8.0;
      const maxLines = 3;
      const textAlign = TextAlign.right;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonTextWidget(
              title: testText,
              fontWeight: fontWeight,
              fontSize: fontSize,
              color: color,
              padding: padding,
              maxLines: maxLines,
              textAlign: textAlign,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testText), findsOneWidget);
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.fontWeight, equals(fontWeight));
      expect(textWidget.style?.fontSize, equals(fontSize));
      expect(textWidget.style?.color, equals(color));
      expect(textWidget.maxLines, equals(maxLines));
      expect(textWidget.textAlign, equals(textAlign));
    });

    testWidgets('should display long text with overflow', (WidgetTester tester) async {
      // Arrange
      const longText = 'This is a very long text that should be truncated when it exceeds the maximum number of lines allowed by the widget configuration';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonTextWidget(
              title: longText,
              maxLines: 1,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(longText), findsOneWidget);
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.maxLines, equals(1));
    });

    testWidgets('should display text with special characters', (WidgetTester tester) async {
      // Arrange
      final specialText = 'Text with émojis 🛍️ and symbols @#%';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonTextWidget(title: specialText),
          ),
        ),
      );

      // Assert
      expect(find.text(specialText), findsOneWidget);
    });

    testWidgets('should display text with unicode characters', (WidgetTester tester) async {
      // Arrange
      const unicodeText = 'Text with unicode: 中文 Español Français';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonTextWidget(title: unicodeText),
          ),
        ),
      );

      // Assert
      expect(find.text(unicodeText), findsOneWidget);
    });

    testWidgets('should handle null text gracefully', (WidgetTester tester) async {
      // Arrange
      const nullText = null;

      // Act & Assert
      expect(() => CommonTextWidget(title: nullText), throwsA(isA<TypeError>()));
    });
  });
}
