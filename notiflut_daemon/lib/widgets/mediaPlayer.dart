import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../services/mediaplayer_service.dart';

class MediaPlayer extends StatefulWidget with WatchItStatefulWidgetMixin {
  MediaPlayer({super.key});

  @override
  State<MediaPlayer> createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  late MediaPlayerService mpService;
  @override
  void initState() {
    mpService = di<MediaPlayerService>();
    mpService.init();
    super.initState();
  }

  @override
  void dispose() {
    mpService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mpService = watchIt<MediaPlayerService>();
    final players = mpService.players;
    final currentPlayer = mpService.currentPlayer;

    return Card(
      margin: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => mpService.currentPlayer?.$1.previous(),
                  child: const Icon(Icons.skip_previous)),
              ElevatedButton(
                  onPressed: () => mpService.currentPlayer?.$1.toggle(),
                  child: const Icon(Icons.play_arrow)),
              ElevatedButton(
                  onPressed: () => mpService.currentPlayer?.$1.next(),
                  child: const Icon(Icons.skip_next)),
            ],
          ),
          Row(
            children: [
              DropdownButton<String>(
                value: currentPlayer?.$2,
                items: players
                    .map(
                        (e) => DropdownMenuItem(value: e.$2, child: Text(e.$2)))
                    .toList(),
                onChanged: (String? playerId) {
                  if (playerId == null) {
                    return;
                  }
                  setState(() {
                    mpService.selectPlayer(playerId);
                  });
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
