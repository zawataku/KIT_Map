import 'package:flutter/material.dart';
import 'package:kit_map/widgets/campus_map_screen.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, //上向きを許可
  ]);
  runApp(const CampusMapApp());
}

class CampusMapApp extends StatelessWidget {
  const CampusMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KIT Campus Map',
      theme: ThemeData(useMaterial3: true),
      home: const CampusMapScreen(),
    );
  }
}
