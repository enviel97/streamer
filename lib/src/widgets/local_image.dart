import 'package:flutter/material.dart';

class LocalImage extends StatelessWidget {
  final String image;
  final String ext;
  final double? width;
  final double? height;
  final BoxFit fit;

  const LocalImage(
    this.image, {
    this.ext = 'png',
    Key? key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/$image.$ext',
      fit: fit,
      width: width,
      height: height,
    );
  }
}
