import 'package:flutter/material.dart';
import 'package:my_daily_life/LoginPage.dart';
import 'package:my_daily_life/Home.dart'; // APAGAR DEPOIS<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

void main() {
  runApp(MaterialApp(
    title: "My Daily Life",
    theme: ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: Colors.black,
    ),
    // home: LoginPage(),
    home: Home(), // APAGAR DEPOIS<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    debugShowCheckedModeBanner: false,
  ));
}
