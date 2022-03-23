import 'package:flutter/material.dart';
import 'package:streamer/src/controllers/director.controller.dart';
import 'package:streamer/src/models/user.model.dart';

import '../widgets/lobby_user.dart';

class LobbyDirector extends StatelessWidget {
  final Set<User> data;
  final DirectorController controller;

  const LobbyDirector({
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
                child: const Text('Empty lobby'),
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
            child: LobbyUser(
              user: data.elementAt(index),
              controller: controller,
              onDemoteToLobby: () {
                controller.promoteToActiveUser(
                  uid: data.elementAt(index).uid,
                );
              },
              // onMuted: () {},
              // onVideoOff: () {},
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
