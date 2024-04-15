import 'package:bio_catcher/elements/map_tile_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../logic/eventHandler.dart';

class MapSection extends StatefulWidget {
  const MapSection({super.key});

  @override
  State<MapSection> createState() => MapState();
}

class MapState extends State<MapSection> {
  late final String _mapStyle;
  late final GoogleMapController mapController;
  static const LatLng _ptCenter = LatLng(39.63870516395606, -7.873238660395145);
  final Set<MapIndicator> places = {
    MapIndicator(
        text: "Viseu",
        offset: const Offset(55, 55),
        x: 61,
        y: 48,
        fontSize: 20,
        color: Colors.black,
        zoom: 7
    )
  };

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    EventHandler.mainPageAppBar.add(true);
    return GoogleMap(
        onMapCreated: (GoogleMapController controller)
        {
          mapController = controller;
          mapController.setMapStyle(_mapStyle);
        },
        initialCameraPosition: const CameraPosition(
          target: _ptCenter,
          zoom: 7.2,
        ),
        rotateGesturesEnabled: false,
        cameraTargetBounds: CameraTargetBounds(
            LatLngBounds(
              northeast: const LatLng(41.97193822954311, -5.443835975660432),
              southwest: const LatLng(36.532664187078055, -10.181156426221802),
            )
        ),
        minMaxZoomPreference: const MinMaxZoomPreference(7.2, 10),
        zoomControlsEnabled: false,
        tileOverlays: {
          TileOverlay(
            tileOverlayId: const TileOverlayId("ProgressLabels"),
            tileProvider: MapTileProvider(mapPlaces: places),
          )
        }
      );
  }
}