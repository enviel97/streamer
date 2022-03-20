import 'package:streamer/src/models/user.model.dart';
import '../../constants.dart';

class SendMessage {
  const SendMessage() : super();

  static String activeUsers(Set<User> users) {
    return '$active_users ' + users.map((user) => '${user.uid}').join(', ');
  }

  // action uid:value
  static String changedAudio({required String uid, required bool muted}) {
    if (muted) return 'audio $uid:muted';
    return '$audio $uid:unmuted';
  }

  static String changedVideo({required String uid, required bool disabled}) {
    if (disabled) return 'video $uid:disabled';
    return '$video $uid:enabled';
  }
}

class ReceiveMessage {
  const ReceiveMessage();

  static List<User> activeUsers(String uids) {
    final activeUsers = uids.split(',');
    final users = <User>[];
    for (String uid in activeUsers) {
      final _uid = int.tryParse(uid);
      if (_uid != null) users.add(User(uid: _uid));
    }
    return users;
  }

  static Map<int, bool?> changedAudio(String message) {
    final _message = message.split(':');
    final _uid = int.tryParse(_message[1]);
    if (_uid != null) {
      switch (_message[0]) {
        case 'muted':
          return {_uid: true};
        case 'unmuted':
          return {_uid: false};
      }
    }
    return {-1: null};
  }

  static Map<int, bool?> changedVideo(String message) {
    final _message = message.split(':');
    final _uid = int.tryParse(_message[1]);
    if (_uid != null) {
      switch (_message[0]) {
        case 'disabled':
          return {_uid: true};
        case 'enabled':
          return {_uid: false};
      }
    }
    return {-1: null};
  }
}
