import 'package:flutter/material.dart';
import 'package:optiparck/pages/home_page.dart';

void main() {
  runApp(const OptiParck());
}

class OptiParck extends StatelessWidget {
  const OptiParck({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
