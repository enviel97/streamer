// import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:streamer/src/constants.dart';

class Agora {
  late RtcEngine _engine;
  AgoraRtmClient? _client;
  AgoraRtmChannel? _channel;

  Agora();

  Future<void> initialAgora() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(appId));
    _client = await AgoraRtmClient.createInstance(appId);

    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  void dispose() {
    _engine.leaveChannel();
    _engine.destroy();
    _channel?.leave();
    _client?.destroy();
  }

  RtcEngine get engine => _engine;

  void connection({
    void Function(String channel, int uid, int elapsed)? onSuccess,
    void Function(RtcStats stats)? onLeaving,
  }) {
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: onSuccess,
        leaveChannel: onLeaving,
      ),
    );
  }

  // Callbacks for RTM Client
  void onConnectionStateChanged() {
    _client?.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      debugPrint('Private messenger from $peerId: ${message.text} \n $message');
    };

    _client?.onConnectionStateChanged = (int state, int reason) {
      debugPrint('Connection state changed: $state, Reason: $reason');

      switch (state) {
        case 1:
          {
            debugPrint(
                '[CONNECTION CHANGE REASON]: state: $state, reason: LOGIN');
            break;
          }
        case 2:
          {
            debugPrint('[CONNECTION CHANGE REASON]: state: $state,'
                ' reason: LOGIN SUCCESS');
            break;
          }
        case 3:
          {
            debugPrint(
                '[CONNECTION CHANGE REASON]: state: $state, reason: LOGIN FAILURE');
            break;
          }
        case 4:
          {
            debugPrint(
                '[CONNECTION CHANGE REASON]: state: $state, reason: LOGIN TIMEOUT');
            break;
          }

        //  INTERRUPTED
        case 5:
        case 6:
          {
            _channel?.leave();
            _client?.logout();
            _client?.destroy();
            debugPrint(
                '[CONNECTION CHANGE REASON]: state: $state, reason: INTERRUPTED');
            break;
          }
        case 7:
          {
            debugPrint(
                '[CONNECTION CHANGE REASON]: state: $state, reason: BANNED');
            break;
          }
        case 8:
          {
            debugPrint(
                '[CONNECTION CHANGE REASON]: state: $state, reason: LOGIN REMOTE');

            break;
          }
      }
    };
  }

  // Callbacks for RTM Channel
  void onMemberChanged() {
    // member join
    _channel?.onMemberJoined =
        (AgoraRtmMember member) => debugPrint('Member joind: ${member.userId}\n'
            'channel: ${member.channelId}');

    // member out
    _channel?.onMemberLeft =
        (AgoraRtmMember member) => debugPrint('Member left: ${member.userId}\n'
            'channel: ${member.channelId}');

    // member out
    _channel?.onMessageReceived =
        (AgoraRtmMessage message, AgoraRtmMember member) {
      debugPrint('Public Message from ${member.userId}: ${message.text}');
    };
  }

  Future<void> join(int uid, String channelName) async {
    await _client?.login(null, '$uid');
    _channel = await _client?.createChannel(channelName);
    await _channel?.join();
    await _engine.joinChannel(null, channelName, null, uid);
  }
}
