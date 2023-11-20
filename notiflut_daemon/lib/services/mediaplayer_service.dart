import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mpris/mpris.dart';

class MediaPlayerService extends ChangeNotifier {}

//ignore: non_constant_identifier_names
extension MPRISPlayerEventTrackerGetter on MPRISPlayer {
  /// Listen for event every rate duration.
  MPRISPlayerEventTracker tracker(Duration rate) =>
      MPRISPlayerEventTracker(rate, this);
}

class MPRISPlayerEventTracker {
  final StreamController<MPRISEvent> _controller = StreamController();
  late final Timer _timer;
  final MPRISPlayer _player;
  final Duration _rate;

  String identity = "";
  Metadata? metadata;

  MPRISPlayerEventTracker(this._rate, this._player);

  void _checkForChange(Timer timer) {
    try {
      _player.getMetadata().then((newMetadata) {
        if (metadata == null || metadata!.trackId != newMetadata.trackId) {
          metadata = newMetadata;
          _controller.add(EventMetadata(newMetadata));
        }
      });
    } catch (e) {}

    try {
      _player.getIdentity().then((newIdentity) {
        if (newIdentity.compareTo(identity) != 0) {
          identity = newIdentity;
          _controller.add(EventIdentity(newIdentity));
        }
      });
    } catch (e) {}
  }

  Stream<MPRISEvent> get stream {
    _timer = Timer.periodic(_rate, _checkForChange);
    return _controller.stream;
  }

  void dispose() {
    _timer.cancel();
    _controller.close();
  }
}

sealed class MPRISEvent {
  const MPRISEvent();
}

class EventIdentity extends MPRISEvent {
  final String identity;
  const EventIdentity(this.identity);
}

class EventMetadata extends MPRISEvent {
  final Metadata metadata;
  const EventMetadata(this.metadata);
}
