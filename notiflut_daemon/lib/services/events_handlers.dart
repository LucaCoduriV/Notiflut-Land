import 'package:notiflut/messages/theme_event.pb.dart' as theme_event;
import 'package:watch_it/watch_it.dart';
import 'theme_service.dart';

void handleThemeChanged(theme_event.Style style) async {
  final themeService = di<ThemeService>();
  themeService.style = style;
  print("STYLE UPDATED");
}

void handleThemeTypeChanged(ThemeType themeType) async {
  final themeService = di<ThemeService>();
  themeService.type = themeType;
}
