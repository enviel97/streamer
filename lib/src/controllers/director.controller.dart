import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamer/src/constants.dart';
import 'package:streamer/src/models/director.model.dart';

final directorController =
    StateNotifierProvider.autoDispose<DirectorController, Director>(
  (ref) {
    return DirectorController(ref.read);
  },
);

class DirectorController extends StateNotifier<Director> {
  final Reader read;

  DirectorController(this.read) : super(const Director());

  Future<void> joinCall({
    required String channelName,
    required int uid,
  }) async {
    await _initialize();

    await state.engine?.enableVideo();
    await state.engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await state.engine?.setClientRole(ClientRole.Broadcaster);

    state.engine?.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (_, uid, __) {
          debugPrint('Director: $uid');
        },
        leaveChannel: (stats) {},
      ),
    );

    state.client?.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      debugPrint('Private messenger from $peerId: ${message.text} \n $message');
    };

    state.client?.onConnectionStateChanged = (int state, int reason) {
      debugPrint('Connection state changed: $state, Reason: $reason');

      //  INTERRUPTED
      if (state == 5) {
        this.state.channel?.leave();
        this.state.client?.logout();
        this.state.client?.destroy();
        debugPrint(
            '[CONNECTION CHANGE REASON]: state: $state, reason: INTERRUPTED');
      }
    };
    await state.client?.login(null, '$uid');
    state =
        state.copyWith(channel: await state.client?.createChannel(channelName));
    await state.channel?.join();
    await state.engine?.joinChannel(null, channelName, null, uid);

    // member join
    state.channel?.onMemberJoined =
        (AgoraRtmMember member) => debugPrint('Member joind: ${member.userId}\n'
            'channel: ${member.channelId}');

    // member out
    state.channel?.onMemberLeft =
        (AgoraRtmMember member) => debugPrint('Member left: ${member.userId}\n'
            'channel: ${member.channelId}');

    // member out
    state.channel?.onMessageReceived =
        (AgoraRtmMessage message, AgoraRtmMember member) {
      debugPrint('Public Message from ${member.userId}: ${message.text}');
    };
  }

  Future<void> leaveCall() async {
    state.engine?.leaveChannel();
    state.engine?.destroy();
    state.channel?.leave();
    state.client?.logout();
    state.client?.destroy();
  }

  Future<void> _initialize() async {
    final engine = await RtcEngine.createWithContext(RtcEngineContext(appId));
    final client = await AgoraRtmClient.createInstance(appId);
    state = Director(engine: engine, client: client);
  }
}
