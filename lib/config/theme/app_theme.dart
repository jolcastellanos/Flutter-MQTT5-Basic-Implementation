import 'package:flutter/material.dart';

final colorList = <Color>[
  Colors.green,
  Colors.green.shade100,
  Colors.green.shade200,
  Colors.green.shade300,
  Colors.green.shade400,
  Colors.green.shade500,
  Colors.blueGrey.shade100,
  Colors.blueGrey.shade200,
  Colors.blueGrey.shade300,
  Colors.blueGrey.shade400,
  Colors.blueGrey.shade500,
  Colors.deepOrange.shade100,
  Colors.deepOrange.shade200,
  Colors.deepOrange.shade300,
  Colors.deepOrange.shade400,
  Colors.deepOrange.shade500,
];

class AppTheme {
  final int selectedColor;

  AppTheme({required this.selectedColor})
      : assert(selectedColor >= 0, 'selectedColor must be greather than 0'),
        assert(selectedColor <= colorList.length,
            'selectedColor must be less than ${colorList.length}');

  ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: colorList[selectedColor],
      appBarTheme: const AppBarTheme(
        centerTitle: true
      )
    );
  }
}
