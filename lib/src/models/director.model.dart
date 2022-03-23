import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';

import 'package:streamer/src/models/stream.model.dart';
import 'package:streamer/src/models/user.model.dart';

class Director {
  final RtcEngine? engine;
  final AgoraRtmClient? client;
  final AgoraRtmChannel? channel;
  final Set<User> activeUsers;
  final Set<User> lobbyUsers;
  final User? localUser;
  final bool isLive;
  final List<StreamDestination> destination;

  const Director({
    this.engine,
    this.client,
    this.channel,
    this.localUser,
    this.activeUsers = const {},
    this.lobbyUsers = const {},
    this.isLive = false,
    this.destination = const [],
  });

  Director copyWith({
    RtcEngine? engine,
    AgoraRtmClient? client,
    AgoraRtmChannel? channel,
    Set<User>? activeUsers,
    Set<User>? lobbyUsers,
    User? localUser,
    bool? isLive,
    List<StreamDestination>? destination,
  }) {
    return Director(
      engine: engine ?? this.engine,
      client: client ?? this.client,
      channel: channel ?? this.channel,
      activeUsers: activeUsers ?? this.activeUsers,
      lobbyUsers: lobbyUsers ?? this.lobbyUsers,
      localUser: localUser ?? this.localUser,
      isLive: isLive ?? this.isLive,
      destination: destination ?? this.destination,
    );
  }
}
