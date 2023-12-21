import 'package:flutter/material.dart';
import 'package:optiparck/pages/google_maps_page.dart';
import 'package:optiparck/pages/sing_in_page.dart';
import 'package:optiparck/widgets/station_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int currIndex = 0;
  bool inmap = false;
  @override
  Widget build(BuildContext context) {
    List<Widget> localisationBox = [
      const StationBox(
        image: 'a.jpg',
        text: 'Station CMC tamesna',
        subtext: "station de voiture et camion",
      ),
      const StationBox(
        image: 'b.jpg',
        text: 'Station Temara Centre-Ville',
        subtext: "station de voiture et camion",
      ),
      const StationBox(
        image: 'c.jpg',
        text: 'Station Tamesna Nor',
        subtext: "station de voiture et camion",
      ),
    ];
    List<Widget> bodybuilder = [
      const GoogleMapsPage(),
      const Center(
        child: CircularProgressIndicator(
          color: Colors.orange,
        ),
      ),
      const Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      ),
      const Center(
        child: CircularProgressIndicator(
          color: Colors.red,
        ),
      ),
    ];

    return Scaffold(
      //! appbar
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => SignInPage()));
              },
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

      //! Body
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          bodybuilder[currIndex],
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              inmap
                  ? IconButton(
                      hoverColor: Colors.green,
                      onPressed: () {
                        setState(() {
                          inmap = false;
                        });
                      },
                      icon: const Icon(
                        Icons.keyboard_double_arrow_up_outlined,
                        color: Colors.green,
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          inmap = true;
                        });
                      },
                      icon: const Icon(
                        Icons.keyboard_double_arrow_down_outlined,
                        color: Colors.red,
                      ),
                    ),
              inmap
                  ? const SizedBox()
                  : SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: localisationBox.length,
                        itemBuilder: (context, index) {
                          return localisationBox[index];
                        },
                      ),
                    ),
            ],
          ),
        ],
      ),

      //! BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.indigo,
          elevation: 0,
          currentIndex: currIndex,
          onTap: (int newIndex) {
            setState(() {
              currIndex = newIndex;
            });
          },
          items: const [
            BottomNavigationBarItem(
              backgroundColor: Colors.orange,
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: 'Station',
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
    );
  }
}
