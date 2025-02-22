import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'material_floating_search_bar.dart';

class CampusMapPage extends StatelessWidget {
  const CampusMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(36.530408, 136.627638),
              initialZoom: 17,
              minZoom: 17.0,
              maxZoom: 20.0,
              cameraConstraint: CameraConstraint.contain(
                bounds: LatLngBounds(
                  const LatLng(36.533430, 136.633422),
                  const LatLng(36.526298, 136.624726),
                ),
              ),
              interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag),
            ),
            children: [
              TileLayer(
                tileProvider: AssetTileProvider(),
                maxZoom: 20,
                urlTemplate: "assets/tiles/{z}/{x}/{y}.png",
                tileSize: 256,
                minNativeZoom: 17,
                maxNativeZoom: 20,
              ),
            ],
          ),
          const FloatingSearchAppBar(),
        ],
      ),
    );
  }
}
