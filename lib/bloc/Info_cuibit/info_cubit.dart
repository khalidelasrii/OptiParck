import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:optiparck/widgets/station_marker.dart';

part 'info_state.dart';

class InfoCubit extends Cubit<InfoState> {
  InfoCubit() : super(InfoInitial());
  Location location = Location();

  final FirebaseFirestore _database = FirebaseFirestore.instance;
  void historyPositiondataEvent() async {
    var dataSnapshot = await _database.collection("Reservation").get();
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
}
