import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temulik/constants/colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/profile_bloc.dart';
import 'complete_profile_page.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  final String? error;
  const LoginPage({Key? key, this.error}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg-login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              context.read<ProfileBloc>().add(LoadProfile());
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => HomePage()),
              );
            } else if (state is AuthNeedsProfile) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => CompleteProfilePage()),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Color(0xFF467852), Color(0xFF79BF66)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds),
                    child: Text(
                      'TEMULIK',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Color(0xFF467852), Color(0xFF79BF66)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds),
                    child: Text(
                      'Carikan, Temukan, Kembalikan',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 60),
                  Image.asset('assets/logo.png', width: 150, height: 150),
                  SizedBox(height: 60),
                  if (state is AuthLoading)
                    CircularProgressIndicator(
                      color: AppColors.green,
                    )
                  else
                    ElevatedButton(
                      child: Text(
                        'Masuk SSO',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      onPressed: () {
                        context.read<AuthBloc>().add(SignInWithGoogle());
                      },
                    ),
                  SizedBox(height: 20),
                  Opacity(
                    opacity: 0.7,
                    child: Text(
                      'Soeara Team Present\nVersion 1.8.4 build 300824(c) 2024',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
