import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:optiparck/widgets/station_marker.dart';

part 'info_state.dart';

class InfoCubit extends Cubit<InfoState> {
  InfoCubit() : super(InfoInitial());

  void infoInitiale() {
    emit(InfoInitial());
  }

  Location location = Location();
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  void historyPositiondataEvent() async {
    final auth = FirebaseAuth.instance;

    var dataSnapshot = await _database
        .collection("Reservation")
        .doc(auth.currentUser?.uid)
        .collection("Station")
        .get();
    try {
      var items = dataSnapshot.docs.map(
        (subData) {
          return StationMarker(
            dateReservation: subData["dateReservation"],
            userReserve: subData["userReserve"],
            reserve: subData["reserve"],
            markerId: subData.id,
            latitudePosition: subData["latitudePosition"],
            longitudePosition: subData["longitudePosition"],
            titleStation: subData["titleStation"],
          );
        },
      ).toList();
      emit(HestoryStationState(marker: items));
    } catch (e) {
      print(e);
      emit(ErrorDtatState());
    }
  }

  void getallPositionToReserve() async {
    var dataSnapshot = await _database.collection('Marker').get();

    LocationData currentLocation = await location.getLocation();

    try {
      List<StationMarker> listitems = dataSnapshot.docs.map((subdata) {
        double distance = Geolocator.distanceBetween(
          currentLocation.latitude!,
          currentLocation.longitude!,
          subdata["latitudePosition"],
          subdata["longitudePosition"],
        );
        return StationMarker(
          distancebetwin: distance,
          userReserve: subdata["userReserve"],
          reserve: subdata["reserve"],
          markerId: subdata.id,
          latitudePosition: subdata["latitudePosition"],
          longitudePosition: subdata["longitudePosition"],
          titleStation: subdata["titleStation"],
        );
      }).toList();

      listitems.sort(
          (a, b) => a.distancebetwin!.compareTo(b.distancebetwin as double));
      emit(AllPositionStationState(marker: listitems));
    } catch (e) {
      emit(ErrorDtatState());
    }
  }

  void searchStationEvent(String search) async {
    try {
      var dataSnapshot =
          await FirebaseFirestore.instance.collection('Marker').get();

      List<StationMarker> listitems = dataSnapshot.docs
          .where((subdata) => subdata["titleStation"]
              .toString()
              .toLowerCase() // Convertir en minuscules
              .contains(
                  search.toLowerCase())) // Convertir la recherche en minuscules
          .map((subdata) {
        return StationMarker(
          userReserve: subdata["userReserve"],
          reserve: subdata["reserve"],
          markerId: subdata.id,
          latitudePosition: subdata["latitudePosition"],
          longitudePosition: subdata["longitudePosition"],
          titleStation: subdata["titleStation"],
        );
      }).toList();

      emit(SearcheStationState(marker: listitems));
    } catch (e) {
      print("Erreur lors de la recherche de stations : $e");
      emit(ErrorDtatState());
    }
  }

  void getDriveePosition(String markerId) async {
    var dataSnapshot = await _database.collection('Marker').doc(markerId).get();
    LocationData currentLocation = await location.getLocation();

    double distance = Geolocator.distanceBetween(
      currentLocation.latitude!,
      currentLocation.longitude!,
      dataSnapshot["latitudePosition"],
      dataSnapshot["longitudePosition"],
    );
    emit(OnePositionStationState(
        marker: StationMarker(
            distancebetwin: distance,
            userReserve: dataSnapshot["userReserve"],
            reserve: dataSnapshot["reserve"],
            markerId: markerId,
            latitudePosition: dataSnapshot["latitudePosition"],
            longitudePosition: dataSnapshot["longitudePosition"],
            titleStation: dataSnapshot["titleStation"])));
  }

  void updatePositionCameraEvent(LatLng newPosition) {
    emit(UpdateCameraPositionState(newPosition: newPosition));
  }
}
