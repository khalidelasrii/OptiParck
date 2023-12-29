part of 'info_cubit.dart';

sealed class InfoState extends Equatable {
  const InfoState();

  @override
  List<Object> get props => [];
}

final class InfoInitial extends InfoState {}

class InfoDataState extends InfoState {
  final List<StationMarker> marker;
  const InfoDataState({required this.marker});

  @override
  List<Object> get props => [marker];
}

class ErrorInfoDataState extends InfoState {}

class ErrorDtatState extends InfoState {}
