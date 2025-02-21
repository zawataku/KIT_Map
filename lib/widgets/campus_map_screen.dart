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
  double gridWidth = 80; // グリッドの幅
  double gridHeight = 120; // グリッドの高さ

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
    return (x / gridWidth) * imageWidth - calcWidth();
  }

  double calcTop(double y) {
    return (y / gridHeight) * imageHeight - calcHeight();
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
            imageWidth = constraints.maxWidth;
            imageHeight = constraints.maxHeight;
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.asset(
                  "assets/map_2024.png",
                  fit: BoxFit.fitHeight,
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return CustomPaint(
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                      // painter: GridPainter(gridWidth, gridHeight),
                    );
                  },
                ),
                for (PinData pinData in filteredPinDataList.isEmpty
                    ? pinDataList
                    : filteredPinDataList)
                  // 一定の scale よりも小さくなったら小さなピン画像に切り替える
                  Positioned(
                    // 座標を左上にすると、拡大縮小時にピンの位置がズレていくので、ピンの先端がズレないように固定
                    left: calcLeft(pinData.x.toDouble()),
                    top: calcTop(pinData.y.toDouble()),
                    // 画像の拡大率に合わせて、ピン画像のサイズを調整
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

// class GridPainter extends CustomPainter {
//   final double gridWidth;
//   final double gridHeight;

//   GridPainter(this.gridWidth, this.gridHeight);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.red.withOpacity(0.5)
//       ..strokeWidth = 0.5;

//     for (double i = 0; i <= size.width; i += size.width / gridWidth) {
//       canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
//     }

//     for (double i = 0; i <= size.height; i += size.height / gridHeight) {
//       canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
