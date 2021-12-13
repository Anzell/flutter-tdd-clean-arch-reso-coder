import 'package:flutter/material.dart';
import 'package:tddflutter/di/injector.dart';
import 'package:tddflutter/presentation/number_trivia/number_trivia_screen.dart';

Future<void> main() async {
  await Injector.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Number Trivia",
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        accentColor: Colors.green.shade600,
      ),
      home: const NumberTriviaScreen(),
    );
  }
}
