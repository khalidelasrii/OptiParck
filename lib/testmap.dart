import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  LatLng? currentLocation;
  double? currentlat;
  double? currentlong;
  LatLng destination = const LatLng(4.66968, 101.07338);
  bool _isLoading = true;
  Set<Marker> markers = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    getLocation();
    makeLines();
    addPolyLine();
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);
    currentlat = lat;
    currentlong = long;

    setState(() {
      currentLocation = location;
      _isLoading = false;
    });
  }

  addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }

  void makeLines() async {
    try {
      await polylinePoints
          .getRouteBetweenCoordinates(
        'AIzaSyBpio5ZRPTfeKVlDNa0xzYGb4XkPxKhCcQ',
        PointLatLng(currentlat ?? 0, currentlong ?? 0),
        PointLatLng(destination.latitude, destination.longitude), //End LATLANG
        travelMode: TravelMode.transit,
      )
          .then((value) {
        for (var point in value.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      }).then((value) {
        addPolyLine();
      });
    } catch (e) {
      print("Erooooooooooooooooooor$e");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    Marker destinationMarker = Marker(
      markerId: const MarkerId('targetLocation'),
      position: destination,
      infoWindow: const InfoWindow(title: 'Destination'),
    );

    Marker currentLocationMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      markerId: const MarkerId('currentLocation'),
      position: LatLng(currentlat ?? 0, currentlong ?? 0),
      infoWindow: const InfoWindow(title: 'Current Location'),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                children: [
                  Expanded(
                    child: GoogleMap(
                      myLocationEnabled: true,
                      onMapCreated: _onMapCreated,
                      markers: <Marker>{
                        destinationMarker,
                        currentLocationMarker
                      },
                      polylines: Set<Polyline>.of(polylines.values),
                      initialCameraPosition: CameraPosition(
                        target: currentLocation!,
                        zoom: 16.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(onPressed: makeLines),
    );
  }
}
