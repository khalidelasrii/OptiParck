import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:optiparck/pages/home_page.dart';
import 'package:optiparck/widgets/snack_bar_messages.dart';
import 'package:optiparck/widgets/station_marker.dart';

class ReservationPage extends StatelessWidget {
  const ReservationPage({
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
  Widget build(BuildContext context) {
    void erroradd() {
      SnackBarMessage()
          .showErrorSnackBar(message: "Error try again", context: context);
    }

    void succes() {
      SnackBarMessage()
          .showSuccessSnackBar(message: "Succes", context: context);
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const HomePage()));
    }

    User? user = FirebaseAuth.instance.currentUser;
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.add_location_alt,
                    color: Colors.white,
                    size: 100,
                  ),
                ),
              ],
            ),
            Text(
              titleStation,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text("($altitud,$longitude)"),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.greenAccent)),
              onPressed: () async {
                try {
                  var databaseReference = FirebaseFirestore.instance;

                  await databaseReference
                      .collection('Marker')
                      .doc(positionId)
                      .update(StationMarker(
                        userReserve: user!.email!,
                        reserve: false,
                        markerId: positionId,
                        latitudePosition: altitud,
                        longitudePosition: longitude,
                        titleStation: titleStation,
                      ).toMap());

                  await databaseReference
                      .collection('Reservation')
                      .add(StationMarker(
                        userReserve: user.email!,
                        reserve: true,
                        markerId: positionId,
                        latitudePosition: altitud,
                        longitudePosition: longitude,
                        titleStation: titleStation,
                      ).toMapReser());
                  succes();
                } catch (e) {
                  erroradd();
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Reserver",
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HomePage()));
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Annuler",
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
