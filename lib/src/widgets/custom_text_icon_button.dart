import 'package:flutter/material.dart';

import '../constants.dart';

class KTextIconButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final bool isOutline;
  final Color primaryColor;
  final IconData icon;
  final Color? textColor;
  final Color? onClickColor;
  final double fontSize;
  final bool reverse;
  final EdgeInsets padding;

  const KTextIconButton({
    required this.text,
    this.isOutline = false,
    this.onPressed,
    this.onClickColor,
    this.textColor,
    this.primaryColor = kBlackColor,
    this.fontSize = 20.0,
    this.padding = const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
    this.icon = Icons.more_horiz_rounded,
    this.reverse = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isOutline ? kWhiteColor : primaryColor;
    final onClickColor =
        this.onClickColor ?? (isOutline ? primaryColor : kWhiteColor);
    final textColor =
        this.textColor ?? (isOutline ? primaryColor : kWhiteColor);

    return TextButton.icon(
      style: TextButton.styleFrom(
        primary: onClickColor,
        backgroundColor: backgroundColor,
        padding: padding,
        side: BorderSide(color: primaryColor, width: 1.0),
      ),
      label: Icon(icon),
      icon: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 20.0,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
