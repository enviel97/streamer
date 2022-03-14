import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/ultils/ultils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  statusBarTransparent();
  runApp(const App());
}
