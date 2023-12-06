import 'package:flutter/material.dart';

class NotificationStyle {
  Color backgroundColor;
  Radius borderRadius;

  NotificationStyle({
    required this.backgroundColor,
    required this.borderRadius,
  });
}

class NotificationCenter {
  Color backgroundColor;

  NotificationCenter({
    required this.backgroundColor,
  });
}

class Theme {
  NotificationStyle notificationStyle;
  Theme({
    required this.notificationStyle,
  });
}

class Style {
  Theme light;
  Theme dark;
  Style({
    required this.light,
    required this.dark,
  });
}
