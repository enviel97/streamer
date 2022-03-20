import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamer/src/constants.dart';
import 'package:streamer/src/models/director.model.dart';
import 'package:streamer/src/models/user.model.dart';
import 'package:streamer/src/ultils/migrates/message.dart';
import 'package:streamer/src/ultils/ultils.dart';

final directorController =
    StateNotifierProvider.autoDispose<DirectorController, Director>(
  (ref) => DirectorController(ref.read),
);

class DirectorController extends StateNotifier<Director> {
  final Reader read;

  DirectorController(this.read) : super(const Director());

  Future<void> joinCall({
    required String channelName,
    required int uid,
  }) async {
    await _initialize();
    await _startedEngine();
    _configEngine();
    _configClient();
    await _loginChannel(uid: uid, channelName: channelName);
    _configMember();
  }

  Future<void> leaveCall() async {
    state.engine?.leaveChannel();
    state.engine?.destroy();
    state.channel?.leave();
    state.client?.logout();
    state.client?.destroy();
  }

  Future<void> promoteToActiveUser({required int uid}) async {
    final _lobby = state.lobbyUsers;
    if (_lobby.isEmpty) return;

    Color? _color;
    String? _name;

    final _users = _lobby.where((user) => user.uid == uid);
    if (_users.isNotEmpty) {
      final user = _users.first;
      _color = user.backgroundColor;
      _name = user.name;
      _lobby.remove(user);
    }

    state = state.copyWith(activeUsers: {
      ...state.activeUsers,
      User(uid: uid, backgroundColor: _color, name: _name),
    }, lobbyUsers: _lobby);

    _sendMessageToChannel(SendMessage.changedAudio(uid: '$uid', muted: false));
    _sendMessageToChannel(
        SendMessage.changedVideo(uid: '$uid', disabled: false));
    _sendMessageToChannel(SendMessage.activeUsers(state.activeUsers));
  }

  Future<void> demoteToActiveUser({required int uid}) async {
    final _active = state.activeUsers;
    if (_active.isEmpty) return;

    Color? _color;
    String? _name;

    final _users = _active.where((user) => user.uid == uid);
    if (_users.isNotEmpty) {
      final user = _users.first;
      _color = user.backgroundColor;
      _name = user.name;
      _active.remove(user);
    }

    state = state.copyWith(lobbyUsers: {
      ...state.lobbyUsers,
      User(
        uid: uid,
        backgroundColor: _color,
        name: _name,
        muted: true,
        videoDisabled: true,
      ),
    }, activeUsers: _active);

    _sendMessageToChannel(SendMessage.changedAudio(uid: '$uid', muted: true));
    _sendMessageToChannel(
        SendMessage.changedVideo(uid: '$uid', disabled: true));
    _sendMessageToChannel(SendMessage.activeUsers(state.activeUsers));
  }

  Future<void> toggleUserAudio({required int index}) async {
    final user = state.activeUsers.elementAt(index);

    if (user.muted) {
      state.channel!
          .sendMessage(AgoraRtmMessage.fromText('unmuted ${user.uid}'));
    } else {
      state.channel!.sendMessage(AgoraRtmMessage.fromText('muted ${user.uid}'));
    }
  }

  Future<void> toggleUserVideo({required int index}) async {
    final user = state.activeUsers.elementAt(index);
    if (user.videoDisabled) {
      state.channel!
          .sendMessage(AgoraRtmMessage.fromText('videoEnabled ${user.uid}'));
    } else {
      state.channel!
          .sendMessage(AgoraRtmMessage.fromText('videoDisabled ${user.uid}'));
    }
  }

  // private

  Future<void> _initialize() async {
    final engine = await RtcEngine.createWithContext(RtcEngineContext(appId));
    final client = await AgoraRtmClient.createInstance(appId);
    state = Director(engine: engine, client: client);
  }

  Future<void> _loginChannel({
    required String channelName,
    required int uid,
  }) async {
    await state.client?.login(null, '$uid');
    state =
        state.copyWith(channel: await state.client?.createChannel(channelName));
    await state.channel?.join();
    await state.engine?.joinChannel(null, channelName, null, uid);
  }

  Future<void> _startedEngine() async {
    await state.engine?.enableVideo();
    await state.engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await state.engine?.setClientRole(ClientRole.Broadcaster);
  }

  void _configEngine() {
    state.engine?.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (_, uid, __) {
          print('Director: $uid');
        },
        leaveChannel: (stats) {
          print('Channel leaving');
        },
        userJoined: (uid, elapsed) {
          print('USER JOINED: $uid');
          _addUserToLobby(uid: uid);
        },
        userOffline: (uid, reason) {
          _removeUser(uid: uid);
        },
        remoteAudioStateChanged: (uid, state, _, __) {
          switch (state) {
            case AudioRemoteState.Stopped:
              _updateUserAudio(uid: uid, muted: true);
              return;
            case AudioRemoteState.Decoding:
              _updateUserAudio(uid: uid, muted: false);
              return;
            case AudioRemoteState.Starting:
              // TODO: Handle this case.
              return;
            case AudioRemoteState.Frozen:
              // TODO: Handle this case.
              return;
            case AudioRemoteState.Failed:
              // TODO: Handle this case.
              return;
          }
        },
        remoteVideoStateChanged: (uid, state, _, __) {
          switch (state) {
            case VideoRemoteState.Stopped:
              _updateUserVideo(uid: uid, videoDisabled: true);
              return;
            case VideoRemoteState.Decoding:
              _updateUserVideo(uid: uid, videoDisabled: false);
              return;
            case VideoRemoteState.Starting:
              // TODO: Handle this case.
              return;

            case VideoRemoteState.Frozen:
              // TODO: Handle this case.
              return;
            case VideoRemoteState.Failed:
              // TODO: Handle this case.
              return;
          }
        },
      ),
    );
  }

  void _configClient() {
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
  }

  void _configMember() {
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

  Future<void> _addUserToLobby({required int uid}) async {
    state = state.copyWith(lobbyUsers: {
      ...state.lobbyUsers,
      User(
        uid: uid,
        muted: true,
        videoDisabled: true,
        name: '@user$uid',
        backgroundColor: randomeColor(),
      ),
    });
    _sendMessageToChannel(SendMessage.activeUsers(state.activeUsers));
  }

  Future<void> _removeUser({required int uid}) async {
    final _active = state.activeUsers;
    final _lobby = state.lobbyUsers;
    _active.removeWhere((user) => user.uid == uid);
    _lobby.removeWhere((user) => user.uid == uid);

    state = state.copyWith(
      activeUsers: _active,
      lobbyUsers: _lobby,
    );

    _sendMessageToChannel(SendMessage.activeUsers(state.activeUsers));
  }

  Future<void> _updateUserAudio({required int uid, required bool muted}) async {
    try {
      final _user = state.activeUsers.singleWhere((user) => user.uid == uid);
      final _users = state.activeUsers;
      _users.remove(_user);
      _users.add(_user.copyWith(muted: muted));
      state = state.copyWith(activeUsers: _users);
    } catch (error) {
      debugPrint('[Update audio]: $error');
    }
  }

  Future<void> _updateUserVideo({
    required int uid,
    required bool videoDisabled,
  }) async {
    try {
      final _user = state.activeUsers.singleWhere((user) => user.uid == uid);
      final _users = state.activeUsers;
      _users.remove(_user);
      _users.add(_user.copyWith(videoDisabled: videoDisabled));
      state = state.copyWith(activeUsers: _users);
    } catch (error) {
      debugPrint('[Update video]: $error');
    }
  }

  Future<void> _sendMessageToChannel(String message) async {
    state.channel?.sendMessage(AgoraRtmMessage.fromText(message));
  }
}
