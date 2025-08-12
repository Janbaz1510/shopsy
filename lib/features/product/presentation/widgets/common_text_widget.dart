import 'package:flutter/material.dart';

/// A reusable text widget for consistent text styling across the application
class CommonTextWidget extends StatelessWidget {
  /// The text content to display
  final String title;
  
  /// The font weight for the text
  final FontWeight fontWeight;
  
  /// The font size in logical pixels
  final double fontSize;
  
  /// Horizontal padding around the text
  final double padding;
  
  /// The color of the text
  final Color color;
  
  /// Maximum number of lines for the text
  final int maxLines;
  
  /// Text alignment within the widget bounds
  final TextAlign textAlign;

  /// Creates a new CommonTextWidget instance
  const CommonTextWidget({
    super.key,
    required this.title,
    this.fontWeight = FontWeight.w400,
    this.fontSize = 14,
    this.color = Colors.black,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.padding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Apply horizontal padding for spacing
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Text(
        title,
        // Limit text to specified number of lines with overflow handling
        maxLines: maxLines,
        // Apply text alignment
        textAlign: textAlign,
        // Apply text styling with font weight, size, and color
        style: TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: color,
        ),
      ),
    );
  }
}
