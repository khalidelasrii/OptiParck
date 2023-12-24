import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:optiparck/widgets/station_marker.dart';

part 'info_state.dart';

class InfoCubit extends Cubit<InfoState> {
  InfoCubit() : super(InfoInitial());

  historydataEvent() {
    emit(InfoDataState(marker: []));
  }
}
