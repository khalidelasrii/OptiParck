import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:optiparck/pages/home_page.dart';
import 'package:optiparck/widgets/snack_bar_messages.dart';
import 'package:optiparck/widgets/station_marker.dart';

class UpdatePosition extends StatefulWidget {
  const UpdatePosition({
    super.key,
    required this.altitud,
    required this.longitude,
    required this.titleStation,
    required this.positionId,
  });
  final double altitud;
  final double longitude;
  final String titleStation;
  final String positionId;

  @override
  State<UpdatePosition> createState() => _UpdatePositionState();
}

class _UpdatePositionState extends State<UpdatePosition> {
  TextEditingController altitudControlor = TextEditingController();
  TextEditingController longitudeControlor = TextEditingController();
  TextEditingController titleStationControlor = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    altitudControlor.dispose();
    longitudeControlor.dispose();
    titleStationControlor.dispose();
  }

  @override
  void initState() {
    altitudControlor.text = widget.altitud.toString();
    longitudeControlor.text = widget.longitude.toString();
    titleStationControlor.text = widget.titleStation;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
              )),
        ],
        title: MaterialButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const HomePage()));
          },
          child: Image.asset(
            "images/logo.png",
            height: 30,
          ),
        ),
        backgroundColor: Colors.orange[200],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.add_location_alt,
                color: Colors.white,
                size: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                child: TextField(
                  controller: titleStationControlor,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hoverColor: Colors.blue,
                    hintText: 'Titre de Station',
                    hintStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.blue, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.orange, width: 2),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    width: 100,
                    child: TextField(
                      controller: altitudControlor,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hoverColor: Colors.blue,
                        hintText: 'altitud',
                        hintStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.blue, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              BorderSide(color: Colors.orange, width: 2),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    width: 100,
                    child: TextField(
                      controller: longitudeControlor,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hoverColor: Colors.blue,
                        hintText: 'longitude',
                        hintStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.blue, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              BorderSide(color: Colors.orange, width: 2),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.blue)),
              onPressed: () async {
                try {
                  DatabaseReference databaseReference =
                      FirebaseDatabase.instance.ref().child('Marker');
                  await databaseReference.child(widget.positionId).update(
                      StationMarker(
                              userReserve: "Non",
                              reserve: true,
                              markerId: "",
                              latitudePosition: double.parse(
                                  altitudControlor.text.toString()),
                              longitudePosition: double.parse(
                                  longitudeControlor.text.toString()),
                              titleStation:
                                  titleStationControlor.text.toString())
                          .toMap());
                  longitudeControlor.clear();
                  titleStationControlor.clear();
                  altitudControlor.clear();
                  succes();
                } catch (e) {
                  erroradd();
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Update",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateColor.resolveWith((states) => Colors.red)),
                onPressed: () async {
                  try {
                    DatabaseReference databaseReference =
                        FirebaseDatabase.instance.ref().child('Marker');
                    await databaseReference.child(widget.positionId).remove();
                    longitudeControlor.clear();
                    titleStationControlor.clear();
                    altitudControlor.clear();
                    succes();
                  } catch (e) {
                    erroradd();
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Dellet",
                    style: TextStyle(color: Colors.white),
                  ),
                )),
            ElevatedButton(
                onPressed: () async {
                  DatabaseReference databaseReference =
                      FirebaseDatabase.instance.ref().child('Marker');
                  await databaseReference.child(widget.positionId).update(
                      StationMarker(
                              userReserve: "Non",
                              reserve: true,
                              markerId: "",
                              latitudePosition: double.parse(
                                  altitudControlor.text.toString()),
                              longitudePosition: double.parse(
                                  longitudeControlor.text.toString()),
                              titleStation:
                                  titleStationControlor.text.toString())
                          .toMap());
                  succes();
                },
                child: const Text("Dereserver"))
          ],
        ),
      ),
    );
  }

  void erroradd() {
    SnackBarMessage()
        .showErrorSnackBar(message: "Error try again", context: context);
  }

  void succes() {
    SnackBarMessage().showSuccessSnackBar(message: "Succes", context: context);
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const HomePage()));
  }
}
