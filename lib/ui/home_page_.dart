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
import 'package:temulik/ui/components/laptop_section_components.dart';
import 'package:temulik/ui/components/motorcycle_section_components.dart';
import 'package:temulik/ui/components/other_page_components.dart';
import 'package:temulik/ui/components/other_laptop_components.dart';
import 'package:temulik/ui/components/search_page_components.dart';
import 'package:temulik/ui/components/setting_page_components.dart';

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

  Widget _buildGridItem(String title, String imagePath, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 63,
            height: 63,
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
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
            // Halaman Beranda
            SafeArea(
              child: Column(
                children: [
                  // Search and Profile Header
                  Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.green,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchPage()),
                              );
                            },
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 18),
                                    child: SvgPicture.asset(
                                      'assets/searchbar.svg',
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                  Expanded(
                                    child: AbsorbPointer(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Dompet',
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          contentPadding:
                                              EdgeInsets.only(left: 16),
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, profileState) {
                            return GestureDetector(
                              // Tambahkan GestureDetector untuk mendeteksi klik
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PengaturanPage()),
                                );
                              },
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundImage: profileState
                                              is ProfileComplete &&
                                          profileState.profile.photoUrl != null
                                      ? NetworkImage(
                                          profileState.profile.photoUrl!)
                                      : null,
                                  child: profileState is! ProfileComplete ||
                                          profileState.profile.photoUrl == null
                                      ? Icon(Icons.person, color: Colors.grey)
                                      : null,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Main Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Banner Section
                          Container(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 26, bottom: 56),
                            decoration: BoxDecoration(
                              color: Color(0xFFE0FBD2),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 7),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Temukan barang hilang',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'dapatkan reward-nya',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text('Bantu teman kita sekarang'),
                                            SizedBox(width: 4),
                                            SvgPicture.asset(
                                              'assets/next.svg',
                                              width: 16,
                                              height: 16,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'assets/reward.png',
                                      width: 184,
                                      height: 136,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Location Stats
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Transform.translate(
                              offset: Offset(0, -40),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Lokasi kamu',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  'assets/location.png',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'PURWOKERTO UTARA',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Rank kamu',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  'assets/rank.png',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  '98',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    // Divider
                                    Container(
                                      height: 1,
                                      color: Colors.grey[200],
                                    ),
                                    SizedBox(height: 16),
                                    // Stats section
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        // Kehilangan di sisi kiri
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/lost.png',
                                              width: 37,
                                              height: 37,
                                            ),
                                            SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Kehilangan',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  '4 kali',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        // Divider vertikal
                                        Container(
                                          height: 32,
                                          width: 1,
                                          color: Colors.grey[300],
                                        ),
                                        // Penemuan di sisi kanan
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/find.png',
                                              width: 37,
                                              height: 37,
                                            ),
                                            SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Penemuan',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  '12 kali',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Grid of Items
                          Transform.translate(
                            offset: Offset(0, -30),
                            child: GridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 4,
                              padding: EdgeInsets.all(16),
                              children: [
                                _buildGridItem(
                                    'Laptop', 'assets/categories/laptop.png',
                                    () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LaptopLainnya()),
                                  );
                                }),
                                _buildGridItem(
                                    'Headset', 'assets/categories/headset.png',
                                    () {
                                  print('Headset tapped');
                                }),
                                _buildGridItem(
                                    'Motor', 'assets/categories/motor.png', () {
                                  print('Motor tapped');
                                }),
                                _buildGridItem(
                                    'Charger', 'assets/categories/charger.png',
                                    () {
                                  print('Charger tapped');
                                }),
                                _buildGridItem('Handphone',
                                    'assets/categories/handphone.png', () {
                                  print('Handphone tapped');
                                }),
                                _buildGridItem(
                                    'Dompet', 'assets/categories/dompet.png',
                                    () {
                                  print('Dompet tapped');
                                }),
                                _buildGridItem(
                                    'Kunci', 'assets/categories/kunci.png', () {
                                  print('Kunci tapped');
                                }),
                                _buildGridItem(
                                    'Lainnya', 'assets/categories/lainnya.png',
                                    () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LainnyaPage()),
                                  );
                                }),
                              ],
                            ),
                          ),

                          // WhatsApp Button
                          Transform.translate(
                            offset: Offset(0, -30),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: ElevatedButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 4),
                                      child: SvgPicture.asset(
                                        'assets/whatsapp.svg',
                                        height: 22,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Gabung grup WA Temulik info barang hilang!',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Padding(
                                      padding: EdgeInsets.only(right: 4),
                                      child: SvgPicture.asset(
                                        'assets/arrow.svg',
                                        height: 22,
                                        colorFilter: ColorFilter.mode(
                                            Colors.white, BlendMode.srcIn),
                                      ),
                                    ),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                          // Banner Image Section
                          Transform.translate(
                            offset: Offset(0, -50),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: double.infinity,
                                  height: 280,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: AssetImage('assets/ads.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          LaptopSection(), // Section Laptop
                          MotorcycleSection(), // Section Motor

                          // Tombol Tampilkan Lebih Banyak
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 20),
                            child: Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.green,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                ),
                                child: const Text(
                                  'Tampilkan Lebih Banyak',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Halaman lain
            MapPage(),
            Center(child: Text('Lapor')), // Halaman Lapor
            ActivityPage(), // Halaman Aktivitas
            LeaderboardPage(), // Halaman Peringkat
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () => _onItemTapped(2), // Index 2 untuk Lapor
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: AppColors.green,
            shape: BoxShape.circle,
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.green.withOpacity(0.3),
            //     blurRadius: 8,
            //     offset: Offset(0, 4),
            //   ),
            // ],
          ),
          child: Container(
            padding: EdgeInsets.all(6), // White outline's padding
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white, // White border
                width: 4, // Thickness of the white border
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.green,
              ),
              child: Image.asset(
                'assets/temulik.png',
                width: 30.0,
                height: 30.0,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        height: 65, // Tetapkan tinggi yang fixed
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.green,
          unselectedItemColor: Color(0xFF484C52),
          selectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: _onItemTapped,
          items: [
            // Item Beranda
            _buildNavigationBarItem(0, _iconPaths[0], 'Beranda'),
            // Item Cari
            _buildNavigationBarItem(1, _iconPaths[1], 'Cari'),
            // Item Tengah (Spacer untuk FAB)
            BottomNavigationBarItem(
              icon: SizedBox(height: 16),
              label: 'Lapor',
            ),
            // Item Aktivitas
            _buildNavigationBarItem(3, _iconPaths[3], 'Aktivitas'),
            // Item Peringkat
            _buildNavigationBarItem(4, _iconPaths[4], 'Peringkat'),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavigationBarItem(
      int index, String iconPath, String label) {
    return BottomNavigationBarItem(
      icon: Stack(
        children: [
          // Active line positioned absolutely with drop shadow effect
          Transform.translate(
            offset: Offset(0, -12), // Shift the line upwards by 4 units
            child: Container(
              height: 2.5,
              decoration: BoxDecoration(
                color: _selectedIndex == index
                    ? AppColors.green
                    : Colors.transparent,
                boxShadow: _selectedIndex == index
                    ? [
                        BoxShadow(
                          color: AppColors.green, // Green color with opacity
                          blurRadius: 12, // Blur effect
                          offset: Offset(0, 4),
                          spreadRadius: 0, // No spread for shadow
                        ),
                      ]
                    : [],
              ),
            ),
          ),
          // Icon centered within the stack
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              iconPath,
              colorFilter: ColorFilter.mode(
                _selectedIndex == index ? AppColors.green : Color(0xFF484C52),
                BlendMode.srcIn,
              ),
              height: 24,
            ),
          ),
        ],
      ),
      label: label,
    );
  }
}
