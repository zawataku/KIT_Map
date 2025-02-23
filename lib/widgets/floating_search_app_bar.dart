import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class Building {
  final String name;
  final double latitude;
  final double longitude;

  Building(
      {required this.name, required this.latitude, required this.longitude});

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class FloatingSearchAppBar extends StatefulWidget {
  const FloatingSearchAppBar({super.key, required this.mapController});

  final MapController mapController;

  @override
  State<FloatingSearchAppBar> createState() => _FloatingSearchAppBarState();
}

class _FloatingSearchAppBarState extends State<FloatingSearchAppBar> {
  List<Building> allBuildings = [];
  List<Building> filteredBuildings = [];

  @override
  void initState() {
    super.initState();
    _loadBuildings();
  }

  Future<void> _loadBuildings() async {
    final String jsonString =
        await rootBundle.loadString('assets/pin_data.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    setState(() {
      allBuildings = jsonData.map((data) => Building.fromJson(data)).toList();
    });
  }

  void _filterBuildings(String query) {
    setState(() {
      filteredBuildings = allBuildings
          .where((building) => building.name.contains(query))
          .toList();
    });
  }

  void _moveToBuilding(Building building) {
    widget.mapController
        .move(LatLng(building.latitude, building.longitude), 17.5);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
      hint: '号館を検索',
      borderRadius: BorderRadius.circular(25),
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 500),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      openAxisAlignment: 0.0,
      debounceDelay: const Duration(milliseconds: 300),
      onQueryChanged: _filterBuildings,
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction.searchToClear(showIfClosed: false),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredBuildings.length,
              itemBuilder: (context, index) {
                final building = filteredBuildings[index];
                return ListTile(
                  title: Text(building.name),
                  onTap: () {
                    _moveToBuilding(building);
                    FloatingSearchBar.of(context)?.close();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
