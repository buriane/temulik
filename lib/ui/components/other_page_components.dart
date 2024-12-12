import 'package:flutter/material.dart';
import 'package:temulik/ui/detail_category_page.dart';

class LainnyaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kategori',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        children: [
          // Elektronik Section
          Text(
            'Elektronik',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildCategoryItem(
            context,
            'Laptop',
            'assets/categories/laptop.png',
            DetailCategoryPage(kategori: 'Laptop'),
          ),
          _buildCategoryItem(
            context,
            'Headset',
            'assets/categories/headset.png',
            DetailCategoryPage(kategori: 'Headset'),
          ),
          _buildCategoryItem(
            context,
            'Charger',
            'assets/categories/charger.png',
            DetailCategoryPage(kategori: 'Charger'),
          ),
          _buildCategoryItem(
            context,
            'Handphone',
            'assets/categories/handphone.png',
            DetailCategoryPage(kategori: 'Handphone'),
          ),
          _buildCategoryItem(
            context,
            'Speaker',
            'assets/categories/speaker.png',
            DetailCategoryPage(kategori: 'Speaker'),
          ),
          _buildCategoryItem(
            context,
            'Powerbank',
            'assets/categories/powerbank.png',
            DetailCategoryPage(kategori: 'Powerbank'),
          ),
          SizedBox(height: 24),
          Text(
            'Kendaraan dan Aksesori',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildCategoryItem(
            context,
            'Motor',
            'assets/categories/motor.png',
            DetailCategoryPage(kategori: 'Motor'),
          ),
          _buildCategoryItem(
            context,
            'Helm',
            'assets/categories/helm.png',
            DetailCategoryPage(kategori: 'Helm'),
          ),
          _buildCategoryItem(
            context,
            'Kunci Kendaraan',
            'assets/categories/kunci.png',
            DetailCategoryPage(kategori: 'Kunci'),
          ),
          SizedBox(height: 24),

          // Barang Pribadi Section
          Text(
            'Barang Pribadi',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildCategoryItem(
            context,
            'Jam',
            'assets/categories/jam.png',
            DetailCategoryPage(kategori: 'Jam'),
          ),
          _buildCategoryItem(
            context,
            'Dompet',
            'assets/categories/dompet.png',
            DetailCategoryPage(kategori: 'Dompet'),
          ),
          _buildCategoryItem(
            context,
            'Tas',
            'assets/categories/tas.png',
            DetailCategoryPage(kategori: 'Tas'),
          ),
          _buildCategoryItem(
            context,
            'Kunci',
            'assets/categories/kuncikos.png',
            DetailCategoryPage(kategori: 'Kuncikos'),
          ),
          _buildCategoryItem(
            context,
            'Sepatu',
            'assets/categories/sepatu.png',
            DetailCategoryPage(kategori: 'Sepatu'),
          ),
          _buildCategoryItem(
            context,
            'Sandal',
            'assets/categories/sandal.png',
            DetailCategoryPage(kategori: 'Sandal'),
          ),
          _buildCategoryItem(
            context,
            'Payung',
            'assets/categories/payung.png',
            DetailCategoryPage(kategori: 'Payung'),
          ),
          SizedBox(height: 24),

          // Mahkluk Hidup Section
          Text(
            'Mahkluk Hidup',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildCategoryItem(
            context,
            'Hewan',
            'assets/categories/hewan.png',
            DetailCategoryPage(kategori: 'Hewan'),
          ),
          _buildCategoryItem(
            context,
            'Orang',
            'assets/categories/orang.png',
            DetailCategoryPage(kategori: 'Orang'),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
      BuildContext context, String title, String imagePath, Widget targetPage) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Image.asset(
              imagePath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => targetPage),
              );
            },
          ),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
        ],
      ),
    );
  }
}
