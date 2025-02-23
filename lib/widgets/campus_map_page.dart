import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'campus_map.dart';
import 'floating_search_app_bar.dart';

class CampusMapPage extends StatefulWidget {
  const CampusMapPage({super.key});

  @override
  State<CampusMapPage> createState() => _CampusMapPageState();
}

class _CampusMapPageState extends State<CampusMapPage> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CampusMap(mapController: _mapController),
          FloatingSearchAppBar(mapController: _mapController),
        ],
      ),
    );
  }
}
