import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optiparck/bloc/Info_cuibit/info_cubit.dart';
import 'package:optiparck/bloc/cubit/auth_cubit.dart';
import 'package:optiparck/ddd.dart';
import 'package:optiparck/pages/sing_in_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDneaYQTPYSFLx0nJGxgyg6rgXqDt0fKws",
        appId: "1:108427386333:android:8e3908e86c48ff9c7d2a34",
        projectId: "optiparck",
        messagingSenderId: '108427386333',
        authDomain: 'optiparck.firebaseapp.com',
        storageBucket: "optiparck.appspot.com",
        databaseURL:
            "https://optiparck-default-rtdb.europe-west1.firebasedatabase.app/"),
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
        home: user != null ? MapScreen() : const SignInPage(),
      ),
    );
  }
}
