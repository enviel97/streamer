import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:streamer/src/models/user.model.dart';

class Director {
  final RtcEngine? engine;
  final AgoraRtmClient? client;
  final AgoraRtmChannel? channel;

  final Set<User> activeUsers;
  final Set<User> lobbyUsers;
  final User? localUser;

  const Director({
    this.engine,
    this.client,
    this.channel,
    this.localUser,
    this.activeUsers = const {},
    this.lobbyUsers = const {},
  });

  Director copyWith({
    RtcEngine? engine,
    AgoraRtmClient? client,
    AgoraRtmChannel? channel,
    Set<User>? activeUsers,
    Set<User>? lobbyUsers,
    User? localUser,
  }) {
    return Director(
      engine: engine ?? this.engine,
      client: client ?? this.client,
      channel: channel ?? this.channel,
      activeUsers: activeUsers ?? this.activeUsers,
      lobbyUsers: lobbyUsers ?? this.lobbyUsers,
      localUser: localUser ?? this.localUser,
    );
  }
}
