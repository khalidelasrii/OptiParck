import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  GoogleMapController? mapController;
  int currIndex = 0;

  final LatLng _marocPosition = const LatLng(33.839112, -6.935222);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    Marker tamesna = Marker(
      markerId: const MarkerId('Station 1'),
      position: const LatLng(33.839112, -6.935222),
      infoWindow: const InfoWindow(title: 'Station'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    );
    Marker temara = Marker(
      markerId: const MarkerId('Station 2'),
      position: const LatLng(33.910959, -6.902740),
      infoWindow: const InfoWindow(title: 'Station'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    );
    Marker rabatStation = Marker(
      markerId: const MarkerId('Station 3'),
      position: const LatLng(33.841594, -6.934475),
      infoWindow: const InfoWindow(title: 'Station'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueGreen,
      ),
    );
    Marker tamesnaNonr = Marker(
      markerId: const MarkerId('Station 3'),
      position: const LatLng(33.823249, -6.923111),
      infoWindow: const InfoWindow(title: 'Station'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueGreen,
      ),
    );
    Marker tamesnaNonr1 = Marker(
      markerId: const MarkerId('Station 3'),
      position: const LatLng(33.820790, -6.937618),
      infoWindow: const InfoWindow(title: 'Station'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    );

    List<Widget> bodybuilder = [
      GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _marocPosition,
          zoom: 14.0,
        ),
        markers: {tamesnaNonr1, tamesnaNonr, temara, tamesna, rabatStation},
      ),
      const Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      ),
      const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      ),
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {},
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
          title: const Text(
            'OptiParck',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.orangeAccent,
        ),
        body: bodybuilder[currIndex],
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.orangeAccent,
            selectedItemColor: Colors.indigo,
            unselectedItemColor: Colors.white,
            elevation: 0,
            currentIndex: currIndex,
            onTap: (int newIndex) {
              setState(() {
                currIndex = newIndex;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ]),
      ),
    );
  }
}
