import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:optiparck/pages/all_position_to_reserve.dart';
import 'package:optiparck/pages/auth_pages/sing_in_page.dart';
import 'package:optiparck/pages/google_maps_page.dart';
import 'package:optiparck/pages/history_page.dart';
import 'package:optiparck/pages/profile_page.dart';
import 'package:optiparck/widgets/snack_bar_messages.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({Key? key}) : super(key: key);

  @override
  MainHomePageState createState() => MainHomePageState();
}

class MainHomePageState extends State<MainHomePage> {
  int currIndex = 0;
  User? user;
  List<Widget> bodybuilder = [
    const GoogleMapsPage(),
    const AllPositionToReserve(),
    const HistoryPage(),
    const ProfilePage(),
  ];
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    InternetConnectionChecker().onStatusChange.listen((status) {
      while (status == InternetConnectionStatus.disconnected) {
        SnackBarMessage().showErrorSnackBar(
            message: "Chick your connection", context: context);
        break;
      }
    });
    return Scaffold(
      backgroundColor: const Color(0xFFAEC3AE),
      //! appbar
      appBar: _buildAppbar(context),

      //! Body
      body: _buildBody(context),

      //! BottomNavigationBar
      bottomNavigationBar: _buildBottomNav(context),
    );
  }
  //! appbar fonction

  AppBar _buildAppbar(BuildContext context) {
    return AppBar(
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
      backgroundColor: user != null ? const Color(0xFFF3D039) : Colors.red[200],
    );
  }
  //! Body fonction

  Widget _buildBody(BuildContext context) {
    return bodybuilder[currIndex];
  }
  //! BottomNavigationBar fonction

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
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
        ]);
  }
}
