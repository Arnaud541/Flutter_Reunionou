import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MyCheckbox extends StatefulWidget {
  const MyCheckbox({super.key});

  @override
  CheckboxState createState() => CheckboxState();
}

class CheckboxState extends State<MyCheckbox> {
  bool isChecked = false;
  final List _markers = [];

  void _onTapMap(LatLng location) {
  setState(() {
    _markers.clear();

    final marker = Marker(
      point: location,
      builder: (context) => const Icon(Icons.location_pin),
    );

    _markers[marker] = true;
  });
}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Checkbox(
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
              });
            }),
        isChecked ? FlutterMap(
                      options: MapOptions(
                        onTap: _onTapMap,
                        center: LatLng(37.77483, -122.41942),
                        zoom: 12,
                        
                        
                      ),)
        
        
      ],
    );
  }
}
