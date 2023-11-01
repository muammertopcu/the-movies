import 'package:flutter/material.dart';
import 'package:the_movies/screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const HomeScreen(),
    );
  }
}

class MyHomePage {
  const MyHomePage();
}
