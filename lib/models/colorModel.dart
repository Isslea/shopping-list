import 'dart:ui';

enum ColorType {
  green,
  orange,
  blue,
  yellow,
  pink,
  purple
}

class ColorModel {
  const ColorModel(this.colorName, this.colorCode);

  final String colorName;
  final Color colorCode;
}