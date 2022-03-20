import 'package:flutter/material.dart';

class KIconButton extends StatelessWidget {
  final double size;
  final Color color;
  final Color backgroundColor;
  final IconData icon;
  final void Function()? onPressed;

  const KIconButton({
    required this.icon,
    required this.onPressed,
    required this.color,
    required this.backgroundColor,
    Key? key,
    this.size = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      child: Icon(icon, color: color, size: size),
      shape: const CircleBorder(),
      elevation: 2.0,
      fillColor: backgroundColor,
      padding: EdgeInsets.all(0.6 * size),
    );
  }
}
