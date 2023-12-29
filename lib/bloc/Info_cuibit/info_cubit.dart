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
    try {
      String userId = _auth.currentUser!.uid;
      DataSnapshot dataSnapshot =
          await _database.ref().child("Reservation").child(userId).get();

      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> data =
            dataSnapshot.value as Map<dynamic, dynamic>;

        List<StationMarker> listitems = data.keys.map((key) {
          var item = data[key];

          return StationMarker(
            userReserve: item["userReserve"],
            reserve: item["reserve"],
            markerId: key,
            latitudePosition: item["latitudePosition"],
            longitudePosition: item["longitudePosition"],
            titleStation: item["titleStation"],
          );
        }).toList();

        emit(InfoDataState(marker: listitems));
      } else {
        emit(ErrorDtatState());
      }
    } catch (e) {
      emit(ErrorDtatState());
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
            // ?? 33.83991025264775
            currentLocation.latitude!,
            // ?? -6.936191841959953
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
        emit(InfoDataState(marker: listitems));
      } else {
        emit(ErrorDtatState());
      }
    } catch (e) {
      emit(ErrorDtatState());
    }
  }
}
