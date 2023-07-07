import 'package:flutter/material.dart';
import 'package:lol/models/colorModel.dart';

const colorsData = {
  ColorType.green: ColorModel(
    'Zielony',
    Color.fromARGB(255, 0, 255, 128),
  ),
  ColorType.orange: ColorModel(
    'Pomarańczowy',
    Color.fromARGB(255, 255, 102, 0),
  ),
  ColorType.blue: ColorModel(
    'Niebieski',
    Color.fromARGB(255, 0, 208, 255),
  ),
  ColorType.yellow: ColorModel(
    'Żółty',
    Color.fromARGB(255, 255, 187, 0),
  ),
  ColorType.pink: ColorModel(
    'Różowy',
    Color.fromARGB(255, 191, 0, 255),
  ),
  ColorType.purple: ColorModel(
    'Fioletowy',
    Color.fromARGB(255, 149, 0, 255),
  )
};