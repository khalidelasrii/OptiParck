import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optiparck/bloc/bloc/auth_bloc.dart';

class SingInPage extends StatefulWidget {
  const SingInPage({super.key});

  @override
  State<SingInPage> createState() => _SingInPageState();
}

class _SingInPageState extends State<SingInPage> {
  @override
  void initState() {
    super.initState();
    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   if (user != null) {
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => const WelcomeScreen()));
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildapbar(),
      body: const BuildBody(),
    );
  }
}

AppBar _buildapbar() {
  return AppBar(
    backgroundColor: Colors.black,
    title: Row(
      children: [
        SizedBox(
          height: 40,
          child: Image.asset('images/logo.png', height: 50),
        )
      ],
    ),
  );
}

class BuildBody extends StatefulWidget {
  const BuildBody({super.key});

  @override
  State<BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends State<BuildBody> {
  TextEditingController emailControllor = TextEditingController();
  TextEditingController passwordControllor = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailControllor.dispose();
    passwordControllor.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is ErrorSingState) {
        // SnackBarMessage()
        //     .showErrorSnackBar(message: state.message, context: context);
      } else if (state is IsSingInState) {
        // SnackBarMessage()
        //     .showSuccessSnackBar(message: "Hello !", context: context);
      }
    }, builder: (context, state) {
      if (state is LodingAuthState) {
        return const CircularProgressIndicator();
      } else {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 80),
            child: Container(
              constraints: const BoxConstraints(minWidth: 300, minHeight: 300),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.black),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        ),
                      ),
                      child: Image.asset("images/logo.png"),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        gradient: const LinearGradient(
                          colors: [Colors.black, Colors.blueAccent],
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  'Connexion',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 8),
                                child: SizedBox(
                                  child: TextField(
                                      // Votre TextField pour l'email ici
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 40),
                                child: SizedBox(
                                  child: TextField(
                                      // Votre TextField pour le mot de passe ici
                                      ),
                                ),
                              ),
                              // ... Autres éléments UI

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(200, 50),
                                      backgroundColor: Colors.green,
                                    ),
                                    onPressed: () async {
                                      // Action lors de la connexion
                                    },
                                    child: const Text('Connexion'),
                                  ),
                                  const SizedBox(width: 20),
                                  MaterialButton(
                                    onPressed: () {
                                      // Action pour se connecter avec Google
                                    },
                                    child: SizedBox(
                                      height: 50,
                                      width:
                                          200, // Ajustez la largeur en fonction de vos besoins
                                      // child: /* Remplacez cela par le widget que vous voulez */,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Essayez de créer un compte',
                                style: TextStyle(color: Colors.white),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Action pour naviguer vers la création de compte
                                },
                                child: const Text(
                                  'Ici',
                                  style: TextStyle(color: Colors.amber),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}
