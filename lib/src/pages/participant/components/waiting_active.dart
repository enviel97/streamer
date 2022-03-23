import 'package:flutter/material.dart';
import 'package:streamer/src/constants.dart';
import 'package:streamer/src/ultils/migrates/spacing.dart';
import 'package:streamer/src/ultils/widgets/custom_icon_button.dart';

class WaitingActive extends StatelessWidget {
  const WaitingActive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              Spacing.vertical.lg,
              const Text('Waiting director allow you ...'),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(Spacing.xxxl),
            child: KIconButton(
              size: 35.0,
              color: kWhiteColor,
              backgroundColor: Colors.redAccent,
              icon: Icons.call_end,
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        )
      ],
    );
  }
}
