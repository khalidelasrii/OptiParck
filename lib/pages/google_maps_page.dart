import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:optiparck/bloc/Info_cuibit/info_cubit.dart';
import 'package:optiparck/pages/auth_pages/update_position.dart';
import 'package:optiparck/pages/reservation_page.dart';
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
    BlocProvider.of<InfoCubit>(context).getallPositionToReserve();
    getLocation();
  }

  GoogleMapController? mapController;
  LatLng? currentLocation;
  double? currentlat;
  double? currentlong;
  LatLng destination = const LatLng(4.66968, 101.07338);
  bool inmap = false;
  LatLng? poinDarivee;
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
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('Marker').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Marker> markers = snapshot.data!.docs.map((subdata) {
              return Marker(
                onTap: () {
                  BlocProvider.of<InfoCubit>(context)
                      .getDriveePosition(subdata.id);

                  setState(() {
                    getLocation();
                    inmap = true;
                  });
                },
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

            return Stack(
              alignment: Alignment.bottomLeft,
              children: [
                GoogleMap(
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId('polyline'),
                      color: Colors.blue,
                      points: [
                        LatLng(currentLocation?.latitude ?? 0,
                            currentLocation?.longitude ?? 0), // Point d'arrivée
                        LatLng(
                            poinDarivee?.latitude ??
                                currentLocation?.latitude ??
                                0,
                            poinDarivee?.longitude ??
                                currentLocation?.longitude ??
                                0), // Point d'arrivée
                      ],
                    )
                  },
                  mapType: MapType.hybrid,
                  onMapCreated: _onMapCreated,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target:
                        currentLocation ?? const LatLng(33.827589, -6.926178),
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
                BlocBuilder<InfoCubit, InfoState>(
                  builder: ((context, state) {
                    if (state is AllPositionStationState) {
                      return inmap == false
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
                                          itemCount: state.marker.length,
                                          itemBuilder: (context, index) {
                                            final item = state.marker[index];
                                            final String distance = item
                                                        .distancebetwin! <
                                                    1000
                                                ? "${item.distancebetwin!.toStringAsFixed(2)} m"
                                                : "${(item.distancebetwin! / 1000).toStringAsFixed(2)} km";
                                            return MaterialButton(
                                              onPressed: () {
                                                mapController?.moveCamera(
                                                  CameraUpdate.newLatLng(LatLng(
                                                      item.latitudePosition,
                                                      item.longitudePosition)), // Coordonnées du point de départ
                                                );
                                              },
                                              child: HomeStationStatus(
                                                image: 'a.jpg',
                                                text: item.titleStation,
                                                subtext: distance,
                                              ),
                                            );
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
                              child: const Icon(
                                  Icons.keyboard_double_arrow_up_sharp),
                            );
                    } else if (state is OnePositionStationState) {
                      final String item = state.marker.distancebetwin! < 1000
                          ? "${state.marker.distancebetwin!.toStringAsFixed(2)} m"
                          : "${(state.marker.distancebetwin! / 1000).toStringAsFixed(2)} km";
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<InfoCubit>(context)
                                      .infoInitiale();
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    LatLng alitude = LatLng(
                                        state.marker.latitudePosition,
                                        state.marker.longitudePosition);
                                    setState(() {
                                      poinDarivee = alitude;
                                    });
                                    BlocProvider.of<InfoCubit>(context)
                                        .infoInitiale();
                                  },
                                  child:
                                      const Icon(Icons.turn_sharp_left_sharp))
                            ],
                          ),
                          SizedBox(
                            height: 120,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, bottom: 8),
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        border: Border.all(
                                            color: Colors.blue, width: 3),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15))),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                      child: Opacity(
                                        opacity: 0.6,
                                        child: Image.asset(
                                          "images/station/a.jpg",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  state.marker.titleStation,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  item,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                              ],
                                            )),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<InfoCubit>(context)
                              .getallPositionToReserve();
                          setState(() {
                            inmap = false;
                          });
                        },
                        child: const Icon(Icons.keyboard_double_arrow_up_sharp),
                      );
                    }
                  }),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
