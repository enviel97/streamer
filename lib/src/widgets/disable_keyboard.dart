import 'package:flutter/material.dart';

// function
void dissmissKeyboard(BuildContext context) {
  final focus = FocusScope.of(context);
  if (!focus.hasPrimaryFocus && focus.focusedChild != null) {
    focus.focusedChild!.unfocus();
  }
}

class DismissKeyboard extends StatelessWidget {
  final Widget child;
  const DismissKeyboard({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => dissmissKeyboard(context),
      child: child,
    );
  }
}
