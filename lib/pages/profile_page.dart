import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optiparck/bloc/cubit/auth_cubit.dart';
import 'package:optiparck/pages/sing_in_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.user});
  final User? user;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int currIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const Center(
          child: CircularProgressIndicator(
        color: Colors.red,
      )),
      const Center(
          child: CircularProgressIndicator(
        color: Colors.indigo,
      )),
      Center(
          child: ElevatedButton(
              onPressed: () {
                BlocProvider.of<AuthCubit>(context).singOutEvent();
              },
              child: const Text("Diconnexion")))
    ];
    return widget.user != null
        ? Stack(
            children: [
              Column(
                children: [
                  Container(
                    color: Colors.orange[200],
                    width: double.infinity,
                    height: 150,
                  ),
                  Expanded(
                      child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                  ))
                ],
              ),
              Column(
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 75, left: 15, right: 15),
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          height: 200,
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 209, 209, 209),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: BottomNavigationBar(
                              backgroundColor: Colors.white12,
                              selectedItemColor: Colors.green,
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
                                  icon: Icon(Icons.info_outline),
                                  label: 'Info',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.history),
                                  label: 'history',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.settings),
                                  label: 'Settings',
                                ),
                              ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 31),
                        child: ClipOval(
                            child: Container(
                          // color: Colors.white,
                          child: Image.asset(
                            "images/profile.jpg",
                            height: 100,
                            width: 100,
                          ),
                        )),
                      )
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: pages[currIndex],
                  )
                ],
              )
            ],
          )
        : Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SignInPage()));
                },
                child: const Text("Connexion")),
          );
  }
}
