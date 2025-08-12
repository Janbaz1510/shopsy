import 'package:flutter/material.dart';

class CommonTextWidget extends StatelessWidget {
  final String title;
  final FontWeight fontWeight;
  final double fontSize;
  final double padding;
  final Color color;
  final int maxLine;
  final TextAlign textAlign;
  const CommonTextWidget({super.key, required this.title, this.fontWeight = FontWeight.w400, this.fontSize = 14, this.color = Colors.black, this.maxLine = 1, this.textAlign = TextAlign.start, this.padding = 0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Text(
        title,
        maxLines: maxLine,
        textAlign: textAlign,
        style: TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color),
      ),
    );
  }
}
