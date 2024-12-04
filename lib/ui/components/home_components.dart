import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temulik/constants/colors.dart';
import 'package:temulik/ui/components/laptop_section_components.dart';
import 'package:temulik/ui/components/motorcycle_section_components.dart';
import 'package:temulik/ui/components/other_page_components.dart';
import 'package:temulik/ui/components/other_laptop_components.dart';
import 'package:temulik/ui/components/search_page_components.dart';
import 'package:temulik/ui/components/setting_page_components.dart';
import 'package:temulik/ui/kehilangan_form_page.dart';
import 'package:temulik/ui/penemuan_form_page.dart';
import '../../bloc/profile_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeContent extends StatelessWidget {
  final int selectedIndex;

  const HomeContent({Key? key, required this.selectedIndex}) : super(key: key);

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
    return SafeArea(
      child: Column(
        children: [
          const SearchHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BannerSection(),
                  LocationStatsCard(),
                  CategoryGrid(buildGridItem: _buildGridItem),
                  WhatsAppButton(),
                  AdvertisementBanner(),
                  LaptopSection(),
                  MotorcycleSection(),
                  ShowMoreButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchHeader extends StatelessWidget {
  const SearchHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.green,
      child: Row(
        children: [
          Expanded(
            child: SearchBar(),
          ),
          SizedBox(width: 12),
          ProfileAvatar(),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()),
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
                    contentPadding: EdgeInsets.only(left: 16),
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
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PengaturanPage()),
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
              backgroundColor: Colors.white,
              child: _buildProfileImage(profileState),
            ),
          ),
        );
      },
    );
  }

Widget _buildProfileImage(ProfileState profileState) {
  if (profileState is ProfileComplete && profileState.profile.photoUrl != null) {
    return Image.network(
      profileState.profile.photoUrl!,
      width: 44,
      height: 44,
      fit: BoxFit.cover,
      headers: {
        // If you have an auth token
        'Authorization': 'Bearer ${FirebaseAuth.instance.currentUser?.getIdToken()}',
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return CircularProgressIndicator();
      },
      errorBuilder: (context, error, stackTrace) {
        print('Detailed image loading error: $error');
        print('Error stacktrace: $stackTrace');
        return Icon(Icons.person, color: Colors.grey);
      },
    );
  } else {
    return Icon(Icons.person, color: Colors.grey);
  }
}
}

class BannerSection extends StatelessWidget {
  const BannerSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 26, bottom: 56),
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }
}

class LocationStatsCard extends StatelessWidget {
  const LocationStatsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
              Container(
                height: 1,
                color: Colors.grey[200],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/lost.png',
                        width: 37,
                        height: 37,
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                  Container(
                    height: 32,
                    width: 1,
                    color: Colors.grey[300],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/find.png',
                        width: 37,
                        height: 37,
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }
}

class CategoryGrid extends StatelessWidget {
  final Widget Function(String, String, VoidCallback) buildGridItem;

  const CategoryGrid({
    Key? key,
    required this.buildGridItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -30),
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        padding: EdgeInsets.all(16),
        children: [
          buildGridItem('Laptop', 'assets/categories/laptop.png', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LaptopLainnya()),
            );
          }),
          buildGridItem('Headset', 'assets/categories/headset.png', () {
            print('Headset tapped');
          }),
          buildGridItem('Motor', 'assets/categories/motor.png', () {
            print('Motor tapped');
          }),
          buildGridItem('Charger', 'assets/categories/charger.png', () {
            print('Charger tapped');
          }),
          buildGridItem('Handphone', 'assets/categories/handphone.png', () {
            print('Handphone tapped');
          }),
          buildGridItem('Dompet', 'assets/categories/dompet.png', () {
            print('Dompet tapped');
          }),
          buildGridItem('Kunci', 'assets/categories/kunci.png', () {
            print('Kunci tapped');
          }),
          buildGridItem('Lainnya', 'assets/categories/lainnya.png', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LainnyaPage()),
            );
          }),
        ],
      ),
    );
  }
}

class WhatsAppButton extends StatelessWidget {
  const WhatsAppButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -30),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
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
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdvertisementBanner extends StatelessWidget {
  const AdvertisementBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
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
    );
  }
}

// Custom Page Route Animation
class CustomPageRoute extends PageRouteBuilder {
  final Widget child;

  CustomPageRoute({required this.child})
      : super(
          transitionDuration: Duration(milliseconds: 400),
          reverseTransitionDuration: Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic,
        ),
      ),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

// Modified CustomFloatingActionButton
class CustomFloatingActionButton extends StatefulWidget {
  final VoidCallback onTap;

  const CustomFloatingActionButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CustomFloatingActionButton> createState() =>
      _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState extends State<CustomFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  bool isExpanded = false;
  final GlobalKey _overlayKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.785398, // 45 degrees in radians
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _animationController.dispose();
    super.dispose();
  }

  void _createOverlay(BuildContext context) {
    if (!mounted) return;

    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final RenderBox? renderBox =
            _overlayKey.currentContext?.findRenderObject() as RenderBox?;

        if (renderBox == null) return const SizedBox.shrink();

        final position = renderBox.localToGlobal(Offset.zero);

        return Stack(
          children: [
            // Background overlay for dismissing
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleMenu,
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            // Kehilangan Button
            Positioned(
              left: position.dx - 30,
              top: position.dy - 140,
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 50 * (1 - _scaleAnimation.value)),
                    child: Opacity(
                      opacity: _scaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22.5),
                    onTap: () {
                      _toggleMenu();
                      Navigator.push(
                        context,
                        CustomPageRoute(child: KehilanganFormPage()),
                      );
                    },
                    child: Ink(
                      height: 45,
                      width: 150,
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(22.5),
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/question.png',
                              height: 30,
                              width: 30,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Kehilangan',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Penemuan Button
            Positioned(
              left: position.dx - 30,
              top: position.dy - 80,
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 30 * (1 - _scaleAnimation.value)),
                    child: Opacity(
                      opacity: _scaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22.5),
                    onTap: () {
                      _toggleMenu();
                      Navigator.push(
                        context,
                        CustomPageRoute(child: PenemuanFormPage()),
                      );
                    },
                    child: Ink(
                      height: 45,
                      width: 150,
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(22.5),
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/loupe.png',
                              height: 25,
                              width: 25,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Penemuan',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _toggleMenu() async {
    if (!mounted) return;

    setState(() {
      isExpanded = !isExpanded;
    });

    try {
      if (isExpanded) {
        await _animationController.forward();
        _createOverlay(context);
      } else {
        _removeOverlay();
        await _animationController.reverse();
      }
    } catch (e) {
      print('Error in toggle menu: $e');
      _removeOverlay();
      if (mounted) {
        setState(() {
          isExpanded = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      key: _overlayKey,
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () async {
          await _toggleMenu();
          widget.onTap();
        },
        child: TweenAnimationBuilder(
          duration: Duration(milliseconds: 300),
          tween: Tween<double>(begin: 0, end: isExpanded ? 1.1 : 1.0),
          builder: (context, double scale, child) {
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Container(
            height: 65.0,
            width: 65.0,
            decoration: BoxDecoration(
              color: AppColors.green,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.green.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.green,
                ),
                child: AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: isExpanded
                          ? Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 45.0,
                            )
                          : Image.asset(
                              'assets/temulik.png',
                              width: 30.0,
                              height: 30.0,
                              fit: BoxFit.contain,
                            ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final List<String> iconPaths;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.iconPaths,
    required this.onItemTapped,
  }) : super(key: key);

  BottomNavigationBarItem _buildNavigationBarItem(
      int index, String iconPath, String label) {
    return BottomNavigationBarItem(
      icon: Stack(
        children: [
          Transform.translate(
            offset: Offset(0, -12),
            child: Container(
              height: 2.5,
              decoration: BoxDecoration(
                color: selectedIndex == index
                    ? AppColors.green
                    : Colors.transparent,
                boxShadow: selectedIndex == index
                    ? [
                        BoxShadow(
                          color: AppColors.green,
                          blurRadius: 12,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ]
                    : [],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              iconPath,
              colorFilter: ColorFilter.mode(
                selectedIndex == index ? AppColors.green : Color(0xFF484C52),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
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
        currentIndex: selectedIndex,
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
        onTap: onItemTapped,
        items: [
          _buildNavigationBarItem(0, iconPaths[0], 'Beranda'),
          _buildNavigationBarItem(1, iconPaths[1], 'Cari'),
          BottomNavigationBarItem(
            icon: SizedBox(height: 24.0),
            label: 'Lapor',
          ),
          _buildNavigationBarItem(3, iconPaths[3], 'Aktivitas'),
          _buildNavigationBarItem(4, iconPaths[4], 'Peringkat'),
        ],
      ),
    );
  }
}

class ShowMoreButton extends StatelessWidget {
  const ShowMoreButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Container(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
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
    );
  }
}
