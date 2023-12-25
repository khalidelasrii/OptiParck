import 'package:equatable/equatable.dart';

class StationMarker extends Equatable {
  final String markerId;
  final double latitudePosition;
  final double longitudePosition;
  final String titleStation;
  final bool reserve;
  final String userReserve;
  final double? distancebetwin;

  const StationMarker({
    this.distancebetwin,
    required this.userReserve,
    required this.reserve,
    required this.markerId,
    required this.latitudePosition,
    required this.longitudePosition,
    required this.titleStation,
  });
  Map<String, dynamic> toMap() {
    return {
      "userReserve": userReserve,
      "latitudePosition": latitudePosition,
      "longitudePosition": longitudePosition,
      "titleStation": titleStation,
      "reserve": reserve,
    };
  }

  @override
  List<Object?> get props => [
        markerId,
        latitudePosition,
        longitudePosition,
        titleStation,
        reserve,
        userReserve
      ];
}
