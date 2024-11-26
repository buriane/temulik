import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temulik/constants/colors.dart';
import 'package:temulik/ui/activity_page.dart';
import 'package:temulik/ui/leaderboard_page.dart';
import 'package:temulik/ui/map_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/profile_bloc.dart';
import 'login_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'components/home_components.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<String> _iconPaths = [
    'assets/home.svg',
    'assets/search.svg',
    'assets/temulik.png',
    'assets/clock.svg',
    'assets/peringkat.svg',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => LoginPage()),
            );
          }
        },
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            HomeContent(selectedIndex: _selectedIndex),
            MapPage(),
            Center(child: Text('Lapor')),
            ActivityPage(),
            LeaderboardPage(),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onTap: () => _onItemTapped(2),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        iconPaths: _iconPaths,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
