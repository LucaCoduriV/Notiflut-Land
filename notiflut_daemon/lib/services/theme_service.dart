import 'package:flutter/material.dart';
import 'package:notiflut/messages/daemon_event.pb.dart';

class ThemeService extends ChangeNotifier {
  Style? _style;

  set style(Style? s) {
    _style = s;
    notifyListeners();
  }

  Style? get style => _style;
}
