import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/report_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../middleware/auth_middleware.dart';

class Routes {
  static const String home = '/';
  static const String report = '/report';
  static const String login = '/login';
  static const String register = '/register';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const AuthMiddleware(child: HomeScreen()),
        );
      case report:
        return MaterialPageRoute(
          builder: (_) => const AuthMiddleware(child: ReportScreen()),
        );
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
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