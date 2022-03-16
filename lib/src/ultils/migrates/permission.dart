import 'package:permission_handler/permission_handler.dart';

Future<bool> deniedPermissions() async {
  final statuses = await [Permission.camera, Permission.microphone].request();

  return statuses.values.any((status) => status.isDenied);
}
