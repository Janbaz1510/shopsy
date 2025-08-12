import 'package:flutter/material.dart';

/// A reusable image widget for consistent image display across the application
class CommonImageWidget extends StatelessWidget {
  /// The URL of the image to display
  final String imageURL;
  final double? height;
  final double? width;
  final double? borderRadius;

  /// Creates a new CommonImageWidget instance
  const CommonImageWidget({
    super.key,
    required this.imageURL, this.height, this.width, this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // Apply rounded corners for modern, polished appearance
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        // Fixed size container for consistent layout
        width: 80,
        height: 80,
        child: Image.network(
          imageURL,
          // Scale image to cover the entire container while maintaining aspect ratio
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
