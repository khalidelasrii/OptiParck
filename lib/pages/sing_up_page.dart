import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optiparck/bloc/cubit/auth_cubit.dart';
import 'package:optiparck/pages/home_page.dart';
import 'package:optiparck/widgets/Client.dart';
import 'package:optiparck/widgets/snack_bar_messages.dart';

class SingUpPage extends StatefulWidget {
  const SingUpPage({super.key});

  @override
  State<SingUpPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: _buildAppBar(context),
      body: const BuildBodySingUp(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueGrey,
      leading: IconButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
        },
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}

class BuildBodySingUp extends StatefulWidget {
  const BuildBodySingUp({super.key});

  @override
  State<BuildBodySingUp> createState() => _BuildBodySingUpState();
}

class _BuildBodySingUpState extends State<BuildBodySingUp> {
  TextEditingController emailControllor = TextEditingController();
  TextEditingController nameControllor = TextEditingController();
  TextEditingController prenomeControllor = TextEditingController();
  TextEditingController phoneControllor = TextEditingController();
  TextEditingController passwordControllor = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    super.dispose();
    nameControllor.dispose();
    prenomeControllor.dispose();
    phoneControllor.dispose();
    emailControllor.dispose();
    passwordControllor.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ErrorSignInState) {
          // Traitement en cas d'erreur de connexion
          SnackBarMessage()
              .showErrorSnackBar(message: "Error to connect", context: context);
        } else if (state is IsSignUpState) {
          // Traitement après une connexion réussie
          SnackBarMessage().showSuccessSnackBar(
              message: "BienVenue dans Optiparck", context: context);
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
        }
      },
      builder: (context, state) {
        if (state is LoadingAuthState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        border: Border.all(color: Colors.blueGrey),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Image.asset("images/logo.png"),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey),
                        gradient: const LinearGradient(
                            colors: [
                              Colors.blueGrey,
                              Colors.orange,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: SizedBox(
                                  width: 165,
                                  child: TextField(
                                    // style: const TextStyle(color: Colors.white),
                                    controller: nameControllor,
                                    keyboardType: TextInputType.name,
                                    decoration: const InputDecoration(
                                      hoverColor: Colors.blue,
                                      hintText: 'Name',
                                      labelText: 'Name',
                                      hintStyle: TextStyle(color: Colors.black),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide: BorderSide(
                                            color: Colors.orange, width: 2),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: SizedBox(
                                  width: 165,
                                  child: TextField(
                                    // style: const TextStyle(color: Colors.white),
                                    controller: prenomeControllor,
                                    keyboardType: TextInputType.name,
                                    decoration: const InputDecoration(
                                      hoverColor: Colors.blue,
                                      hintText: 'Prenome',
                                      labelText: 'Prenome',
                                      hintStyle: TextStyle(color: Colors.black),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide: BorderSide(
                                            color: Colors.orange, width: 2),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: SizedBox(
                              child: TextField(
                                // style: const TextStyle(color: Colors.white),
                                controller: emailControllor,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  hoverColor: Colors.blue,
                                  labelText: 'Email',
                                  hintText: 'Email',
                                  hintStyle: TextStyle(color: Colors.black),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color: Colors.orange, width: 2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: SizedBox(
                              child: TextField(
                                // style: const TextStyle(color: Colors.white),
                                controller: phoneControllor,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  hoverColor: Colors.blue,
                                  labelText: 'Numero Phone',
                                  hintText: 'Numero Phone',
                                  hintStyle: TextStyle(color: Colors.black),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color: Colors.orange, width: 2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: SizedBox(
                              child: TextField(
                                // style: const TextStyle(color: Colors.white),
                                controller: passwordControllor,

                                keyboardType: TextInputType.visiblePassword,
                                obscureText: _obscureText,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  labelText: 'Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                  ),
                                  hoverColor: Colors.blue,
                                  hintStyle:
                                      const TextStyle(color: Colors.black),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 1),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color: Colors.orange, width: 2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.blue),
                                minimumSize: const Size(200, 50),
                                // backgroundColor: Colors.blue,
                              ),
                              onPressed: () {
                                // Action pour se connecter

                                BlocProvider.of<AuthCubit>(context).singUpEvent(
                                    Client(
                                        userName: nameControllor.text,
                                        userId: "",
                                        userPrenom: prenomeControllor.text,
                                        phoneNumber:
                                            int.parse(phoneControllor.text),
                                        userEmail: emailControllor.text,
                                        userPassword: passwordControllor.text));
                              },
                              child: const ListTile(
                                title: Center(
                                  child: Text('Connexion',
                                      style: TextStyle(color: Colors.black)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
