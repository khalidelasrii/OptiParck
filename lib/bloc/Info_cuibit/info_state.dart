part of 'info_cubit.dart';

sealed class InfoState extends Equatable {
  const InfoState();

  @override
  List<Object> get props => [];
}

final class InfoInitial extends InfoState {}

class AllPositionStationState extends InfoState {
  final List<StationMarker> marker;
  const AllPositionStationState({required this.marker});

  @override
  List<Object> get props => [marker];
}

class OnePositionStationState extends InfoState {
  final StationMarker marker;
  const OnePositionStationState({required this.marker});

  @override
  List<Object> get props => [marker];
}

class GetOnePositionStationState extends InfoState {}

class HestoryStationState extends InfoState {
  final List<StationMarker> marker;
  const HestoryStationState({required this.marker});

  @override
  List<Object> get props => [marker];
}

class ErrorDtatState extends InfoState {}

class SearcheStationState extends InfoState {
  final List<StationMarker> marker;
  const SearcheStationState({required this.marker});

  @override
  List<Object> get props => [marker];
}
