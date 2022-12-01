import 'package:bloc_assessment/di/injector.dart';
import 'package:flutter/material.dart';

import 'feature_display_list/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beer App',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const DisplayBeerScreen(),
      },
    );
  }
}
