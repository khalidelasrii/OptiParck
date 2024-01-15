import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:optiparck/bloc/Info_cuibit/info_cubit.dart';
import 'package:optiparck/bloc/cubit/auth_cubit.dart';
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
  Color redcolor = const Color(0xFFFE0000);
  Color yaloColor = const Color(0xFFF3D039);
  int currIndex = 0;
  User? user;
  bool serchbar = false;
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  List<Widget> bodybuilder = [
    const GoogleMapsPage(),
    // const Center(
    //   child: CircularProgressIndicator(),
    // ),
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
    // InternetConnectionChecker().onStatusChange.listen((status) {
    //   switch (status) {
    //     case InternetConnectionStatus.disconnected:
    //       SnackBarMessage()
    //           .showErrorSnackBar(message: "No internet", context: context);
    //       break; // Ajout de la clause break
    //     default:
    //     // Gestion des autres états si nécessaire
    //   }
    // });
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is SignOutState) {
          user = FirebaseAuth.instance.currentUser;

          setState(() {
            currIndex = 0;
          });
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFAEC3AE),
          //! appbar
          appBar: serchbar
              ? AppBar(
                  backgroundColor: yaloColor,
                  flexibleSpace: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                    child: SizedBox(
                      height: 50,
                      child: SearchBar(
                        controller: textEditingController,
                        onTap: () {
                          BlocProvider.of<InfoCubit>(context)
                              .searchStationEvent("");
                        },
                        onChanged: (value) {
                          BlocProvider.of<InfoCubit>(context)
                              .searchStationEvent(value);
                        },
                        trailing: <Widget>[
                          IconButton(
                            onPressed: () {
                              setState(() {
                                serchbar = false;
                              });
                              BlocProvider.of<InfoCubit>(context)
                                  .infoInitiale();
                              textEditingController.clear();
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : _buildAppbar(context),

          //! Body
          body: _buildBody(context),

          //! BottomNavigationBar
          bottomNavigationBar: _buildBottomNav(context),
        ),
      ),
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
                      onPressed: () async {
                        setState(() {
                          serchbar = true;
                        });
                      },
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
        child: user != null
            ? Image.asset(
                "images/logo.png",
                height: 30,
              )
            : const Text(
                "OptiParck",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
      ),
      backgroundColor: user != null ? yaloColor : redcolor,
    );
  }
  //! Body fonction

  Widget _buildBody(BuildContext context) {
    return BlocListener<InfoCubit, InfoState>(
      listener: (context, state) {
        if (state is SearcheStationState) {
          setState(() {
            currIndex = 0;
          });
        }
      },
      child: bodybuilder[currIndex],
    );
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
            backgroundColor: user != null ? yaloColor : redcolor,
            icon: const Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: user != null ? yaloColor : redcolor,
            icon: const Icon(Icons.location_on),
            label: 'Station',
          ),
          BottomNavigationBarItem(
            backgroundColor: user != null ? yaloColor : redcolor,
            icon: const Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            backgroundColor: user != null ? yaloColor : redcolor,
            icon: const Icon(Icons.person),
            label: 'Profile',
          ),
        ]);
  }
}
