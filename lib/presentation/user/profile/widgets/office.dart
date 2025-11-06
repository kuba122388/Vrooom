import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class Office {
  final String name;
  final LatLng location;
  final bool isMain;
  final List<Widget> infoSection;

  Office({
    required this.name,
    required this.location,
    required this.isMain,
    required this.infoSection,
  });
}
