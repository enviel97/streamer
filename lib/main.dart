import 'package:flutter/material.dart';
import 'package:streamer/src/ultils/migrates/local_storage.dart';

import 'src/app.dart';
import 'src/ultils/ultils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  statusBarTransparent();
  await LocalStorage().initial();
  runApp(const App());
}
