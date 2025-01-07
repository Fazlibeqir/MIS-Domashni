import 'package:flutter/material.dart';
final ThemeData theme = ThemeData(
  brightness: Brightness.dark,  // Force dark mode
  primaryColor: Colors.black,
  colorScheme: const ColorScheme.dark(secondary: Colors.amber),
  canvasColor: Colors.black,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Colors.white, fontSize: 22),
    bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
    bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
    bodySmall: TextStyle(color: Colors.white, fontSize: 14),
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.amber,
    unselectedItemColor: Colors.grey,
  ),
);