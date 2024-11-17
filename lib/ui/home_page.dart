import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temulik/ui/activity_page.dart';
import 'package:temulik/ui/leaderboard_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/profile_bloc.dart';
import 'login_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Daftar path icon SVG
  final List<String> _iconPaths = [
    'home.svg',
    'search.svg',
    'temulik.png',
    'clock.svg',
    'peringkat.svg',
  ];

  // Fungsi untuk menangani perubahan tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Widget untuk menampilkan konten profil
  Widget _buildProfileContent() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileComplete) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: profileState.profile.photoUrl != null
                      ? NetworkImage(profileState.profile.photoUrl!)
                      : null,
                  child: profileState.profile.photoUrl == null
                      ? Icon(Icons.person, size: 50)
                      : null,
                ),
                SizedBox(height: 16),
                Text('Welcome, ${profileState.profile.fullName}!'),
                SizedBox(height: 16),
                Text('Email: ${profileState.profile.email}'),
                SizedBox(height: 16),
                Text('NIM: ${profileState.profile.nim}'),
                SizedBox(height: 16),
                Text('Faculty: ${profileState.profile.faculty}'),
                SizedBox(height: 16),
                ElevatedButton(
                  child: Text('Sign Out'),
                  onPressed: () {
                    context.read<AuthBloc>().add(SignOut());
                  },
                ),
              ],
            ),
          );
        } else if (profileState is ProfileLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (profileState is ProfileError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error loading profile: ${profileState.message}'),
                SizedBox(height: 16),
                ElevatedButton(
                  child: Text('Retry'),
                  onPressed: () {
                    context.read<ProfileBloc>().add(LoadProfile());
                  },
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text('Unexpected state: $profileState'));
        }
      },
    );
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
            _buildProfileContent(), // Beranda
            Center(child: Text('Cari')), // Halaman Cari
            Center(child: Text('Lapor')), // Halaman Lapor
            ActivityPage(), // Halaman Aktivitas
            LeaderboardPage(), // Halaman Peringkat
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Container(
                  height: 2,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                    color:
                        _selectedIndex == 0 ? Colors.green : Colors.transparent,
                    boxShadow: _selectedIndex == 0
                        ? [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                  ),
                ),
                SizedBox(height: 8),
                SvgPicture.asset(
                  _iconPaths[0],
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 0 ? Colors.green : Colors.grey,
                    BlendMode.srcIn,
                  ),
                  height: 24,
                ),
              ],
            ),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Container(
                  height: 2,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                    color:
                        _selectedIndex == 1 ? Colors.green : Colors.transparent,
                    boxShadow: _selectedIndex == 1
                        ? [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                  ),
                ),
                SizedBox(height: 8),
                SvgPicture.asset(
                  _iconPaths[1],
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 1 ? Colors.green : Colors.grey,
                    BlendMode.srcIn,
                  ),
                  height: 24,
                ),
              ],
            ),
            label: 'Cari',
          ),
          BottomNavigationBarItem(
            icon: Container(
              height: 50,
              width: 50,
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'temulik.png',
                width: 30,
                height: 30,
              ),
            ),
            label: 'Lapor',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Container(
                  height: 2,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                    color:
                        _selectedIndex == 3 ? Colors.green : Colors.transparent,
                    boxShadow: _selectedIndex == 3
                        ? [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                  ),
                ),
                SizedBox(height: 8),
                SvgPicture.asset(
                  _iconPaths[3],
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 3 ? Colors.green : Colors.grey,
                    BlendMode.srcIn,
                  ),
                  height: 24,
                ),
              ],
            ),
            label: 'Aktivitas',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Container(
                  height: 2,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                    color:
                        _selectedIndex == 4 ? Colors.green : Colors.transparent,
                    boxShadow: _selectedIndex == 4
                        ? [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                  ),
                ),
                SizedBox(height: 8),
                SvgPicture.asset(
                  _iconPaths[4],
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 4 ? Colors.green : Colors.grey,
                    BlendMode.srcIn,
                  ),
                  height: 24,
                ),
              ],
            ),
            label: 'Peringkat',
          ),
        ],
      ),
    );
  }
}
