import 'dart:ui';

import 'package:flutter/material.dart';

/// Utility function for generating consistent background colors based on image URLs
Color getBackgroundColor(String imageUrl) {
  // Predefined palette of pastel colors for consistent visual design
  final colors = [
    Colors.pink.shade100,   // Soft pink background
    Colors.blue.shade100,   // Soft blue background
    Colors.orange.shade100, // Soft orange background
    Colors.green.shade100,  // Soft green background
    Colors.purple.shade100, // Soft purple background
  ];
  
  // Use hash code of image URL to deterministically select a color
  return colors[imageUrl.hashCode % colors.length];
}
