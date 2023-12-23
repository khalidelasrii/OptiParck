import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:optiparck/bloc/cubit/auth_cubit.dart';
import 'package:optiparck/pages/home_page.dart';
import 'package:optiparck/widgets/snack_bar_messages.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        )
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
