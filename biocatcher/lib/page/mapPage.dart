import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapState();
}

class _MapState extends State<MapPage> {
  late final String _mapStyle;
  late final GoogleMapController mapController;
  static const LatLng _ptCenter = LatLng(39.63870516395606, -7.873238660395145);
  final Map<String, LatLng> places = {
    "Viseu": const LatLng(40.6610100, -7.9097100),
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
    return Scaffold(
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {},
              icon: Icon(
                Icons.catching_pokemon_sharp,
                color: Theme.of(context).colorScheme.inversePrimary,
                size: 35,
              ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {},
              icon: Icon(
                Icons.map,
                color: Theme.of(context).colorScheme.inversePrimary,
                size: 35,
              ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {},
              icon: Icon(
                Icons.casino,
                color: Theme.of(context).colorScheme.inversePrimary,
                size: 35,
              ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {},
              icon: Icon(
                Icons.menu,
                color: Theme.of(context).colorScheme.inversePrimary,
                size: 35,
              ),
            )
          ],
        ),
      ),
      body: GoogleMap(
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
            northeast: _ptCenter,
            southwest: _ptCenter,
          )
        ),
        minMaxZoomPreference: const MinMaxZoomPreference(7.2, 10),
      ),
    );
  }
}