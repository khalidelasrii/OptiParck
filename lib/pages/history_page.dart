import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optiparck/bloc/Info_cuibit/info_cubit.dart';
import 'package:optiparck/pages/reservation_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<InfoCubit>(context).historyPositiondataEvent();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InfoCubit, InfoState>(
      builder: (context, state) {
        if (state is InfoDataState) {
          return ListView.builder(
              itemCount: state.marker.length,
              itemBuilder: (context, index) {
                final item = state.marker[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    tileColor: item.reserve ? Colors.redAccent : Colors.green,
                    title: Text(
                      item.titleStation,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      "(${item.latitudePosition},${item.longitudePosition})",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: item.reserve == false
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ReservationPage(
                                          userHistory: item.userHistory??[],
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
