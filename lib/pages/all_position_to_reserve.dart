import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optiparck/bloc/Info_cuibit/info_cubit.dart';
import 'package:optiparck/pages/reservation_page.dart';

class AllPositionToReserve extends StatefulWidget {
  const AllPositionToReserve({super.key});

  @override
  State<AllPositionToReserve> createState() => _AllPositionToReserveState();
}

class _AllPositionToReserveState extends State<AllPositionToReserve> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<InfoCubit>(context).getallPositionToReserve();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InfoCubit, InfoState>(
      builder: (context, state) {
        if (state is AllPositionStationState) {
          try {
            return ListView.builder(
                itemCount: state.marker.length,
                itemBuilder: (context, index) {
                  final item = state.marker[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: const Icon(Icons.location_on_outlined),
                      tileColor: item.reserve ? Colors.green : Colors.redAccent,
                      title: Text(
                        item.titleStation,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: item.distancebetwin! < 1000
                          ? Text(
                              "${item.distancebetwin!.toStringAsFixed(2)} m",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : Text(
                              "${(item.distancebetwin! / 1000).toStringAsFixed(2)} Km",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                      trailing: item.reserve
                          ? ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ReservationPage(
                                            altitud: item.latitudePosition,
                                            longitude: item.longitudePosition,
                                            titleStation: item.titleStation,
                                            positionId: item.markerId)));
                              },
                              child: const Icon(
                                Icons.chevron_right,
                                color: Colors.red,
                              ))
                          : const SizedBox(),
                    ),
                  );
                });
          } catch (e) {
            return const Padding(
              padding: EdgeInsets.only(top: 50),
              child: Center(
                child: SizedBox(
                    height: 30, width: 30, child: CircularProgressIndicator()),
              ),
            );
          }
        } else {
          return const Padding(
            padding: EdgeInsets.only(top: 50),
            child: Center(
              child: SizedBox(
                  height: 30, width: 30, child: CircularProgressIndicator()),
            ),
          );
        }
      },
    );
  }
}
