import 'package:flutter/material.dart';
import 'package:streamer/src/controllers/director.controller.dart';
import 'package:streamer/src/models/stream.model.dart';
import 'package:streamer/src/ultils/migrates/spacing.dart';
import 'package:streamer/src/widgets/disable_keyboard.dart';

void showBottomSheetYoutube(
  BuildContext context, {
  required DirectorController controller,
}) {
  showModalBottomSheet<StreamDestination?>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return _YoutubeBottomSheet(controller);
    },
  );
}

class _YoutubeBottomSheet extends StatefulWidget {
  final DirectorController controller;
  const _YoutubeBottomSheet(
    this.controller, {
    Key? key,
  }) : super(key: key);

  @override
  State<_YoutubeBottomSheet> createState() => _YoutubeBottomSheetState();
}

class _YoutubeBottomSheetState extends State<_YoutubeBottomSheet> {
  final urlController = TextEditingController();
  final keyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        margin: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add your stream destinations',
              style: TextStyle(
                fontSize: Spacing.lg,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.vertical.lg,
            TextField(
              autofocus: true,
              controller: urlController,
              textInputAction: TextInputAction.next,
              decoration:
                  const InputDecoration(hintText: 'Stream url: rtmp://... '),
            ),
            Spacing.vertical.lg,
            TextField(
              textInputAction: TextInputAction.done,
              controller: keyController,
              decoration: const InputDecoration(hintText: 'Stream key'),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  if (urlController.text.isNotEmpty &&
                      keyController.text.isNotEmpty) {
                    widget.controller.addPublishDestination(
                        platform: StreamPlatform.youtube,
                        url: '${urlController.text.trim()}/'
                            '${keyController.text.trim()}');
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
