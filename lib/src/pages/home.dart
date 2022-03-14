import 'package:flutter/material.dart';
import 'package:streamer/src/pages/director.dart';
import 'package:streamer/src/pages/participant.dart';
import 'package:streamer/src/ultils/migrates/spacing.dart';
import 'package:streamer/src/widgets/custom_text_icon_button.dart';
import 'package:streamer/src/widgets/local_image.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LocalImage('streamer_logo'),
            const Text('What is your role?'),
            Spacing.vertical.m,
            KTextIconButton(
              text: 'PARTICIPANT',
              isOutline: true,
              icon: Icons.live_tv_rounded,
              onPressed: _goToPaticipant,
            ),
            Spacing.vertical.m,
            KTextIconButton(
              text: 'DIRECTOR',
              onPressed: _goToDirector,
              icon: Icons.cut_rounded,
            ),
          ],
        ),
      ),
    );
  }

  void _goToPaticipant() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const Participant()),
    );
  }

  void _goToDirector() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const Director()),
    );
  }
}
