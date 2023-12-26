import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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

  // @override
  // void dispose() {
  //   super.dispose();
  //   mapController?.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    //     Future<void> getCurrentLocation() async {
    //   try {
    //     LocationData currentLocation = await location.getLocation();
    //     mapController?.animateCamera(CameraUpdate.newLatLng(
    //       LatLng(currentLocation.latitude!, currentLocation.longitude!),
    //     ));
    //     setState(() {});
    //   } catch (e) {
    //     print("Error location: $e");
    //   }
    // }

    User? user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance.ref().child('Marker').onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData) {
            List<Marker> markers = snapshot.data!.snapshot.children.map((e) {
              var id = e.key;
              Map<dynamic, dynamic> data = e.value as Map<dynamic, dynamic>;

              return Marker(
                markerId: MarkerId(id!),
                position: LatLng(
                    double.parse(data["latitudePosition"].toString()),
                    double.parse(data["longitudePosition"].toString())),
                infoWindow: InfoWindow(
                  title: data["titleStation"].toString(),
                  onTap: () {
                    if (user?.email == "khalid@gmail.com") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => UpdatePosition(
                                    positionId: id,
                                    altitud: double.parse(
                                        data["latitudePosition"].toString()),
                                    longitude: double.parse(
                                        data["longitudePosition"].toString()),
                                    titleStation:
                                        data["titleStation"].toString(),
                                  )));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ReservationPage(
                                    userHistory:data["userHistory"] ,
                                    positionId: id,
                                    altitud: double.parse(
                                        data["latitudePosition"].toString()),
                                    longitude: double.parse(
                                        data["longitudePosition"].toString()),
                                    titleStation:
                                        data["titleStation"].toString(),
                                  )));
                    }
                  },
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  data["reserve"]
                      ? BitmapDescriptor.hueGreen
                      : BitmapDescriptor.hueRed,
                ),
              );
            }).toList();

            return GoogleMap(
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
                    DatabaseReference databaseReference =
                        FirebaseDatabase.instance.ref().child('Marker');
                    await databaseReference.push().set(StationMarker(
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

  // Future<double> calculateDistance(double latitude2, double longitude2) async {
  //   // Calcul de la distance
  //   try {
  //     LocationData currentLocation = await location.getLocation();

  // position1 = await Geolocator.getCurrentPosition();

  //     return Geolocator.distanceBetween(
  //       currentLocation.altitude!,
  //       currentLocation.longitude!,
  //       latitude2,
  //       longitude2,
  //     );
  //     // Mettre à jour l'état pour afficher la distance
  //   } catch (e) {
  //     return 0;
  //   }
  // }
}
