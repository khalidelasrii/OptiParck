import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optiparck/bloc/cubit/auth_cubit.dart';
import 'package:optiparck/pages/auth_pages/sing_up_page.dart';
import 'package:optiparck/pages/main_home_page.dart';
import 'package:optiparck/widgets/Client.dart';
import 'package:optiparck/widgets/snack_bar_messages.dart';

// Créez vos propres classes AuthBloc et AuthState si elles ne sont pas déjà définies

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: _buildAppBar(context),
      body: const BuildBodySingIn(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueGrey,
      leading: IconButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const MainHomePage()));
        },
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}

class BuildBodySingIn extends StatefulWidget {
  const BuildBodySingIn({Key? key}) : super(key: key);

  @override
  State<BuildBodySingIn> createState() => _BuildBodySingInState();
}

class _BuildBodySingInState extends State<BuildBodySingIn> {
  TextEditingController emailControllor = TextEditingController();
  TextEditingController passwordControllor = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    super.dispose();
    emailControllor.dispose();
    passwordControllor.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is IsSignInState) {
          // Traitement après une connexion réussie
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const MainHomePage()));
        } else if (state is ErrorSignInState) {
          // Traitement en cas d'erreur de connexion
          SnackBarMessage().showErrorSnackBar(
              message: "Error to connect Try agine", context: context);
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
                                controller: passwordControllor,
                                obscureText: _obscureText,
                                keyboardType: TextInputType.visiblePassword,
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 40,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(200, 50),
                                    backgroundColor: Colors.blue,
                                  ),
                                  onPressed: () {
                                    // Action pour se connecter

                                    BlocProvider.of<AuthCubit>(context)
                                        .singInEvent(Client(
                                            userName: "userName",
                                            userId: "userId",
                                            userEmail: emailControllor.text,
                                            userPassword:
                                                passwordControllor.text));
                                  },
                                  child: const ListTile(
                                    title: Center(
                                      child: Text('Connexion',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(200, 50),
                                    // backgroundColor: Colors.blue,
                                  ),
                                  onPressed: () {
                                    // Action pour se connecter avec Google

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const SingUpPage()));
                                  },
                                  child: const ListTile(
                                    title: Center(
                                      child: Text('Sing Up ',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(200, 50),
                                    // backgroundColor: Colors.blue,
                                  ),
                                  onPressed: () {
                                    BlocProvider.of<AuthCubit>(context)
                                        .signInWithGoogle();
                                  },
                                  child: ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset('images/google.png'),
                                    ),
                                    title: const Text('Sing with google ',
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
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
