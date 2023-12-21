import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsPage extends StatefulWidget {
  const GoogleMapsPage({super.key});

  @override
  State<GoogleMapsPage> createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  GoogleMapController? mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final LatLng _marocPosition = const LatLng(33.839112, -6.935222);

  @override
  Widget build(BuildContext context) {
    // Les marker  colorié dans le maps ou les position de stationnement
    Marker tamesna = Marker(
      markerId: const MarkerId('Station 1'),
      position: const LatLng(33.839112, -6.935222),
      infoWindow: const InfoWindow(title: 'Station'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    );
    Marker temara = Marker(
      markerId: const MarkerId('Station 2'),
      position: const LatLng(33.910959, -6.902740),
      infoWindow: const InfoWindow(title: 'Station'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    );
    Marker rabatStation = Marker(
      markerId: const MarkerId('Station 3'),
      position: const LatLng(33.841594, -6.934475),
      infoWindow: const InfoWindow(title: 'Station'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueGreen,
      ),
    );
    Marker tamesnaNonr = Marker(
      markerId: const MarkerId('Station 3'),
      position: const LatLng(33.823249, -6.923111),
      infoWindow: const InfoWindow(title: 'Station'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueGreen,
      ),
    );
    Marker tamesnaNonr1 = Marker(
      markerId: const MarkerId('Station 3'),
      position: const LatLng(33.820790, -6.937618),
      infoWindow: const InfoWindow(title: 'Station'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    );

    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _marocPosition,
        zoom: 14.0,
      ),
      markers: {tamesnaNonr1, tamesnaNonr, temara, tamesna, rabatStation},
    );
  }
}