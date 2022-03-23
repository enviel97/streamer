import 'package:flutter/material.dart';
import 'package:streamer/src/constants.dart';
import 'package:streamer/src/ultils/widgets/custom_icon_button.dart';

class Toolbar extends StatelessWidget {
  final bool muted, videoDisabled;
  final void Function() onToggleMute, onToggleVideoDisabled, onSwitchCamera;

  const Toolbar({
    required this.onToggleMute,
    required this.onToggleVideoDisabled,
    required this.onSwitchCamera,
    this.muted = false,
    this.videoDisabled = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          KIconButton(
            color: muted ? kWhiteColor : Colors.blueAccent,
            backgroundColor: muted ? Colors.blueAccent : kWhiteColor,
            icon: muted ? Icons.mic_off : Icons.mic,
            onPressed: onToggleMute,
          ),
          KIconButton(
            size: 35.0,
            color: kWhiteColor,
            backgroundColor: Colors.redAccent,
            icon: Icons.call_end,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          KIconButton(
            color: videoDisabled ? kWhiteColor : Colors.blueAccent,
            backgroundColor: videoDisabled ? Colors.blueAccent : kWhiteColor,
            icon: videoDisabled ? Icons.videocam_off : Icons.videocam,
            onPressed: onToggleVideoDisabled,
          ),
          KIconButton(
            color: Colors.blueAccent,
            backgroundColor: kWhiteColor,
            icon: Icons.switch_camera,
            onPressed: onSwitchCamera,
          ),
        ],
      ),
    );
  }
}
