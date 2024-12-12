import 'package:flutter/material.dart';
import 'package:temulik/constants/colors.dart';
import 'package:temulik/ui/detail_category_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Controller untuk TextField
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController
        .dispose(); // Membersihkan controller ketika widget di dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pencarian',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //SearchTextField
          Container(
            margin: EdgeInsets.all(16),
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(37),
              border: Border.all(color: AppColors.darkest),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: SvgPicture.asset(
                    'assets/searchbar.svg',
                    width: 20,
                    height: 20,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Dompet',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintStyle: TextStyle(color: AppColors.darkGrey),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Kategori populer',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildPopularCategory(
                        'Laptop', 'assets/categories/laptop.png', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailCategoryPage()),
                      );
                    }),
                    SizedBox(width: 32),
                    _buildPopularCategory(
                        'Headset', 'assets/categories/headset.png', () {
                      // Tambahkan navigasi untuk Headset jika diperlukan
                    }),
                    SizedBox(width: 32),
                    _buildPopularCategory(
                        'Motor', 'assets/categories/motor.png', () {
                      // Tambahkan navigasi untuk Motor jika diperlukan
                    }),
                    SizedBox(width: 32),
                    _buildPopularCategory(
                        'Charger', 'assets/categories/charger.png', () {
                      // Tambahkan navigasi untuk Charger jika diperlukan
                    }),
                    SizedBox(width: 32),
                    _buildPopularCategory(
                        'Handphone', 'assets/categories/handphone.png', () {
                      // Tambahkan navigasi untuk Handphone jika diperlukan
                    }),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Pencarian populer',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 14,
              runSpacing: 16,
              children: [
                _buildSearchTag('xiaomi'),
                _buildSearchTag('msi'),
                _buildSearchTag('samsung'),
                _buildSearchTag('vario'),
                _buildSearchTag('beat'),
                _buildSearchTag('iphone'),
                _buildSearchTag('dompet'),
                _buildSearchTag('tas'),
                _buildSearchTag('acer'),
                _buildSearchTag('helm'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularCategory(
      String title, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            imagePath,
            width: 60,
            height: 60,
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTag(String tag) {
    return GestureDetector(
      onTap: () {
        _searchController.text = tag;
        _searchController.selection = TextSelection.fromPosition(
          TextPosition(offset: _searchController.text.length),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          tag,
          style: TextStyle(
              color: AppColors.green,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
