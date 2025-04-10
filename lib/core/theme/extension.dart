import 'dart:ui';

extension HexColor on String {
  Color toColor() {
    return Color.fromRGBO(
      (int.parse(substring(1, 3), radix: 16) << 16),
      (int.parse(substring(3, 5), radix: 16) << 8),
      int.parse(substring(5, 7), radix: 16),
      255 / 255.0,
    );
  }
}
