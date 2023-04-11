

import 'package:flutter/material.dart';
import 'package:let_me_check/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Theme_Help{

  ThemeData light_theme(){
    return ThemeData(
        primaryColor: Colors.greenAccent,
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.light,
      iconTheme: IconThemeData(
        color: Colors.black
      )
    );
  }

  ThemeData dark_theme(){
    return ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        primaryColor: Colors.white,
        iconTheme: IconThemeData(
            color: Colors.white
        ),

    );
  }

}



CustomTheme currentTheme = CustomTheme();

class CustomTheme with ChangeNotifier {
  static bool _isDarkTheme = false;
  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;



  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  // static ThemeData get lightTheme {
  //   return ThemeData(
  //     primaryColor: Colors.lightBlue,
  //     accentColor: Colors.white,
  //     backgroundColor: Colors.white,
  //     scaffoldBackgroundColor: Colors.white,
  //     textTheme: TextTheme(
  //       headline1: TextStyle(color: Colors.black),
  //       headline2: TextStyle(color: Colors.black),
  //       bodyText1: TextStyle(color: Colors.black),
  //       bodyText2: TextStyle(color: Colors.black),
  //     ),
  //   );
  // }
  //
  // static ThemeData get darkTheme {
  //   return ThemeData(
  //     primaryColor: Colors.black,
  //     accentColor: Colors.red,
  //     backgroundColor: Colors.grey,
  //     scaffoldBackgroundColor: Colors.grey,
  //     textTheme: TextTheme(
  //       headline1: TextStyle(color: Colors.white),
  //       headline2: TextStyle(color: Colors.white),
  //       bodyText1: TextStyle(color: Colors.white),
  //       bodyText2: TextStyle(color: Colors.white),
  //     ),
  //   );
  // }
}