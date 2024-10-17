import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      constrained: true, // 子 Widget に親のサイズ制約が適用されるか
      panEnabled: true, // pan操作を許容するか
      scaleEnabled: true, // 拡大縮小を許容するか
      boundaryMargin: const EdgeInsets.all(-10), // pan 可能なマージン
      minScale: 1, // 拡大率の最小値
      maxScale: 10.0, // 拡大率の最大値
      child: Stack(
        // 画像を貼り付け
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            "assets/images/map_2024.png",
            fit: BoxFit.fitWidth,
          ),
        ],
      ),
    );
  }
}
