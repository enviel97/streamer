import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

import 'migrates/agora.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final agora = Agora();

  @override
  void initState() {
    super.initState();
    agora.initial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Stack(
        children: [
          AgoraVideoViewer(client: agora.client),
          AgoraVideoButtons(client: agora.client),
        ],
      ),
    );
  }
}
