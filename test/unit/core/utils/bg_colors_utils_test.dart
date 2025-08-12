import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopsy/core/utils/bg_colors_utils.dart';

void main() {
  group('Background Colors Utils', () {
    test('should return a color for valid image URL', () {
      // Arrange
      const imageUrl = 'https://example.com/image.jpg';

      // Act
      final color = getBackgroundColor(imageUrl);

      // Assert
      expect(color, isA<Color>());
    });

    test('should return same color for same URL', () {
      // Arrange
      const imageUrl = 'https://example.com/same-image.jpg';

      // Act
      final color1 = getBackgroundColor(imageUrl);
      final color2 = getBackgroundColor(imageUrl);

      // Assert
      expect(color1, equals(color2));
    });

    test('should return different colors for different URLs', () {
      // Arrange
      const url1 = 'https://example.com/image1.jpg';
      const url2 = 'https://example.com/image2.jpg';

      // Act
      final color1 = getBackgroundColor(url1);
      final color2 = getBackgroundColor(url2);

      // Assert
      expect(color1, isNot(equals(color2)));
    });

    test('should handle empty URL', () {
      // Arrange
      const emptyUrl = '';

      // Act
      final color = getBackgroundColor(emptyUrl);

      // Assert
      expect(color, isA<Color>());
    });

    test('should handle URLs with special characters', () {
      // Arrange
      const specialUrl = 'https://example.com/image with spaces & symbols.jpg';

      // Act
      final color = getBackgroundColor(specialUrl);

      // Assert
      expect(color, isA<Color>());
    });

    test('should handle very long URLs', () {
      // Arrange
      final longUrl = 'https://example.com/' + 'a' * 1000 + '.jpg';

      // Act
      final color = getBackgroundColor(longUrl);

      // Assert
      expect(color, isA<Color>());
    });

    test('should handle URLs with unicode characters', () {
      // Arrange
      const unicodeUrl = 'https://example.com/中文-image-émojis-🛍️.jpg';

      // Act
      final color = getBackgroundColor(unicodeUrl);

      // Assert
      expect(color, isA<Color>());
    });

    test('should cycle through colors for different URLs', () {
      // Arrange
      final urls = List.generate(20, (index) => 'https://example.com/image$index.jpg');

      // Act
      final colors = urls.map((url) => getBackgroundColor(url)).toList();

      // Assert
      expect(colors.length, equals(20));
      expect(colors.every((color) => color is Color), isTrue);
    });

    test('should handle null URL gracefully', () {
      // Arrange
      const nullUrl = null;

      // Act & Assert
      expect(() => getBackgroundColor(nullUrl), throwsA(isA<TypeError>()));
    });
  });
}
