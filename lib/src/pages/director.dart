import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamer/src/controllers/director.controller.dart';

class Director extends StatefulWidget {
  const Director({Key? key}) : super(key: key);

  @override
  State<Director> createState() => _DirectorState();
}

class _DirectorState extends State<Director> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final notifier = ref.watch(directorController.notifier);
        final model = ref.watch(directorController);

        // notifier.muteUser();

        final text = Text('${model.activeUsers.elementAt(1).muted}');

        return Scaffold(
          body: Center(
            child: Text('Director'),
          ),
        );
      },
    );
  }
}
