import 'dart:developer';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExampleSubWindow extends StatefulWidget {
  const ExampleSubWindow({
    Key? key,
    required this.windowController,
    required this.args,
  }) : super(key: key);

  final WindowController windowController;
  final Map? args;

  @override
  State<ExampleSubWindow> createState() => _ExampleSubWindowState();
}

class _ExampleSubWindowState extends State<ExampleSubWindow> {
  String title = "";

  @override
  void initState() {
    super.initState();
    DesktopMultiWindow.setMethodHandler(_handleMethodCallback);
  }

  Future<dynamic> _handleMethodCallback(
    MethodCall call,
    int fromWindowId,
  ) async {
    switch (call.method) {
      case "ping":
        log("pong !");
        break;
      case "Show":
        Future.delayed(const Duration(seconds: 5)).then((value) {
            DesktopMultiWindow.invokeMethod(0, "hided");
            widget.windowController.hide();
          });
        widget.windowController.show();
        title = call.arguments;
        setState(() {});
        break;
      default:
        {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(150, 255, 255, 255),
        appBar: AppBar(
          title: Text(title),
        ),
        body: Column(
          children: [
            if (widget.args != null)
              Text(
                'Arguments: ${widget.args.toString()}',
                style: const TextStyle(fontSize: 20),
              ),
            OutlinedButton(
                onPressed: () {
                  widget.windowController.hide();
                },
                child: Text("CLOSE !"))
          ],
        ),
      ),
    );
  }
}
