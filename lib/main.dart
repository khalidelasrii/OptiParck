import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optiparck/bloc/Info_cuibit/info_cubit.dart';
import 'package:optiparck/bloc/cubit/auth_cubit.dart';
import 'package:optiparck/pages/auth_pages/sing_in_page.dart';
import 'package:optiparck/pages/main_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCob1JBj1X35dWNrUEJR48csl152gX36Zc",
      appId: "1:110202083701:android:f2d7d23bce67bc268e1b3c",
      projectId: "optiparck-408621",
      messagingSenderId: '110202083701',
      authDomain: 'optiparck-408621.firebaseapp.com',
      storageBucket: "optiparck-408621.appspot.com",
    ),
  );

  runApp(const OptiParck());
}

class OptiParck extends StatelessWidget {
  const OptiParck({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => InfoCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: user != null ? const MainHomePage() : const SignInPage(),
      ),
    );
  }
}
