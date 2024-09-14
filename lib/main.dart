import 'package:flutter/material.dart';
import 'utils/theme.dart';
import 'utils/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temulik',
      theme: TemulikTheme.lightTheme,
      initialRoute: Routes.home,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}