import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/report_screen.dart';

class Routes {
  static const String home = '/';
  static const String report = '/report';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case report:
        return MaterialPageRoute(builder: (_) => const ReportScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}