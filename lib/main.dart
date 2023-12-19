import 'package:flutter/material.dart';
// import 'package:optiparck/homepage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter GoogleMaps Demo',
//       theme: ThemeData(
//         primaryColor: Colors.indigo,
//       ),
//       home: const HomePage(),
//     );
//   }
// }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController? mapController;
  int currIndex = 0;

  final LatLng _marocPosition = const LatLng(31.7917, -7.0926);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bodybuilder = [
      GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _marocPosition,
          zoom: 6.0,
        ),
      ),
      Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      ),
      Center(
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
