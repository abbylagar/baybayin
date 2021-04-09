import 'package:flutter/material.dart';
import 'package:myapp/screens/draw_screen.dart';
import 'package:myapp/screens/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baybayin Recognizer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.lightBlue,
          elevation: 0
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.lightBlue,
        ),
      ),
    //  home: DrawScreen(),
    home: HomePage(),
    );
  }
}