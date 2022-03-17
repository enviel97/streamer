import 'package:agora_rtc_engine/rtc_remote_view.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:streamer/src/constants.dart';
import 'package:streamer/src/controllers/director.controller.dart';
import 'package:streamer/src/models/user.model.dart';
import 'package:streamer/src/ultils/migrates/spacing.dart';

import 'toogle_icon_button.dart';

class StageUser extends StatelessWidget {
  final User user;
  final DirectorController controller;
  final void Function() onMuted;
  final void Function() onVideoOff;
  final void Function() onPromoteToActive;

  const StageUser({
    required this.user,
    required this.controller,
    required this.onMuted,
    required this.onVideoOff,
    required this.onPromoteToActive,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = user.backgroundColor ?? kBlackColor;
    final videoDisabled = user.videoDisabled;
    final muted = user.muted;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Stack(
            children: [
              videoDisabled
                  ? Container(
                      color: color == kWhiteColor ? kBlackColor : color,
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 24.0,
                        child: Icon(
                          Icons.person,
                          color: color == kWhiteColor ? kBlackColor : color,
                        ),
                        backgroundColor: kWhiteColor,
                      ),
                    )
                  : SurfaceView(uid: user.uid),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: BorderedText(
                    strokeColor: kBlackColor,
                    child: Text(
                      user.name ?? 'Error name',
                      style: const TextStyle(
                        color: kWhiteColor,
                        fontSize: Spacing.m,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ToogleIconButton(
                isEnable: muted,
                icon: Icons.mic_off,
                onPressed: onMuted,
              ),
              ToogleIconButton(
                isEnable: videoDisabled,
                icon: Icons.videocam_off,
                onPressed: onVideoOff,
              ),
              ToogleIconButton(
                isEnable: true,
                icon: Icons.arrow_downward,
                onPressed: onPromoteToActive,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
