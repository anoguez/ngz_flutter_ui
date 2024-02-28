import 'package:flutter/material.dart';

@immutable
class Palette {
  final Color accent1 = const Color.fromARGB(255, 39, 193, 210);
  final Color accent2 = const Color(0xFF73eb00);
  final Color offWhite = const Color(0xFFF8ECE5);
  final Color white = Colors.white;
  final Color black = Colors.black;
  final Color error = Colors.red;
  final Color disabled = Colors.grey.withOpacity(0.4);
  Color get backgroundMain => const Color(0xFF292929);

  // Knob button
  final Color indicatorDotColor = const Color(0xFF73eb00);
  final Color indicatorArcColor = const Color(0xFF73eb00);
  final Color markerColor = const Color(0xFFbbbbba);
  final Color knobColor = const Color(0xFF212121);
  final Color dialColorDark = const Color(0xFF0d0d0d);
  final Color dialColorLight = const Color(0xFF262626);
  final Color knobColorDark = const Color(0xFF131313);
  final Color knobColorLight = const Color(0xFF272727);
}
