import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as local;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as remote;
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:streamer/src/constants.dart';
import 'package:streamer/src/models/user.model.dart';
import 'package:streamer/src/pages/participant/components/toolbar.dart';
import 'package:streamer/src/pages/participant/components/waiting_active.dart';
import 'package:streamer/src/ultils/extentions/hex_color.dart';
import 'package:streamer/src/ultils/migrates/agora.dart';
import 'package:streamer/src/ultils/migrates/message.dart';
import 'package:streamer/src/ultils/migrates/spacing.dart';
import 'package:streamer/src/ultils/ultils.dart';
import 'package:streamer/src/ultils/widgets/extended_grid.dart';

class Participant extends StatefulWidget {
  final String channelName;
  final String userName;
  final int uid;

  const Participant({
    required this.channelName,
    required this.userName,
    required this.uid,
    Key? key,
  }) : super(key: key);

  @override
  State<Participant> createState() => _ParticipantState();
}

class _ParticipantState extends State<Participant> {
  final agora = Agora();
  List<User> _users = [];
  bool muted = false, videoDisabled = false;
  final backgroundColor = randomeColor();

  @override
  void initState() {
    super.initState();
    initialAgora();
  }

  @override
  void dispose() {
    agora.dispose();
    _users.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [_broadcastView()],
        ),
      ),
    );
  }

  Widget _broadcastView() {
    if (_users.isEmpty) {
      return const WaitingActive();
    }
    final users = _users.where((u) => u.uid != widget.uid).toList();
    final primary = _users.singleWhere(
      (u) => u.uid == widget.uid,
      orElse: () => User(
        uid: widget.uid,
        name: widget.channelName,
        backgroundColor: randomeColor(),
        muted: muted,
        videoDisabled: videoDisabled,
      ),
    );
    return ExtendedGridView<User>(
        data: users,
        primary: primary,
        itemBuilder: (user) {
          final isLocalActive = widget.uid == user.uid;
          return Stack(children: [
            isLocalActive
                ? local.SurfaceView()
                : remote.SurfaceView(uid: user.uid),
            if (isLocalActive)
              Toolbar(
                muted: muted,
                videoDisabled: videoDisabled,
                onSwitchCamera: _onSwitchCamera,
                onToggleMute: _onToggleMute,
                onToggleVideoDisabled: _onToggleVideoDisabled,
              ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  color: kBlackColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                  ),
                ),
                child: Text(
                  isLocalActive
                      ? widget.userName
                      : user.name ?? '@user${user.uid}',
                  style: const TextStyle(
                    color: kWhiteColor,
                    fontSize: Spacing.m,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ]);
        });
  }

  Future<void> initialAgora() async {
    try {
      await agora.initialAgora();
      agora.connection(onSuccess: _onJoin, onLeaving: _onLeaving);
      agora.onConnectionStateChanged();
      await agora.join(widget.uid, widget.channelName);
      agora.onMemberChanged(onMessageReceive: _onMessageReceive);
    } catch (error) {
      debugPrint('[Error occus]: $error');
    }
  }

  void _onToggleMute() {
    setState(() => muted = !muted);
    agora.engine.muteLocalAudioStream(muted);
  }

  void _onToggleVideoDisabled() {
    setState(() => videoDisabled = !videoDisabled);
    agora.engine.muteLocalVideoStream(videoDisabled);
  }

  void _onSwitchCamera() {
    agora.engine.switchCamera();
  }

  void _onMessageReceive(AgoraRtmMessage message, AgoraRtmMember member) {
    final _message = message.text.split(' ');
    switch (_message[0]) {
      case audio:
        {
          final message = ReceiveMessage.changedAudio(_message[1]);
          if (message[widget.uid] != null) {
            final _muted = message[widget.uid] ?? muted;
            setState(() => muted = _muted);
            agora.engine.muteLocalAudioStream(_muted);
          }
          return;
        }
      case video:
        {
          final message = ReceiveMessage.changedVideo(_message[1]);
          if (message[widget.uid] != null) {
            final _videoDisabled = message[widget.uid] ?? videoDisabled;
            setState(() => videoDisabled = _videoDisabled);
            agora.engine.muteLocalVideoStream(muted);
          }
          return;
        }
      case active_users:
        {
          setState(() {
            _users = ReceiveMessage.activeUsers(_message[1]);
          });
          return;
        }
    }
  }

  void _onJoin(String channel, int uid, int elapsed) {
    setState(() {
      final name = {'key': 'name', 'value': widget.userName};
      final color = {'key': 'color', 'value': backgroundColor.toHex};
      agora.setClientAtributte([color, name]);
    });
  }

  void _onLeaving(RtcStats stats) {
    _users.clear();
    if (mounted) {
      setState(() {});
    }
  }
}
