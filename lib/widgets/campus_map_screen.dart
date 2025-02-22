import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:kit_map/widgets/pin_data.dart';
import 'package:kit_map/widgets/pin_widget.dart';

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});

  @override
  State<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  final _transformationController = TransformationController();
  double scale = 1.0;
  double defaultWidth = 50.0;
  double defaultHeight = 50.0;
  double defFontSize = 20.0;
  double imageWidth = 0;
  double imageHeight = 0;
  final double mapPixelWidth = 1024; // 画像の横幅 (ピクセル)
  final double mapPixelHeight = 768; // 画像の縦幅 (ピクセル)

  List<PinData> pinDataList = [];
  TextEditingController searchController = TextEditingController();
  List<PinData> filteredPinDataList = [];

  @override
  void initState() {
    super.initState();
    loadPinData();
    searchController.addListener(_filterPins);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadPinData() async {
    final String response = await rootBundle.loadString('assets/pin_data.json');
    final data = await json.decode(response) as List;
    setState(() {
      pinDataList = data.map((json) => PinData.fromJson(json)).toList();
    });
  }

  void _filterPins() {
    setState(() {
      filteredPinDataList = pinDataList
          .where((pin) => pin.message.contains(searchController.text))
          .toList();
    });
  }

  double calcWidth() {
    return ((defaultWidth / scale) / 2);
  }

  double calcHeight() {
    return ((defaultHeight / scale));
  }

  double calcLeft(double x) {
    // 画像の横幅を基準にスケーリングして配置
    final double scaledX = (x / mapPixelWidth) * imageWidth;
    return scaledX - (defaultWidth / scale) / 2;
  }

  double calcTop(double y) {
    // 画像の縦幅を基準にスケーリングして配置
    // imageHeight は実際の画面上の表示高さ (BoxFit.fitWidth 時はアスペクト比に依存)
    final double scaledY = (y / mapPixelHeight) * imageHeight;
    return scaledY - (defaultHeight / scale);
  }

  void tapPin(String message) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      )),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.4,
          maxChildSize: 0.9,
          minChildSize: 0.32,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "ここには詳細情報が入ります。",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80,
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'キャンパス内の建物を検索',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
        ),
      ),
      body: InteractiveViewer(
        constrained: true,
        panEnabled: true,
        scaleEnabled: true,
        minScale: 1.0,
        maxScale: 2.0,
        onInteractionUpdate: (details) {
          setState(() {
            // データを更新
            scale = _transformationController.value.getMaxScaleOnAxis();
          });
        },
        transformationController: _transformationController,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // 縦幅いっぱいに表示
            imageHeight = constraints.maxHeight;
            imageWidth = imageHeight * (mapPixelWidth / mapPixelHeight);

            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.asset(
                  "assets/map_2024.png",
                  fit: BoxFit.fitHeight,
                ),
                for (PinData pinData in filteredPinDataList.isEmpty
                    ? pinDataList
                    : filteredPinDataList)
                  Positioned(
                    left: calcLeft(pinData.x.toDouble()),
                    top: calcTop(pinData.y.toDouble()),
                    width: defaultWidth / scale,
                    height: defaultHeight / scale,
                    child: GestureDetector(
                      child: scale > 1.4
                          ? PinWidget(pinData: pinData)
                          : Image.asset(
                              "assets/map_pin_small.png",
                              width: 10.0,
                              height: 10.0,
                            ),
                      onTap: () {
                        tapPin(pinData.message);
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
