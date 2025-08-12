import 'dart:ui';

import 'package:flutter/material.dart';

Color getBackgroundColor(String imageUrl) {
  final colors = [Colors.pink.shade100, Colors.blue.shade100, Colors.orange.shade100, Colors.green.shade100, Colors.purple.shade100];
  return colors[imageUrl.hashCode % colors.length];
}
