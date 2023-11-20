import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mpris/mpris.dart';

class MediaPlayerService extends ChangeNotifier {
  Metadata? metadata;
  bool shuffle = false;
  PlaybackStatus playbackStatus = PlaybackStatus.stopped;
  LoopStatus loopStatus = LoopStatus.none;
  double volume = 0.0;

  List<(MPRISPlayer, String)> players = [];
  (MPRISPlayer, String)? currentPlayer;
  StreamSubscription? _currentPlayerEventSub;
  StreamSubscription? _playerEventSub;

  void init() {
    _getPlayerWithId().then((_) {
      notifyListeners();
      _playerEventSub = MPRIS().playerChanged().listen((e) {
        switch (e) {
          case PlayerMountEvent(:final player):
            player.getIdentity().then((id) { 
              players.add((player, id));
              notifyListeners();
            });
          case PlayerUnmountEvent(:final playerName):
            players.removeWhere((t) => t.$1.name == playerName);
          case PlayerUnknownEvent(:final event):
            print(event);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _currentPlayerEventSub?.cancel();
    _playerEventSub?.cancel();
  }

  Future<void> _getPlayerWithId() async {
    final players = await MPRIS().getPlayers();

    for (final player in players) {
      this.players.add((player, await player.getIdentity()));
    }
  }

  List<String> getPlayersId() {
    return players.map((e) => e.$2).toList();
  }

  void selectPlayer(String id) {
    _currentPlayerEventSub?.cancel();
    final tuple = players.where((player) => player.$2 == id).firstOrNull;
    final player = tuple?.$1;
    _currentPlayerEventSub = player?.propertiesChanged().listen((event) {
      switch (event) {
        case UnsuportedEvent(:final value):
          print(value);
        case MetaDataChanged(:final metadata):
          this.metadata = metadata;
        case PlaybackStatusChanged(:final playbackStatus):
          this.playbackStatus = playbackStatus;
        case LoopStatusChanged(:final loopStatus):
          this.loopStatus = loopStatus;
        case ShuffleChanged(:final shuffle):
          this.shuffle = shuffle;
        case VolumeChanged(:final volume):
          this.volume = volume;
      }
      notifyListeners();
    });
    if(player != null){
      currentPlayer = (player, id);
    }
    notifyListeners();
  }
}
