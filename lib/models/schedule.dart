
import 'dart:ui';

class Schedule {
  final String subject;
  final String time;
  final String day;
  final String colorHex;

  Schedule({
    required this.subject,
    required this.time,
    required this.day,
    required this.colorHex,
  });

  // Optional helper to convert color hex string to Color
  static int _hexToInt(String hex) => int.parse(hex.replaceAll('#', '0xff'));

  Color get color => Color(_hexToInt(colorHex));
}
