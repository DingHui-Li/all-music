import 'dart:ui';

import 'package:flutter/material.dart';

Color HexColor(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

Map getThemeColor(isDark) {
  return {
    '_bgColor': isDark ? Colors.black54 : HexColor('#eeeeee'),
    '_primaryColor': isDark ? HexColor('#263238') : Colors.white,
    '_textColor': isDark ? Colors.white : Colors.black
  };
}
