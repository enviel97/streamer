import 'package:flutter/material.dart';
import 'package:streamer/src/controllers/director.controller.dart';
import 'package:streamer/src/models/stream.model.dart';
import 'package:streamer/src/pages/director/bottom_sheet/twitch.dart';
import 'package:streamer/src/pages/director/bottom_sheet/youtube.dart';
import 'package:streamer/src/pages/director/widgets/stream_platform_chip.dart';
import 'package:streamer/src/ultils/migrates/spacing.dart';

class HeaderDirector extends StatelessWidget {
  final DirectorController controller;
  final List<StreamDestination> destinations;
  final String channelName, status;

  const HeaderDirector({
    required this.controller,
    required this.channelName,
    required this.destinations,
    Key? key,
    this.status = 'leaving',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          channelName,
          style: const TextStyle(
            fontSize: Spacing.lg,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.horizantal.s,
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: destinations
                  .map((dest) => StreamPlatformChip(
                        platform: dest.platform,
                        controller: controller,
                        url: dest.url,
                      ))
                  .toList(),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: PopupMenuButton<StreamPlatform>(
            itemBuilder: _buildItem,
            icon: const Icon(Icons.add),
            onSelected: (value) => _addPlatformUrl(context, value),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }

  List<PopupMenuEntry<StreamPlatform>> _buildItem(BuildContext context) {
    const popupItems = <PopupMenuEntry<StreamPlatform>>[
      PopupMenuItem(
        child: ListTile(leading: Icon(Icons.add), title: Text('Youtube')),
        value: StreamPlatform.youtube,
      ),
      PopupMenuDivider(),
      PopupMenuItem(
        child: ListTile(leading: Icon(Icons.add), title: Text('Twitch')),
        value: StreamPlatform.twitch,
      ),
      PopupMenuDivider(),
      PopupMenuItem(
        child: ListTile(leading: Icon(Icons.add), title: Text('Other')),
        value: StreamPlatform.other,
      ),
    ];

    return popupItems;
  }

  void _addPlatformUrl(BuildContext context, StreamPlatform value) {
    switch (value) {
      case StreamPlatform.youtube:
        showBottomSheetYoutube(context, controller: controller);
        return;
      case StreamPlatform.twitch:
        showBottomSheetTwitch(context, controller: controller);
        break;
      case StreamPlatform.other:
        break;
    }
  }
}
