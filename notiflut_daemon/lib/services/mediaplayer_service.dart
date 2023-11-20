import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mpris/mpris.dart';

import '../utils.dart';

class MediaPlayerService extends ChangeNotifier {
  static Map<String, Color> bestTextColorCache = {};

  Metadata? metadata;
  bool? shuffle;
  PlaybackStatus? playbackStatus;
  LoopStatus? loopStatus;
  double? volume;
  Color? bestTextColor;

  List<(MPRISPlayer, String)> players = [];
  (MPRISPlayer, String)? currentPlayer;
  StreamSubscription? _currentPlayerEventSub;
  StreamSubscription? _playerEventSub;

  get showMediaPlayerWidget => players.isNotEmpty;

  void init() {
    _getPlayerWithId().then((_) {
      _getAllCurrentPlayerData();
      _playerEventSub = MPRIS().playerChanged().listen((e) {
        switch (e) {
          case PlayerMountEvent(:final player):
            player.getIdentity().then((id) {
              players.add((player, id));
              notifyListeners();
            });
          case PlayerUnmountEvent(:final playerName):
            players.removeWhere((t) => t.$1.name == playerName);
            final nextPlayer = players.firstOrNull;
            if(nextPlayer != null){
              selectPlayer(nextPlayer.$2);
            }
            notifyListeners();
          case PlayerUnknownEvent(:final event):
            print(event);
        }
      });
    });
  }

  Future<Color> _computeBestTextColor(String url) async {
    if (bestTextColorCache[url] != null) {
      return bestTextColorCache[url]!;
    }
    final dominantColor = await getDominantColor(NetworkImage(url));
    if (dominantColor == null) {
      return Colors.black;
    }
    final textColor = getContrastingTextColor(dominantColor);
    bestTextColorCache[url] = textColor;

    return textColor;
  }

  void _getAllCurrentPlayerData() {
    currentPlayer?.$1.getVolume().then((value) {
      volume = value;
      notifyListeners();
    }).catchError((e) {
      volume = null;
      notifyListeners();
    });
    currentPlayer?.$1.getShuffle().then((value) {
      shuffle = value;
      notifyListeners();
    }).catchError((e) {
      shuffle = null;
      notifyListeners();
    });
    currentPlayer?.$1.getLoopStatus().then((value) {
      loopStatus = value;
      notifyListeners();
    }).catchError((e) {
      loopStatus = null;
      notifyListeners();
    });

    currentPlayer?.$1.getMetadata().then((value) {
      metadata = value;
      notifyListeners();
      return value;
    }).then((value) {
      if (value.trackArtUrl != null) {
        _computeBestTextColor(value.trackArtUrl!).then((color) {
          bestTextColor = color;
          notifyListeners();
        });
      }else{
        bestTextColor = Colors.black;
      }
    }).catchError((e) {
      metadata = null;
      notifyListeners();
    });
    currentPlayer?.$1.getPlaybackStatus().then((value) {
      playbackStatus = value;
      notifyListeners();
    }).catchError((e) {
      playbackStatus = null;
      notifyListeners();
    });
  }

  void deinit() {
    _currentPlayerEventSub?.cancel();
    _playerEventSub?.cancel();
  }

  @override
  void dispose() {
    deinit();
    super.dispose();
  }

  Future<void> _getPlayerWithId() async {
    final players = await MPRIS().getPlayers();

    for (final player in players) {
      this.players.add((player, await player.getIdentity()));
    }
    currentPlayer = this.players.firstOrNull;
    notifyListeners();
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

          if (metadata.trackArtUrl != null) {
            print("TRACK URL ${metadata.trackArtUrl}");
            _computeBestTextColor(metadata.trackArtUrl!).then((color) {
              bestTextColor = color;
              notifyListeners();
            });
          }else{
            bestTextColor = Colors.black;
          }
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
    if (player != null) {
      currentPlayer = (player, id);
      _getAllCurrentPlayerData();
    }
    notifyListeners();
  }
}
