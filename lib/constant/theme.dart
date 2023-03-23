import 'package:flutter/material.dart';

import 'color.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
        primaryColor: ConstantColor.mainPrimaryDark,
        cardColor: ConstantColor.myContentColorDarkTheme,
        canvasColor: ConstantColor.myContentColorLightTheme,
      );
  static ThemeData darkTheme(BuildContext context) => ThemeData(
        brightness: Brightness.dark,
        primaryColor: ConstantColor.mainPrimaryDark,
        cardColor: ConstantColor.myContentColorLightTheme,
        canvasColor: ConstantColor.myContentColorDarkTheme,
      );
}
