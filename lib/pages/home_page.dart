import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:optiparck/bloc/cubit/auth_cubit.dart';
import 'package:optiparck/pages/all_position_to_reserve.dart';
import 'package:optiparck/pages/google_maps_page.dart';
import 'package:optiparck/pages/history_page.dart';
import 'package:optiparck/pages/profile_page.dart';
import 'package:optiparck/pages/sing_in_page.dart';
import 'package:optiparck/widgets/snack_bar_messages.dart';
import 'package:optiparck/widgets/home_station_status.dart';

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
    User? user = FirebaseAuth.instance.currentUser;
    InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          BlocProvider.of<AuthCubit>(context).internetConnectEvent();

          break;
        case InternetConnectionStatus.disconnected:
          BlocProvider.of<AuthCubit>(context).internetDeconnectEvent();
      }
    });
    List<Widget> localisationBox = [
      const HomeStationStatus(
        image: 'a.jpg',
        text: 'Station CMC tamesna',
        subtext: "station de voiture et camion",
      ),
      const HomeStationStatus(
        image: 'b.jpg',
        text: 'Station Temara Centre-Ville',
        subtext: "station de voiture et camion",
      ),
      const HomeStationStatus(
        image: 'c.jpg',
        text: 'Station Tamesna Nor',
        subtext: "station de voiture et camion",
      ),
    ];
    List<Widget> bodybuilder = [
      const GoogleMapsPage(),
      const AllPositionToReserve(),
      const HistoryPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFAEC3AE),
      //! appbar
      appBar: AppBar(
        actions: [
          user == null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SignInPage()));
                      },
                      child: const Text("Connexion")),
                )
              : Row(
                  children: [
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
                ),
        ],
        title: MaterialButton(
          onPressed: () {
            setState(() {
              currIndex = 0;
            });
          },
          child: Image.asset(
            "images/logo.png",
            height: 30,
          ),
        ),
        backgroundColor:
            user != null ? const Color(0xFFF3D039) : Colors.red[200],
      ),

      //! Body
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is InternetDesconnectState) {
            SnackBarMessage().showErrorSnackBar(
                message: "Chick Your Internet", context: context);
          } else if (state is SignOutState) {
            setState(() {
              currIndex = 0;
            });
          }
        },
        builder: (context, state) {
          return Stack(
            alignment: Alignment.bottomLeft,
            children: [
              bodybuilder[currIndex],
              currIndex == 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        inmap
                            ? MaterialButton(
                                color: Colors.greenAccent,
                                onPressed: () {
                                  setState(() {
                                    inmap = false;
                                  });
                                },
                                child: const Icon(
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
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: localisationBox.length,
                                  itemBuilder: (context, index) {
                                    return localisationBox[index];
                                  },
                                ),
                              ),
                      ],
                    )
                  : const SizedBox(),
            ],
          );
        },
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
          items: [
            BottomNavigationBarItem(
              backgroundColor:
                  user != null ? const Color(0xFFF3D039) : Colors.red[200],
              icon: const Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor:
                  user != null ? const Color(0xFFF3D039) : Colors.red[200],
              icon: const Icon(Icons.location_on),
              label: 'Station',
            ),
            BottomNavigationBarItem(
              backgroundColor:
                  user != null ? const Color(0xFFF3D039) : Colors.red[200],
              icon: const Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              backgroundColor:
                  user != null ? const Color(0xFFF3D039) : Colors.red[200],
              icon: const Icon(Icons.person),
              label: 'Profile',
            ),
          ]),
    );
  }
}
