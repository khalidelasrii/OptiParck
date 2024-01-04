import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:optiparck/pages/reservation_page.dart';
import 'package:optiparck/pages/update_position.dart';
import 'package:optiparck/widgets/station_marker.dart';

class GoogleMapsPage extends StatefulWidget {
  const GoogleMapsPage({super.key});

  @override
  State<GoogleMapsPage> createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  final LatLng _marocPosition = const LatLng(33.839112, -6.935222);
  GoogleMapController? mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Marker').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Marker> markers = snapshot.data!.docs.map((subdata) {
              return Marker(
                markerId: MarkerId(subdata.id),
                position: LatLng(
                    double.parse(subdata["latitudePosition"].toString()),
                    double.parse(subdata["longitudePosition"].toString())),
                infoWindow: InfoWindow(
                  title: subdata["titleStation"].toString(),
                  onTap: () {
                    if (user?.email == "khalid@gmail.com") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => UpdatePosition(
                                    positionId: subdata.id,
                                    altitud: double.parse(
                                        subdata["latitudePosition"].toString()),
                                    longitude: double.parse(
                                        subdata["longitudePosition"]
                                            .toString()),
                                    titleStation:
                                        subdata["titleStation"].toString(),
                                  )));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ReservationPage(
                                    positionId: subdata.id,
                                    altitud: double.parse(
                                        subdata["latitudePosition"].toString()),
                                    longitude: double.parse(
                                        subdata["longitudePosition"]
                                            .toString()),
                                    titleStation:
                                        subdata["titleStation"].toString(),
                                  )));
                    }
                  },
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  subdata["reserve"]
                      ? BitmapDescriptor.hueGreen
                      : BitmapDescriptor.hueRed,
                ),
              );
            }).toList();

            return GoogleMap(
              mapType: MapType.hybrid,
              onMapCreated: _onMapCreated,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: _marocPosition,
                zoom: 14.0,
              ),
              markers: markers.toSet(),
              onLongPress: (argument) async {
                if (user?.email == "khalid@gmail.com") {
                  try {
                    await FirebaseFirestore.instance
                        .collection('Marker')
                        .add(StationMarker(
                          userReserve: "Non",
                          reserve: true,
                          markerId: "",
                          latitudePosition: argument.latitude,
                          longitudePosition: argument.longitude,
                          titleStation: "New Station",
                        ).toMap());
                  } catch (e) {
                    print(e);
                  }
                }
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
