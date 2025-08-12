import 'package:flutter/material.dart';

class CommonImageWidget extends StatelessWidget {
  final String imageURL;
  const CommonImageWidget({super.key, required this.imageURL});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(width: 80, height: 80, child: Image.network(imageURL, fit: BoxFit.cover)),
    );
  }
}
