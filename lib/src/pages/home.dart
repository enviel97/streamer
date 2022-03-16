import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:streamer/src/constants.dart';
import 'package:streamer/src/pages/director.dart';
import 'package:streamer/src/pages/participant.dart';
import 'package:streamer/src/ultils/migrates/local_storage.dart';
import 'package:streamer/src/ultils/migrates/permission.dart';
import 'package:streamer/src/ultils/migrates/spacing.dart';
import 'package:streamer/src/ultils/ultils.dart';
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
  int uid = -99999;
  @override
  void initState() {
    super.initState();
    getUserUid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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

  Future<void> _goToPaticipant() async {
    if (channelName.isEmpty || // channel name
            username.isEmpty || // username required
            uid == -99999 || // uid required (away none null)
            await deniedPermissions() // check permissions
        ) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Participant(
          channelName: channelName,
          userName: username,
          uid: uid,
        ),
      ),
    );
  }

  Future<void> _goToDirector() async {
    if (await deniedPermissions()) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const Director()),
    );
  }

  void getUserUid() {
    final local = LocalStorage();
    final uid = local.read<int>(localUid);
    if (uid != null) {
      this.uid = uid;
    } else {
      this.uid = createUid();
      local.write(localUid, this.uid);
    }
    debugPrint('uid: ${this.uid}');
  }
}
