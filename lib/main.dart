import 'package:flutter/material.dart';
import 'package:locall/screens/bottom_nav.dart';
import 'package:locall/screens/splash_screen.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: SplashScreen()));
}
