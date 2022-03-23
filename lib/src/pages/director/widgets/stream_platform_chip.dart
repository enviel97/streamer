import 'package:flutter/material.dart';
import 'package:streamer/src/constants.dart';
import 'package:streamer/src/controllers/director.controller.dart';
import 'package:streamer/src/models/stream.model.dart';
import 'package:streamer/src/ultils/extentions/string.dart';
import 'package:streamer/src/ultils/migrates/spacing.dart';
import 'package:streamer/src/ultils/ultils.dart';

class StreamPlatformChip extends StatelessWidget {
  final StreamPlatform platform;
  final String url;
  final DirectorController controller;
  final bool isLived;
  final Color? backgroundColor;

  const StreamPlatformChip({
    required this.platform,
    required this.controller,
    required this.url,
    Key? key,
    this.backgroundColor,
    this.isLived = false,
  }) : super(key: key);

  String get label => platform.name.split('.').last.firstUperCase();
  Color get color {
    switch (platform) {
      case StreamPlatform.youtube:
        return youtubeColor;
      case StreamPlatform.twitch:
        return twitterColor;
      case StreamPlatform.other:
        return backgroundColor ?? randomeColor();
      case StreamPlatform.facebook:
        return facebookColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Chip(
        backgroundColor: color,
        shadowColor: color,
        elevation: 5.0,
        labelStyle: const TextStyle(
          fontSize: Spacing.s,
          fontWeight: FontWeight.bold,
          color: kWhiteColor,
        ),
        label: Text(label),
        deleteIconColor: kWhiteColor,
        onDeleted: () {
          if (isLived) return;
          controller.removePublishDestination(platform: platform, url: url);
        },
      ),
    );
  }
}
