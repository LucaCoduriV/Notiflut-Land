import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_acrylic/window.dart';
import 'package:flutter_acrylic/window_effect.dart';
import 'package:test_flutter_russt/src/native.dart';

import 'package:image/image.dart' as img;

Image create_image(int width, int height, Uint8List bytes, int channels, int rowStride){
  final image =  img.Image.fromBytes(
      width: width,
      height: height,
      bytes: bytes.buffer,
      numChannels: channels,
      rowStride: rowStride,
      order: img.ChannelOrder.rgb
      );
  final png = img.encodePng(image); 
  return Image.memory(png, height: 100, width: 100, );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  await Window.setEffect(
    effect: WindowEffect.transparent,
    color: Colors.transparent,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demmmmmo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: const ColorScheme.light(background: Colors.transparent)),
      home: const MyHomePage(title: 'Flutter lol Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Stream<DeamonAction>? ticks;

  @override
  void initState() {
    super.initState();
  }

  void _incrementCounter() async {
    await api.setup();
    ticks = await api.startDeamon();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (ticks != null)
            StreamBuilder<DeamonAction>(
              stream: ticks,
              builder: (context, snap) {
                final style = Theme.of(context).textTheme.headlineMedium;
                final error = snap.error;
                if (error != null) {
                  return Tooltip(
                      message: error.toString(),
                      child: Text('Error', style: style));
                }

                final data = snap.data;
                if (data != null) {
                  return data.whenOrNull(show: (notification){
                    final imageData = notification.hints.imageData!;
                    print("${imageData.channels}, ${imageData.onePointTwoBitAlpha}, ${imageData.rowstride}, ${imageData.width}, ${imageData.height}");
                    return Column(
                      children: [
                        Text(notification.summary, style: style),
                        create_image(
                          notification.hints.imageData!.width,
                          notification.hints.imageData!.height,
                          notification.hints.imageData!.data, 
                          notification.hints.imageData!.onePointTwoBitAlpha == true ? 4 : 3,
                          notification.hints.imageData!.rowstride,
                          ),
                      ],
                    );
                    })!;
                }
                return const CircularProgressIndicator();
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
