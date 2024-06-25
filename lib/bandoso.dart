import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BanDoSo extends StatefulWidget {
  const BanDoSo({super.key});

  @override
  State<BanDoSo> createState() => _BanDoSoState();
}

class _BanDoSoState extends State<BanDoSo> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(21.026889563994736, 105.84230719437717),
        initialZoom: 10,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        
      ],
    );
  }
}
