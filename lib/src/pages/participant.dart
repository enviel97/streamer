import 'package:agora_rtc_engine/rtc_local_view.dart' as local;
import 'package:flutter/material.dart';
import 'package:streamer/src/constants.dart';
import 'package:streamer/src/models/user.model.dart';
import 'package:streamer/src/ultils/migrates/agora.dart';

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
  final List<User> _users = [];
  bool muted = false, videoDisabled = false;

  @override
  void initState() {
    super.initState();
    initialAgora();
  }

  @override
  void dispose() {
    _users.clear();
    agora.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _broadcastView(),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.symmetric(vertical: 48.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RawMaterialButton(
                  onPressed: _onToggleMute,
                  child: Icon(
                    muted ? Icons.mic_off : Icons.mic,
                    color: muted ? kWhiteColor : Colors.blueAccent,
                    size: 20.0,
                  ),
                  shape: const CircleBorder(),
                  elevation: 2.0,
                  fillColor: muted ? Colors.blueAccent : kWhiteColor,
                  padding: const EdgeInsets.all(12.0),
                ),
                RawMaterialButton(
                  onPressed: () => _onCallEnd(context),
                  child: const Icon(
                    Icons.call_end,
                    color: kWhiteColor,
                    size: 35.0,
                  ),
                  shape: const CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.redAccent,
                  padding: const EdgeInsets.all(15.0),
                ),
                RawMaterialButton(
                  onPressed: _onToggleVideoDisabled,
                  child: Icon(
                    videoDisabled ? Icons.videocam_off : Icons.videocam,
                    color: videoDisabled ? kWhiteColor : Colors.blueAccent,
                    size: 20.0,
                  ),
                  shape: const CircleBorder(),
                  elevation: 2.0,
                  fillColor: videoDisabled ? Colors.blueAccent : kWhiteColor,
                  padding: const EdgeInsets.all(12.0),
                ),
                RawMaterialButton(
                  onPressed: _onSwitchCamera,
                  child: const Icon(
                    Icons.switch_camera,
                    color: Colors.blueAccent,
                    size: 20.0,
                  ),
                  shape: const CircleBorder(),
                  elevation: 2.0,
                  fillColor: kWhiteColor,
                  padding: const EdgeInsets.all(12.0),
                ),
              ],
            ),
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
      agora.onMemberChanged();
    } catch (error) {
      debugPrint('[Error occus]: $error');
    }
  }

  void _onToggleMute() {
    setState(() => muted = !muted);
    agora.engine.muteLocalAudioStream(muted);
  }

  void _onCallEnd(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.maybePop(context);
    }
  }

  void _onToggleVideoDisabled() {
    setState(() => videoDisabled = !videoDisabled);
    agora.engine.muteLocalVideoStream(videoDisabled);
  }

  void _onSwitchCamera() {
    agora.engine.switchCamera();
  }

  Widget _broadcastView() {
    if (_users.isEmpty) {
      return const Center(child: Text('No users'));
    }
    return local.SurfaceView();
  }
}
