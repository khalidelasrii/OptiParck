import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optiparck/bloc/cubit/auth_cubit.dart';
import 'package:optiparck/pages/sing_in_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  int currIndex = 0;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    BlocProvider.of<AuthCubit>(context).getUserEvent();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Center(child: const CircularProgressIndicator()),
      // const History(),
      const InfoPage(),
      const SettingsPage(),
    ];
    return user != null
        ? BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is IsSignInState) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: const Color(0xFF3B9874),
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
                              padding: const EdgeInsets.only(
                                  top: 75, left: 15, right: 15),
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                height: 200,
                                decoration: const BoxDecoration(
                                    color: Color(0xFFF3D039),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: BottomNavigationBar(
                                    backgroundColor: Colors.white12,
                                    selectedItemColor: const Color(0xFF4CAF50),
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
                                        icon: Icon(Icons.history),
                                        label: 'history',
                                      ),
                                      BottomNavigationBarItem(
                                        icon: Icon(Icons.info_outline),
                                        label: 'Info',
                                      ),
                                      BottomNavigationBarItem(
                                        icon: Icon(Icons.settings),
                                        label: 'Settings',
                                      ),
                                    ]),
                              ),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 31),
                                  child: ClipOval(
                                      child: SizedBox(
                                    // color: Colors.white,
                                    child: Image.asset(
                                      "images/profile.jpg",
                                      height: 100,
                                      width: 100,
                                    ),
                                  )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${state.user.userName} ${state.user.userPrenom}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
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
                );
              } else {
                return Stack(
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
                              padding: const EdgeInsets.only(
                                  top: 75, left: 15, right: 15),
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
                                  child: SizedBox(
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
                          height: 100,
                          width: 100,
                          child: pages[currIndex],
                        )
                      ],
                    )
                  ],
                );
              }
            },
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

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
            onPressed: () {
              BlocProvider.of<AuthCubit>(context).singOutEvent();
            },
            child: const Text("Diconnexion")));
  }
}

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
