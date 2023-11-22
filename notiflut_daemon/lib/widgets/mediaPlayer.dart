import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mpris/mpris.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mpService = watchIt<MediaPlayerService>();
    final metadata = mpService.metadata;
    final color = mpService.bestTextColor ?? Colors.black;
    final textStyle = TextStyle(
      color: color,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );

    return Card(
      color: const Color(0xBBE0E0E0),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        decoration: metadata?.trackArtUrl != null
            ? BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(metadata!.trackArtUrl!),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.center,
                ),
              )
            : null,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CardTitle(color: color),
                    if (metadata?.trackArtists != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            metadata!.trackArtists!.join(" - "),
                            style: textStyle,
                          )
                        ],
                      ),
                    if (metadata?.trackTitle != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                          width: 400,
                            child: Text(
                              metadata!.trackTitle!,
                              style: textStyle,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    PlayerButtons(color: color),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlayerButtons extends StatefulWidget with WatchItStatefulWidgetMixin {
  final Color color;

  const PlayerButtons({
    required this.color,
    super.key,
  });

  @override
  State<PlayerButtons> createState() => _PlayerButtonsState();
}

class _PlayerButtonsState extends State<PlayerButtons> {
  @override
  Widget build(BuildContext context) {
    final mpService = watchIt<MediaPlayerService>();
    final players = mpService.players;
    final currentPlayer = mpService.currentPlayer;
    final color = widget.color;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: DropdownButton<String>(
            style: TextStyle(color: color),
            value: currentPlayer?.$2,
            items: players
                .map((e) => DropdownMenuItem(value: e.$2, child: Text(e.$2)))
                .toList(),
            onChanged: (String? playerId) {
              if (playerId == null) {
                return;
              }
              setState(() {
                mpService.selectPlayer(playerId);
              });
            },
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (mpService.shuffle != null)
                SuffleButton(mpService: mpService, color: color),
              PreviousButton(mpService: mpService, color: color),
              PlayPauseButton(mpService: mpService, color: color),
              NextButton(mpService: mpService, color: color),
              if (mpService.loopStatus != null)
                LoopButton(mpService: mpService, color: color),
            ],
          ),
        ),
        Expanded(flex: 1, child: Container()),
      ],
    );
  }
}

class LoopButton extends StatelessWidget {
  const LoopButton({
    super.key,
    required this.mpService,
    required this.color,
  });

  final MediaPlayerService mpService;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () =>
          mpService.currentPlayer?.$1.setLoopStatus(LoopStatus.none),
      icon: switch (mpService.loopStatus) {
        LoopStatus.none => Icon(Icons.repeat_outlined, color: color),
        LoopStatus.track => Icon(Icons.repeat_one_outlined, color: color),
        LoopStatus.playlist ||
        null =>
          Icon(Icons.repeat_on_outlined, color: color),
      },
    );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
    required this.mpService,
    required this.color,
  });

  final MediaPlayerService mpService;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => mpService.currentPlayer?.$1.next(),
        icon: Icon(Icons.skip_next_outlined, color: color));
  }
}

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    super.key,
    required this.mpService,
    required this.color,
  });

  final MediaPlayerService mpService;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => mpService.currentPlayer?.$1.toggle(),
        icon: mpService.playbackStatus == PlaybackStatus.playing
            ? Icon(Icons.pause_outlined, color: color)
            : Icon(Icons.play_arrow_outlined, color: color));
  }
}

class PreviousButton extends StatelessWidget {
  const PreviousButton({
    super.key,
    required this.mpService,
    required this.color,
  });

  final MediaPlayerService mpService;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => mpService.currentPlayer?.$1.previous(),
        icon: Icon(Icons.skip_previous_outlined, color: color));
  }
}

class SuffleButton extends StatelessWidget {
  const SuffleButton({
    super.key,
    required this.mpService,
    required this.color,
  });

  final MediaPlayerService mpService;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () =>
          mpService.currentPlayer?.$1.setShuffle(!mpService.shuffle!),
      icon: switch (mpService.shuffle) {
        true => Icon(Icons.shuffle_on_outlined, color: color),
        _ => Icon(Icons.shuffle_outlined, color: color),
      },
    );
  }
}

class CardTitle extends StatelessWidget with WatchItMixin {
  final Color color;
  const CardTitle({required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    final title = watchPropertyValue(
        (MediaPlayerService s) => s.currentPlayer?.$2 ?? "Title not found");
    return Row(
      children: [
        Icon(
          Icons.music_note,
          color: color,
        ),
        Text(title, style: TextStyle(color: color)),
      ],
    );
  }
}
