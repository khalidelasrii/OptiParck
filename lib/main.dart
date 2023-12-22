import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optiparck/bloc/bloc/auth_bloc.dart';
import 'package:optiparck/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDneaYQTPYSFLx0nJGxgyg6rgXqDt0fKws",
      appId: "1:108427386333:android:8e3908e86c48ff9c7d2a34",
      projectId: "optiparck",
      messagingSenderId: '108427386333',
      authDomain: 'optiparck.firebaseapp.com',
    ),
  );
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const OptiParck());
}

class OptiParck extends StatelessWidget {
  const OptiParck({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        )
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
