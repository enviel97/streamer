import 'package:flutter/material.dart';
import 'package:streamer/src/constants.dart';

class ToogleIconButton extends StatelessWidget {
  final bool isEnable;
  final IconData icon;
  final void Function()? onPressed;
  final Color color;

  const ToogleIconButton({
    required this.icon,
    required this.onPressed,
    this.color = kRedColor,
    this.isEnable = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: CircleAvatar(
        backgroundColor: kWhiteColor,
        child: Icon(
          icon,
          color: isEnable ? color : color.withOpacity(.5),
        ),
      ),
    );
  }
}
