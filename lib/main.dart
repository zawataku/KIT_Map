import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

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

class PinData {
  num x, y;
  final String message;
  PinData(this.x, this.y, this.message);

  factory PinData.fromJson(Map<String, dynamic> json) {
    return PinData(json['x'], json['y'], json['message']);
  }
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  final _transformationController = TransformationController();
  double scale = 1.0;
  double defaultWidth = 50.0;
  double defaultHeight = 50.0;
  double defFontSize = 20.0;

  List<PinData> pinDataList = [];

  @override
  void initState() {
    super.initState();
    loadPinData();
  }

  Future<void> loadPinData() async {
    final String response = await rootBundle.loadString('assets/pin_data.json');
    final data = await json.decode(response) as List;
    setState(() {
      pinDataList = data.map((json) => PinData.fromJson(json)).toList();
    });
  }

  double calcWidth() {
    return ((defaultWidth / scale) / 2);
  }

  double calcHeight() {
    return ((defaultHeight / scale));
  }

  void tapPin(String message) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("この場所は"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: InteractiveViewer(
      constrained: true,
      panEnabled: true,
      scaleEnabled: true,
      minScale: 1,
      maxScale: 2.0,
      onInteractionUpdate: (details) {
        setState(() {
          // データを更新
          scale = _transformationController.value.getMaxScaleOnAxis();
        });
      },
      transformationController: _transformationController,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            "assets/map_2024.png",
            fit: BoxFit.fitWidth,
          ),
          for (PinData pinData in pinDataList)
            // 一定の scale よりも小さくなったら非表示にする
            if (scale > 0.9)
              // Positionedで配置
              Positioned(
                  // 座標を左上にすると、拡大縮小時にピンの位置がズレていくので、ピンの先端がズレないように固定
                  left: pinData.x - calcWidth(),
                  top: pinData.y - calcHeight(),
                  // 画像の拡大率に合わせて、ピン画像のサイズを調整
                  width: defaultWidth / scale,
                  height: defaultHeight / scale,
                  child: GestureDetector(
                    child: Container(
                      alignment: const Alignment(0.0, 0.0),
                      child: Image.asset("assets/map_pin_shadow.png"),
                    ),
                    onTap: () {
                      tapPin(pinData.message);
                    },
                  )),
        ],
      ),
    ));
  }
}
