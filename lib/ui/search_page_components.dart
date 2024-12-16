import 'package:flutter/material.dart';
import 'package:temulik/constants/colors.dart';
import 'package:temulik/ui/detail_category_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:temulik/ui/detail_barang_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override 
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  Widget _buildSearchResults() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('laporan')
          .where('status', isEqualTo: 'Dalam Proses')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('Firestore Error: ${snapshot.error}'); // Debug log
          return Center(child: Text('Gagal memuat data'));
        }
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: AppColors.green));
        }

        final documents = snapshot.data?.docs ?? [];
        
        // Filter documents locally based on search query
        final filteredDocs = documents.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final namaBarang = data['namaBarang'].toString().toLowerCase();
          return namaBarang.contains(_searchQuery.toLowerCase());
        }).toList();

        if (filteredDocs.isEmpty) {
          return Center(child: Text('Tidak ada data'));
        }

        return Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12.0,
              crossAxisSpacing: 12.0, 
              childAspectRatio: 3 / 5,
            ),
            itemCount: filteredDocs.length,
            itemBuilder: (context, index) {
              final item = filteredDocs[index].data() as Map<String, dynamic>;
              final docId = filteredDocs[index].id;
              
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => DetailBarangPage(docId: docId),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.network(
                              item['imageUrls'][0],
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: item['tipe'] == 'kehilangan'
                                        ? AppColors.red
                                        : AppColors.blue,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Text(
                                    item['tipe'].replaceFirst(
                                      item['tipe'][0],
                                      item['tipe'][0].toUpperCase(),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item['namaBarang'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/loct.png',
                                      width: 14,
                                      height: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        item['lokasi'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pencarian',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_searchQuery.isEmpty) ...[
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
                              builder: (context) =>
                                  DetailCategoryPage(kategori: 'Laptop')),
                        );
                      }),
                      SizedBox(width: 32),
                      _buildPopularCategory(
                          'Headset', 'assets/categories/headset.png', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailCategoryPage(kategori: 'Headset'),
                          ),
                        );
                      }),
                      SizedBox(width: 32),
                      _buildPopularCategory(
                          'Motor', 'assets/categories/motor.png', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailCategoryPage(kategori: 'Motor'),
                          ),
                        );
                      }),
                      SizedBox(width: 32),
                      _buildPopularCategory(
                          'Charger', 'assets/categories/charger.png', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailCategoryPage(kategori: 'Charger'),
                          ),
                        );
                      }),
                      SizedBox(width: 32),
                      _buildPopularCategory(
                          'Handphone', 'assets/categories/handphone.png', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailCategoryPage(kategori: 'Handphone'),
                          ),
                        );
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
          ] else
            _buildSearchResults(),
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
        // Set the search text and trigger search
        _searchController.text = tag;
        _searchController.selection = TextSelection.fromPosition(
          TextPosition(offset: _searchController.text.length),
        );
        setState(() {
          _searchQuery = tag;
        });
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
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
