import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const CampusMapApp());
}

class CampusMapApp extends StatelessWidget {
  const CampusMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Map',
      theme: ThemeData(useMaterial3: true),
      home: const CampusMapScreen(),
    );
  }
}

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});

  @override
  State<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  List<Building> buildings = [];

  @override
  void initState() {
    super.initState();
    _loadBuildings();
  }

  Future<void> _loadBuildings() async {
    final String jsonString =
        await rootBundle.loadString('assets/buildings.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    setState(() {
      buildings = jsonData.map((data) => Building.fromJson(data)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('キャンパスマップ')),
      body: Stack(
        children: [
          // 地図画像の表示
          InteractiveViewer(
            minScale: 1.0,
            maxScale: 5.0,
            child: Center(
              child: Image.asset('assets/map_2024.png'),
            ),
          ),
          // 読み込んだ建物を配置
          ...buildings.map((building) {
            return Positioned(
              left: building.x.toDouble(),
              top: building.y.toDouble(),
              child: GestureDetector(
                onTap: () => _showBuildingInfo(context, building),
                child: Icon(Icons.location_on, color: building.color, size: 40),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showBuildingInfo(BuildContext context, Building building) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(building.name,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 10),
              Text(building.description),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('閉じる'),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 建物データを管理するクラス
class Building {
  final String name;
  final String description;
  final int x;
  final int y;
  final Color color;

  Building({
    required this.name,
    required this.description,
    required this.x,
    required this.y,
    required this.color,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      name: json['name'],
      description: json['description'],
      x: json['x'],
      y: json['y'],
      color: _colorFromString(json['color']),
    );
  }

  static Color _colorFromString(String color) {
    switch (color.toLowerCase()) {
      case "red":
        return Colors.red;
      case "blue":
        return Colors.blue;
      case "green":
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}
