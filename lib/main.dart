import 'package:flutter/material.dart';
import 'package:noted/notes.dart';

void main() {
  runApp(MyApp());
}

ThemeData makeTheme(ColorScheme scheme) {
  return ThemeData(
    primaryColor: scheme.primary,
    primaryColorDark: scheme.primaryDark,
    primaryColorLight: scheme.primaryFg,
    backgroundColor: scheme.bg,
    scaffoldBackgroundColor: scheme.bg,
    dialogBackgroundColor: scheme.bg2,
    textTheme: TextTheme(
        bodyText2: TextStyle(color: scheme.fg, fontSize: 14),
        headline6: TextStyle(color: scheme.fg, fontSize: 20),
        subtitle1: TextStyle(color: scheme.fg, fontSize: 20),
        caption: TextStyle(color: scheme.fgLight, fontSize: 14),
        button: TextStyle(color: scheme.fg)),
    cardTheme: CardTheme(
      margin: EdgeInsets.symmetric(horizontal: 32, vertical: 6),
      shadowColor: scheme.bg2,
      elevation: 6,
      color: scheme.bg2,
    ),
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: scheme.fg),
      color: scheme.bg2,
      elevation: 0,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: scheme.primary,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary, focusColor: scheme.primaryDark),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

class ColorScheme {
  Color bg = Color.fromARGB(255, 255, 255, 255);
  Color bg2 = Color.fromARGB(255, 230, 230, 230);
  Color bg3 = Color.fromARGB(255, 128, 128, 128);
  Color fg = Color.fromARGB(235, 0, 0, 0);
  Color fgLight = Color.fromARGB(160, 0, 0, 0);
  Color primary = Color.fromARGB(255, 35, 35, 179);
  Color primaryDark = Color.fromARGB(255, 79, 79, 204);
  Color primaryFg = Color.fromARGB(230, 255, 255, 255);
}

class ColorSchemeDark extends ColorScheme {
  Color bg = Color.fromARGB(255, 31, 30, 37);
  Color bg2 = Color.fromARGB(255, 15, 15, 26);
  Color bg3 = Color.fromARGB(255, 5, 5, 26);
  Color fg = Color.fromARGB(180, 255, 255, 255);
  Color fgLight = Color.fromARGB(100, 255, 255, 255);
  Color primary = Color.fromARGB(255, 35, 35, 179);
  Color primaryDark = Color.fromARGB(255, 79, 79, 204);
  Color primaryFg = Color.fromARGB(230, 255, 255, 255);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noted',
      theme: makeTheme(ColorScheme()),
      darkTheme: makeTheme(ColorSchemeDark()),
      home: NotesScreen(),
    );
  }
}
