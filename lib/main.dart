// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temulik/bloc/penemuan_bloc.dart';
import 'package:temulik/repositories/penemuan_repository.dart';
import 'package:temulik/ui/home_page.dart';
import 'package:temulik/ui/penemuan_form_page.dart';
import 'app_theme.dart';
import 'firebase_options.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/profile_bloc.dart';
import 'ui/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
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
        BlocProvider(
          create: (context) => PenemuanBloc(PenemuanRepository()),
          child: PenemuanFormPage(),
        )
      ],
      child: MaterialApp(
        title: 'Temulik',
        theme: AppTheme.lightTheme.copyWith(
          textTheme: AppTheme.lightTheme.textTheme.apply(
            fontFamily: 'DMSans',
          ),
        ),
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
