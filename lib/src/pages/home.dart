import 'package:flutter/material.dart';
import 'package:streamer/src/constants.dart';
import 'package:streamer/src/pages/director.dart';
import 'package:streamer/src/pages/participant.dart';
import 'package:streamer/src/ultils/migrates/spacing.dart';
import 'package:streamer/src/widgets/custom_text_field.dart';
import 'package:streamer/src/widgets/custom_text_icon_button.dart';
import 'package:streamer/src/widgets/disable_keyboard.dart';
import 'package:streamer/src/widgets/local_image.dart';

import '../widgets/horizantal_separate.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String username = '';
  String channelName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DismissKeyboard(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LocalImage('streamer_logo'),
                Spacing.vertical.xs,
                const Text(
                  'Multi Streaming with Friends',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: Spacing.m),
                ),
                Spacing.vertical.xxxl,
                KTextField(
                  label: 'Username',
                  onChanged: (value) => username = value,
                ),
                Spacing.vertical.s,
                KTextField(
                  label: 'Channel name',
                  onChanged: (value) => channelName = value,
                ),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: HorizantalSeparate(),
                ),
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
