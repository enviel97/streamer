import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:streamer/src/constants.dart';
import 'package:streamer/src/controllers/director.controller.dart';
import 'package:streamer/src/models/user.model.dart';
import 'package:streamer/src/ultils/migrates/spacing.dart';

import 'toogle_icon_button.dart';

class LobbyUser extends StatelessWidget {
  final User user;
  final DirectorController controller;
  // final void Function() onMuted;
  // final void Function() onVideoOff;
  final void Function() onDemoteToLobby;

  const LobbyUser({
    required this.user,
    required this.controller,
    required this.onDemoteToLobby,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = user.backgroundColor ?? kBlackColor;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Stack(
            children: [
              Container(
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
              ),
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
                isEnable: true,
                icon: Icons.arrow_upward_rounded,
                onPressed: onDemoteToLobby,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
