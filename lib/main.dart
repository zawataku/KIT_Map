import 'package:flutter/material.dart';
import 'widgets/campus_map_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KIT Campus Map',
      home: const CampusMapPage(),
      theme: ThemeData(
        fontFamily: "M_PLUS_Rounded_1c",
      ),
    );
  }
}
