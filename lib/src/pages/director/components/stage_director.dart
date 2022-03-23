import 'package:flutter/material.dart';
import 'package:streamer/src/controllers/director.controller.dart';
import 'package:streamer/src/models/user.model.dart';

import '../widgets/stage_user.dart';

class StageDirector extends StatelessWidget {
  final Set<User> data;
  final DirectorController controller;

  const StageDirector({
    required this.data,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SliverList(
        delegate: SliverChildListDelegate(
          [
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: const Text('Empty Stage'),
              ),
            )
          ],
        ),
      );
    }
    final size = MediaQuery.of(context).size;
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Row(children: [
          Expanded(
            child: StageUser(
              user: data.elementAt(index),
              controller: controller,
              onMuted: () {
                controller.toggleUserAudio(index: index);
              },
              onPromoteToActive: () {
                controller.demoteToActiveUser(
                  uid: data.elementAt(index).uid,
                );
              },
              onVideoOff: () {
                controller.toggleUserVideo(index: index);
              },
            ),
          )
        ]);
      }, childCount: data.length),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: size.width / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
    );
  }
}
