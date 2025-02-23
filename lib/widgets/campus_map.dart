import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CampusMap extends StatelessWidget {
  final MapController mapController;
  const CampusMap({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
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
          flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
        ),
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
    );
  }
}
