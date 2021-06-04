import 'package:flutter/material.dart';

var lightThemeData = new ThemeData(
    primaryColor: Colors.white,
    textTheme: new TextTheme(button: TextStyle(color: Colors.white70)),
    brightness: Brightness.light,
    accentColor: Colors.white);

var darkThemeData = ThemeData(
    primaryColor: Colors.black38,
    textTheme: new TextTheme(button: TextStyle(color: Colors.black54)),
    brightness: Brightness.dark,
    accentColor: Colors.black);