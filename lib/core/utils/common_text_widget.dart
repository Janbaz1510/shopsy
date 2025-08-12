import 'package:flutter/material.dart';

class CommonTextWidget extends StatelessWidget {
  final String title;
  final FontWeight fontWeight;
  final double fontSize;
  final Color color;
  const CommonTextWidget({super.key, required this.title, this.fontWeight = FontWeight.w400, this.fontSize = 14, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color),
    );
  }
}
