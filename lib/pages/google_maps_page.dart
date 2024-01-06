import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:optiparck/pages/reservation_page.dart';
import 'package:optiparck/pages/update_position.dart';
import 'package:optiparck/widgets/home_station_status.dart';
import 'package:optiparck/widgets/station_marker.dart';

class GoogleMapsPage extends StatefulWidget {
  const GoogleMapsPage({super.key});

  @override
  State<GoogleMapsPage> createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  GoogleMapController? mapController;
  LatLng? currentLocation;
  double? currentlat;
  double? currentlong;
  LatLng destination = const LatLng(4.66968, 101.07338);
  bool _isLoading = true;
  bool inmap = false;
  late Polyline polyline;
  LatLng? poinDarive;

  void getlinebetwin() {
    polyline = Polyline(
      polylineId: const PolylineId('polyline'),
      color: Colors.blue,
      points: [
        LatLng(currentLocation!.latitude,
            currentLocation!.longitude), // Point d'arrivée
        LatLng(poinDarive!.latitude, poinDarive!.longitude), // Point d'arrivée
      ],
    );
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

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    List<Widget> localisationBox = [
      const HomeStationStatus(
        image: 'a.jpg',
        text: 'Station CMC tamesna',
        subtext: "station de voiture et camion",
      ),
      const HomeStationStatus(
        image: 'b.jpg',
        text: 'Station Temara Centre-Ville',
        subtext: "station de voiture et camion",
      ),
      const HomeStationStatus(
        image: 'c.jpg',
        text: 'Station Tamesna Nor',
        subtext: "station de voiture et camion",
      ),
    ];

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Marker').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Marker> markers = snapshot.data!.docs.map((subdata) {
              return Marker(
                onTap: () {},
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

            return _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      GoogleMap(
                        mapType: MapType.hybrid,
                        onMapCreated: _onMapCreated,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: currentLocation!,
                          zoom: 16.0,
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
                      ),

                      //! la partie de ichhaar
                      inmap == false
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                inmap
                                    ? MaterialButton(
                                        color: Colors.greenAccent,
                                        onPressed: () {
                                          setState(() {
                                            inmap = false;
                                          });
                                        },
                                        child: const Icon(
                                          Icons
                                              .keyboard_double_arrow_up_outlined,
                                          color: Colors.green,
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          setState(() {
                                            inmap = true;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons
                                              .keyboard_double_arrow_down_outlined,
                                          color: Colors.red,
                                        ),
                                      ),
                                inmap
                                    ? const SizedBox()
                                    : SizedBox(
                                        height: 120,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: localisationBox.length,
                                          itemBuilder: (context, index) {
                                            return localisationBox[index];
                                          },
                                        ),
                                      ),
                              ],
                            )
                          : ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  inmap = false;
                                });
                              },
                              child: Icon(Icons.keyboard_double_arrow_up_sharp),
                            ),
                    ],
                  );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
