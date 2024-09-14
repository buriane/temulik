import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class AuthMiddleware extends StatelessWidget {
  final Widget child;

  const AuthMiddleware({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            // User is not authenticated, redirect to login
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed('/login');
            });
            return Container(); // Return an empty container while redirecting
          }
          // User is authenticated, show the protected content
          return child;
        }
        // Connection to auth state is still in progress
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}