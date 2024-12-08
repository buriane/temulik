// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temulik/bloc/lapor_bloc.dart';
import 'package:temulik/repositories/lapor_repository.dart';
import 'package:temulik/ui/complete_profile_page.dart';
import 'package:temulik/ui/home_page.dart';
import 'package:temulik/ui/penemuan_form_page.dart';
import 'app_theme.dart';
import 'firebase_options.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/profile_bloc.dart';
import 'ui/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  runApp(MainApp(
    firestore: firestore,
    storage: storage,
  ));
}

class MainApp extends StatelessWidget {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  const MainApp({
    Key? key,
    required this.firestore,
    required this.storage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(),
        ),
        BlocProvider<LaporBloc>(
          create: (context) => LaporBloc(LaporRepository(firestore, storage)),
        ),
      ],
      child: MaterialApp(
        title: 'Temulik',
        theme: AppTheme.lightTheme.copyWith(
          textTheme: AppTheme.lightTheme.textTheme.apply(
            fontFamily: 'DMSans',
          ),
        ),
         home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is AuthAuthenticated) {
              return const HomePage();
            } else if (state is AuthNeedsProfile) {
              return CompleteProfilePage();
            } else if (state is AuthError) {
              return LoginPage(error: state.message);
            } else {
              return const LoginPage();
            }
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
