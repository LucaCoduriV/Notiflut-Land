import 'package:flutter/material.dart';
import 'package:mpris/mpris.dart';
import '../services/mediaplayer_service.dart';

class MediaPlayer extends StatefulWidget {
  const MediaPlayer({super.key});

  @override
  State<MediaPlayer> createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  List<(MPRISPlayer, String)> players = [];
  MPRISPlayer? selectedPlayer = null;
  @override
  void initState() {
    getPlayersWithNames()
        .forEach((player) => players.add(player))
        .then((value) => setState(() {
              selectedPlayer = players.firstOrNull?.$1;
              final playerTracker =
                  selectedPlayer?.tracker(const Duration(seconds: 5));
              playerTracker?.stream.listen((event) {
                switch(event){
                  case EventIdentity(:final identity):
                    print(identity);
                    // TODO: Handle this case.
                  case EventMetadata(:final metadata):
                    print(metadata.trackId);
                    // TODO: Handle this case.
                }
              });
            }));
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  Stream<(MPRISPlayer, String)> getPlayersWithNames() async* {
    final players = await MPRIS().getPlayers();
    for (final player in players) {
      final identity = await player.getIdentity();

      print(identity);
      yield (player, identity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => selectedPlayer?.previous(),
                  child: const Icon(Icons.skip_previous)),
              ElevatedButton(
                  onPressed: () => selectedPlayer?.toggle(),
                  child: const Icon(Icons.play_arrow)),
              ElevatedButton(
                  onPressed: () => selectedPlayer?.next(),
                  child: const Icon(Icons.skip_next)),
            ],
          ),
          Row(
            children: [
              DropdownButton<MPRISPlayer>(
                value: selectedPlayer,
                items: players
                    .map(
                        (e) => DropdownMenuItem(value: e.$1, child: Text(e.$2)))
                    .toList(),
                onChanged: (MPRISPlayer? value) {
                  selectedPlayer = value;
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
