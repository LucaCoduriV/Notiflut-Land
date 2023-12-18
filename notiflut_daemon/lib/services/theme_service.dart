import 'package:flutter/material.dart';
import 'package:notiflut/messages/theme_event.pb.dart' as proto;

enum ThemeType {
  light,
  dark,
}

class ThemeService extends ChangeNotifier {
  proto.Style? _style;
  ThemeType type = ThemeType.light;

  set style(proto.Style? s) {
    _style = s;
    notifyListeners();
  }

  proto.Theme? get theme => switch (type) {
        ThemeType.light => _style?.light,
        ThemeType.dark => _style?.dark,
      };
}
