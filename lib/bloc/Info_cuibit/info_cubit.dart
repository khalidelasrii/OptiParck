import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:optiparck/widgets/station_marker.dart';

part 'info_state.dart';

class InfoCubit extends Cubit<InfoState> {
  InfoCubit() : super(InfoInitial());
  final _auth = FirebaseAuth.instance;
  Location location = Location();

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  void historyPositiondataEvent() async {
    DataSnapshot dataSnapshot = await _database
        .ref()
        .child("Reservation")
        .child(_auth.currentUser!.uid)
        .get();
    try {
      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> data =
            dataSnapshot.value as Map<dynamic, dynamic>;
        var items = data.keys.map((key) {
          var subData = data[key];
          print(subData);

          return StationMarker(
            dateReservation: subData["dateReservation"],
            userReserve: subData["userReserve"],
            reserve: subData["reserve"],
            markerId: key,
            latitudePosition: subData["latitudePosition"],
            longitudePosition: subData["longitudePosition"],
            titleStation: subData["titleStation"],
          );
        }).toList();
        emit(HestoryStationState(marker: items));
      } else {
        print("item...........................................");

        emit(ErrorDtatState());
      }
    } catch (e) {
      print("Cached...........................................");
      emit(ErrorDtatState());
      print(e);
    }
  }

  void getallPositionToReserve() async {
    DataSnapshot dataSnapshot = await _database.ref().child("Marker").get();
    LocationData currentLocation = await location.getLocation();

    try {
      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> data =
            dataSnapshot.value as Map<dynamic, dynamic>;

        List<StationMarker> listitems = data.keys.map((key) {
          var item = data[key];
          double distance = Geolocator.distanceBetween(
            currentLocation.latitude!,
            currentLocation.longitude!,
            item["latitudePosition"],
            item["longitudePosition"],
          );
          return StationMarker(
            distancebetwin: distance,
            userReserve: item["userReserve"],
            reserve: item["reserve"],
            markerId: key,
            latitudePosition: item["latitudePosition"],
            longitudePosition: item["longitudePosition"],
            titleStation: item["titleStation"],
          );
        }).toList();
        listitems.sort(
            (a, b) => a.distancebetwin!.compareTo(b.distancebetwin as double));
        emit(AllPositionStationState(marker: listitems));
      } else {
        emit(ErrorDtatState());
      }
    } catch (e) {
      emit(ErrorDtatState());
    }
  }
}
