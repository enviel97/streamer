import 'package:flutter/services.dart';
import 'package:streamer/src/constants.dart';

void statusBarTransparent() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: kNoneColor,
    statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
    statusBarBrightness: Brightness.light, // For iOS (dark icons)
  ));
}

int createUid() {
  final time = DateTime.now().millisecondsSinceEpoch;
  return int.parse('$time'.substring(1, '$time'.length - 3));
}
