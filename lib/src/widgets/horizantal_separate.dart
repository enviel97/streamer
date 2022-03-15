import 'package:flutter/material.dart';
import 'package:streamer/src/constants.dart';

class HorizantalSeparate extends StatelessWidget {
  final Widget? content;
  const HorizantalSeparate({Key? key, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(child: Divider(color: kBlackColor)),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: content ??
                Text('~',
                    style: TextStyle(color: kBlackColor.withOpacity(0.8)))),
        const Expanded(child: Divider(color: kBlackColor)),
      ],
    );
  }
}
