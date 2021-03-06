/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';

const Color separatorColor = CupertinoColors.separator;
const Color headerColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xF0ffffff),
  darkColor: Color(0xF0000000),
  // Values extracted from navigation bar. For toolbar or tabbar the dark color is 0xF0161616.
);
const Color secondaryHeaderColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xF0ffffff),
  darkColor: Color(0xF0111111),
  // Values extracted from navigation bar. For toolbar or tabbar the dark color is 0xF0161616.
);
const Color itemColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xF0ffffff),
  darkColor: Color(0xF0000000),
  // Values extracted from navigation bar. For toolbar or tabbar the dark color is 0xF0161616.
);
const Color labelColor = CupertinoDynamicColor(
  debugLabel: 'labelColor',
  color: Color.fromARGB(255, 229, 229, 229),
  darkColor: Color.fromARGB(255, 50, 50, 52),
  highContrastColor: Color.fromARGB(255, 235, 235, 240),
  darkHighContrastColor: Color.fromARGB(255, 54, 54, 56),
  elevatedColor: Color.fromARGB(255, 242, 242, 247),
  darkElevatedColor: Color.fromARGB(255, 58, 58, 60),
  highContrastElevatedColor: Color.fromARGB(255, 235, 235, 240),
  darkHighContrastElevatedColor: Color.fromARGB(255, 68, 68, 70),
);
const Color placeholderColor = CupertinoDynamicColor(
  debugLabel: 'placeholderColor',
  color: Color.fromARGB(255, 129, 129, 134),
  darkColor: Color.fromARGB(255, 161, 161, 168),
  highContrastColor: Color.fromARGB(96, 60, 60, 67),
  darkHighContrastColor: Color.fromARGB(96, 235, 235, 245),
  elevatedColor: Color.fromARGB(76, 60, 60, 67),
  darkElevatedColor: Color.fromARGB(76, 235, 235, 245),
  highContrastElevatedColor: Color.fromARGB(96, 60, 60, 67),
  darkHighContrastElevatedColor: Color.fromARGB(96, 235, 235, 245),
);
const CupertinoDynamicColor systemFill = CupertinoDynamicColor(
  debugLabel: 'systemFill',
  color: Color.fromARGB(255, 239, 239, 240),
  darkColor: Color.fromARGB(255, 28, 28, 31),
  highContrastColor: Color.fromARGB(51, 118, 118, 128),
  darkHighContrastColor: Color.fromARGB(81, 118, 118, 128),
  elevatedColor: Color.fromARGB(30, 118, 118, 128),
  darkElevatedColor: Color.fromARGB(61, 118, 118, 128),
  highContrastElevatedColor: Color.fromARGB(51, 118, 118, 128),
  darkHighContrastElevatedColor: Color.fromARGB(81, 118, 118, 128),
);
