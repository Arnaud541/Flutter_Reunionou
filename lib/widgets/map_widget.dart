import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

class MapWidget extends StatefulWidget {
  final LatLng selectedLocation;
  const MapWidget({super.key, required this.selectedLocation});

  @override
  MapWidgetState createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  MapController? mapController;
  LatLng? _selectedLocation;

  void _onLocationSelected(TapPosition location1, LatLng location2) {
    setState(() {
      _selectedLocation = location2;
      print(_selectedLocation);
    });
  }

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _selectedLocation = widget.selectedLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: LatLng(45.5231, -122.6765),
        zoom: 12.0,
        onTap: _onLocationSelected,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: _selectedLocation != null
              ? [
                  Marker(
                    point: _selectedLocation!,
                    builder: (context) => const Icon(Icons.location_on),
                  ),
                ]
              : [],
        ),
      ],
    ));
  }
}
