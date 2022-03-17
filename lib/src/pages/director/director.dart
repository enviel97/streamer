import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamer/src/models/user.model.dart';
import 'package:streamer/src/controllers/director.controller.dart';
import 'package:streamer/src/pages/director/widgets/lobby_user.dart';

import 'widgets/stage_user.dart';

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
  @override
  void initState() {
    super.initState();

    ref.read(directorController.notifier).joinCall(
          channelName: widget.channelName,
          uid: widget.uid,
        );
  }

  @override
  void dispose() {
    ref.read(directorController.notifier).leaveCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(directorController);
    final controller = ref.watch(directorController.notifier);
    print(widget.channelName);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [SafeArea(child: _buildDirector)],
              ),
            ),
            ..._buildUserSets(
              data.activeUsers,
              emptyNoted: 'Empty state',
              delegate: SliverChildBuilderDelegate((context, index) {
                return Row(children: [
                  Expanded(
                    child: StageUser(
                      user: data.activeUsers.elementAt(index),
                      controller: controller,
                      onMuted: () {
                        controller.toggleUserAudio(index: index);
                      },
                      onPromoteToActive: () {
                        controller.demoteToActiveUser(
                          uid: data.activeUsers.elementAt(index).uid,
                        );
                      },
                      onVideoOff: () {
                        controller.toggleUserVideo(index: index);
                      },
                    ),
                  )
                ]);
              }, childCount: data.activeUsers.length),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    thickness: 3,
                    indent: 80.0,
                    endIndent: 80.0,
                  ),
                )
              ]),
            ),
            ..._buildUserSets(
              data.lobbyUsers,
              emptyNoted: 'Empty lobby',
              delegate: SliverChildBuilderDelegate((context, index) {
                return Row(children: [
                  Expanded(
                    child: LobbyUser(
                      user: data.lobbyUsers.elementAt(index),
                      controller: ref.watch(directorController.notifier),
                      onDemoteToLobby: () {
                        controller.promoteToActiveUser(
                          uid: data.lobbyUsers.elementAt(index).uid,
                        );
                      },
                      // onMuted: () {},
                      // onVideoOff: () {},
                    ),
                  )
                ]);
              }, childCount: data.lobbyUsers.length),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildUserSets(
    Set<User> users, {
    required SliverChildDelegate delegate,
    String emptyNoted = 'Empty',
  }) {
    final size = MediaQuery.of(context).size;
    return [
      if (users.isEmpty)
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(emptyNoted),
                ),
              )
            ],
          ),
        ),
      SliverGrid(
        delegate: delegate,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: size.width / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
      ),
    ];
  }

  Widget get _buildDirector {
    return Text('Director');
  }
}
