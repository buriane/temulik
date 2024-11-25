import 'package:flutter/material.dart';
import 'package:temulik/ui/components/other_laptop_components.dart';

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
          SizedBox(height: 16), // Increased spacing
          _buildCategoryItem(
              context, 'Laptop', 'assets/categories/laptop.png', LaptopLainnya()),
          _buildCategoryItem(
              context, 'Headset', 'assets/categories/headset.png', Scaffold()),
          _buildCategoryItem(
              context, 'Charger', 'assets/categories/charger.png', Scaffold()),
          _buildCategoryItem(
              context, 'Handphone', 'assets/categories/handphone.png', Scaffold()),
          _buildCategoryItem(
              context, 'Speaker', 'assets/categories/speaker.png', Scaffold()),
          _buildCategoryItem(
              context, 'Powerbank', 'assets/categories/powerbank.png', Scaffold()),
          SizedBox(height: 24), // Increased section spacing

          // Kendaraan dan Aksesori Section
          Text(
            'Kendaraan dan Aksesori',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildCategoryItem(
              context, 'Motor', 'assets/categories/motor.png', Scaffold()),
          _buildCategoryItem(
              context, 'Helm', 'assets/categories/helm.png', Scaffold()),
          _buildCategoryItem(
              context, 'Kunci Kendaraan', 'assets/categories/kunci.png', Scaffold()),
          SizedBox(height: 24),

          // Barang Pribadi Section
          Text(
            'Barang Pribadi',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildCategoryItem(context, 'Jam', 'assets/categories/jam.png', Scaffold()),
          _buildCategoryItem(
              context, 'Dompet', 'assets/categories/dompet.png', Scaffold()),
          _buildCategoryItem(context, 'Tas', 'assets/categories/tas.png', Scaffold()),
          _buildCategoryItem(
              context, 'Kunci', 'assets/categories/kuncikos.png', Scaffold()),
          _buildCategoryItem(
              context, 'Sepatu', 'assets/categories/sepatu.png', Scaffold()),
          _buildCategoryItem(
              context, 'Sandal', 'assets/categories/sandal.png', Scaffold()),
          _buildCategoryItem(
              context, 'Payung', 'assets/categories/payung.png', Scaffold()),
          SizedBox(height: 24),

          // Mahkluk Hidup Section
          Text(
            'Mahkluk Hidup',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildCategoryItem(
              context, 'Hewan', 'assets/categories/hewan.png', Scaffold()),
          _buildCategoryItem(
              context, 'Orang', 'assets/categories/orang.png', Scaffold()),
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
