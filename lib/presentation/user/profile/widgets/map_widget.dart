import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrooom/core/common/widgets/info_section_card.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/core/configs/theme/app_text_styles.dart';
import 'package:vrooom/presentation/user/profile/widgets/contact_row.dart';
import 'package:vrooom/presentation/user/profile/widgets/office.dart';
import '../../../../core/configs/assets/app_vectors.dart';
import '../../../../core/configs/theme/app_spacing.dart';

class MapWidget extends StatefulWidget {
  final void Function(VoidCallback centerToOffice)? onMapReady;

  const MapWidget({
    super.key,
    this.onMapReady,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  MapController mapController = MapController();
  Location location = Location();

  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;

  static const LatLng mainOffice = LatLng(51.7592, 19.4560);

  final List<Office> offices = [
    Office(
      name: 'Main office',
      location: const LatLng(51.7592, 19.4560),
      isMain: true,
      infoSection: [
        const ContactRow(svgAsset: AppVectors.mapPin, label: "ul. Piotrkowska 1, Łódź"),
        const ContactRow(svgAsset: AppVectors.phone, label: "+48 123 456 789"),
        const ContactRow(svgAsset: AppVectors.mail, label: "carrentlodz@gmail.com"),
        const ContactRow(svgAsset: AppVectors.clock, label: "Pon–Pt, 8:00–18:00"),
      ],
    ),
    Office(
      name: 'Warsaw office',
      location: const LatLng(52.2297, 21.0122),
      isMain: false,
      infoSection: [
        const ContactRow(svgAsset: AppVectors.mapPin, label: "al. Jerozolimskie 100, Warszawa"),
        const ContactRow(svgAsset: AppVectors.phone, label: "+48 092 123 765"),
        const ContactRow(svgAsset: AppVectors.mail, label: "carrentwar@gmail.com"),
        const ContactRow(svgAsset: AppVectors.clock, label: "Pon–Pt, 9:00–17:00"),
      ],
    ),
    Office(
      name: 'Krakow ofice',
      location: const LatLng(50.0647, 19.9450),
      isMain: false,
      infoSection: [
        const ContactRow(svgAsset: AppVectors.mapPin, label: "ul. Grodzka 20, Kraków"),
        const ContactRow(svgAsset: AppVectors.phone, label: "+48 172 198 871"),
        const ContactRow(svgAsset: AppVectors.mail, label: "carrentkrk@gmail.com"),
        const ContactRow(svgAsset: AppVectors.clock, label: "Pon–Pt, 9:00–17:00"),
      ],
    ),
    Office(
      name: 'Gdansk office',
      location: const LatLng(54.3520, 18.6466),
      isMain: false,
      infoSection: [
        const ContactRow(svgAsset: AppVectors.mapPin, label: "ul. Długa 10, Gdańsk"),
        const ContactRow(svgAsset: AppVectors.phone, label: "+48 111 422 122"),
        const ContactRow(svgAsset: AppVectors.mail, label: "carrentgd@gmail.com"),
        const ContactRow(svgAsset: AppVectors.clock, label: "Pon–Pt, 9:00–17:00"),
      ],
    ),
  ];

  void centerToOffice() {
    mapController.move(mainOffice, 14.0);
    mapController.rotate(0.0);
  }

  initLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initLocation();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onMapReady?.call(centerToOffice);
    });
  }

  void _showOfficeInfo(Office office) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.background,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InfoSectionCard(
              title: office.name,
              child: Column(
                children: office.infoSection
                    .expand(
                      (widget) => [
                    widget,
                    const SizedBox(height: AppSpacing.xs),
                  ],
                ).toList(),
              ),
            ),
          ],
        ),
        actions: [
          PrimaryButton(
            text: 'Open in maps',
            onPressed: () {
              Navigator.pop(context);
              _openInGoogleMaps(office.location, office.name);
            },
          ),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Close',
                style: AppTextStyles.smallButton
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openInGoogleMaps(LatLng location, String name) async {
    final Uri googleMapsAppUrl = Uri.parse(
        'geo:${location.latitude},${location.longitude}?q=${location.latitude},${location.longitude}(${Uri.encodeComponent(name)})');

    final Uri googleMapsWebUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}');

    try {
      final bool launched = await launchUrl(
        googleMapsAppUrl,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        await launchUrl(
          googleMapsWebUrl,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nie udało się otworzyć Map Google')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: const MapOptions(
            initialZoom: 14,
            initialCenter: mainOffice,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.mycompany.vrooom',
            ),
            MarkerLayer(
              markers: offices.map((office) {
                final LatLng loc = office.location;
                final bool isMain = office.isMain;

                return Marker(
                  point: loc,
                  width: 50,
                  height: 50,
                  child: GestureDetector(
                    onTap: () => _showOfficeInfo(office),
                    child: Icon(
                      Icons.location_pin,
                      color: isMain ? Colors.red : Colors.blueAccent,
                      size: isMain ? 45 : 35,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}