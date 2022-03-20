import 'package:agora_rtc_engine/rtc_local_view.dart' as local;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as remote;
import 'package:agora_rtm/agora_rtm.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:streamer/src/constants.dart';
import 'package:streamer/src/models/user.model.dart';
import 'package:streamer/src/ultils/migrates/agora.dart';
import 'package:streamer/src/ultils/migrates/message.dart';
import 'package:streamer/src/ultils/migrates/spacing.dart';
import 'package:streamer/src/ultils/ultils.dart';
import 'package:streamer/src/ultils/widgets/custom_icon_button.dart';
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
          children: [
            _broadcastView(),
          ],
        ),
      ),
    );
  }

  Widget _broadcastView() {
    if (_users.isEmpty) {
      return const Center(child: Text('No users'));
    }
    final users = _users.where((u) => u.uid != widget.uid).toList();
    final primary = _users.singleWhere(
      (u) => u.uid != widget.uid,
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
            if (isLocalActive) _toolBar(),
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
                  isLocalActive ? widget.userName : user.name ?? 'Error name',
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

  Widget _toolBar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          KIconButton(
            color: muted ? kWhiteColor : Colors.blueAccent,
            backgroundColor: muted ? Colors.blueAccent : kWhiteColor,
            icon: muted ? Icons.mic_off : Icons.mic,
            onPressed: _onToggleMute,
          ),
          KIconButton(
            size: 35.0,
            color: kWhiteColor,
            backgroundColor: Colors.redAccent,
            icon: Icons.call_end,
            onPressed: () => _onCallEnd(context),
          ),
          KIconButton(
            color: videoDisabled ? kWhiteColor : Colors.blueAccent,
            backgroundColor: videoDisabled ? Colors.blueAccent : kWhiteColor,
            icon: videoDisabled ? Icons.videocam_off : Icons.videocam,
            onPressed: _onToggleVideoDisabled,
          ),
          KIconButton(
            color: Colors.blueAccent,
            backgroundColor: kWhiteColor,
            icon: Icons.switch_camera,
            onPressed: _onSwitchCamera,
          ),
        ],
      ),
    );
  }

  Future<void> initialAgora() async {
    try {
      await agora.initialAgora();
      agora.connection(onSuccess: (channel, uid, elapsed) {
        setState(() => _users.add(User(uid: uid)));
      }, onLeaving: (stats) {
        setState(_users.clear);
      });
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

  void _onCallEnd(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.maybePop(context);
    }
  }

  void _onSwitchCamera() {
    agora.engine.switchCamera();
  }

  void _onMessageReceive(AgoraRtmMessage message, AgoraRtmMember member) {
    //
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
          setState(() => _users = ReceiveMessage.activeUsers(_message[1]));
          return;
        }
    }
  }
}
