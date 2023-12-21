import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optiparck/bloc/bloc/auth_bloc.dart';
import 'package:optiparck/pages/home_page.dart';
import 'package:optiparck/pages/sing_in_page.dart';

void main() {
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
        home: SignInPage(),
      ),
    );
  }
}
