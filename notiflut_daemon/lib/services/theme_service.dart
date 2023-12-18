import 'package:flutter/material.dart';
import 'package:notiflut/messages/theme_event.pb.dart' as proto;

enum ThemeType {
  light,
  dark,
}

class ThemeService extends ChangeNotifier {
  proto.Style? _style;
  ThemeType _type = ThemeType.light;

  set type(ThemeType type) {
    _type = type;
    notifyListeners();
  }

  set style(proto.Style? s) {
    _style = s;
    notifyListeners();
  }

  proto.Theme? get theme => switch (_type) {
        ThemeType.light => _style?.light,
        ThemeType.dark => _style?.dark,
      };
}
