import 'package:flutter/material.dart';

class MediaPlayer extends StatefulWidget {
  const MediaPlayer({super.key});

  @override
  State<MediaPlayer> createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(onPressed: () {}, child: Text("Previous")),
              ElevatedButton(onPressed: () {}, child: Text("Play/Pause")),
              ElevatedButton(onPressed: () {}, child: Text("Next")),
            ],
          ),
          Row(
            children: [
              DropdownButton(
              value: "ELEMENT 1",
                items: ["ELEMENT 1", "ELEMENT 2"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (String? value) {},
              )
            ],
          )
        ],
      ),
    );
  }
}
