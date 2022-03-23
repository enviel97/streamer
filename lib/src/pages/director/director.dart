import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamer/src/constants.dart';
import 'package:streamer/src/controllers/director.controller.dart';
import 'package:streamer/src/models/director.model.dart' as model;
import 'package:streamer/src/pages/director/components/header_director.dart';
import 'package:streamer/src/pages/director/components/lobby_director.dart';
import 'package:streamer/src/ultils/widgets/noted.dart';

import 'components/stage_director.dart';

class Director extends ConsumerStatefulWidget {
  final String channelName;
  final int uid;
  const Director({
    required this.channelName,
    required this.uid,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<Director> createState() => _DirectorState();
}

class _DirectorState extends ConsumerState<Director> {
  String url = '', key = '';

  @override
  void initState() {
    super.initState();
    // ref.read(directorController.notifier).joinCall(
    //       channelName: widget.channelName,
    //       uid: widget.uid,
    //     );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(directorController.notifier);
    final data = ref.watch(directorController);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularMenu(
            alignment: Alignment.bottomRight,
            toggleButtonColor: Colors.black87,
            toggleButtonBoxShadow: [
              const BoxShadow(color: Colors.black26, blurRadius: 10.0)
            ],
            items: [
              CircularMenuItem(
                onTap: () => _endStream(controller),
                icon: Icons.call_end,
                color: kRedColor,
              ),
              CircularMenuItem(
                onTap: () => _streamingHandler(controller, data),
                icon: data.isLive ? Icons.cancel : Icons.videocam,
                color: Colors.orange,
              ),
            ],
            backgroundWidget: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      SafeArea(
                        child: HeaderDirector(
                          channelName: widget.channelName,
                          controller: controller,
                          destinations: data.destination,
                        ),
                      )
                    ],
                  ),
                ),
                StageDirector(controller: controller, data: data.activeUsers),
                SliverList(
                    delegate: SliverChildListDelegate([
                  const Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                          Divider(thickness: 3, indent: 80.0, endIndent: 80.0))
                ])),
                LobbyDirector(controller: controller, data: data.lobbyUsers),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _streamingHandler(
    DirectorController controller,
    model.Director data,
  ) {
    if (data.isLive) {
      controller.endStream();
    } else {
      if (data.destination.isNotEmpty) {
        controller.startStream();
      } else {
        KAlertDialog.of(context).error(
          title: 'Noted',
          content: 'Invalid public streaming link',
          confirmText: 'Ok',
        );
      }
    }
  }

  void _endStream(DirectorController controller) {
    controller.leaveCall();
    Navigator.of(context).pop();
  }
}
