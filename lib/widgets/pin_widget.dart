import 'package:flutter/material.dart';
import 'package:kit_map/widgets/pin_data.dart';

class PinWidget extends StatelessWidget {
  final PinData pinData;

  const PinWidget({required this.pinData, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0.0, 0.0),
      child: Image.asset("assets/map_pin_shadow.png"),
    );
  }
}
