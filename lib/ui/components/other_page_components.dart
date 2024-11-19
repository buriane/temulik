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
          _buildCategoryItem(context, 'Laptop', 'laptop.png', LaptopLainnya()),
          _buildCategoryItem(context, 'Headset', 'headset.png', Scaffold()),
          _buildCategoryItem(context, 'Charger', 'charger.png', Scaffold()),
          _buildCategoryItem(context, 'Handphone', 'handphone.png', Scaffold()),
          _buildCategoryItem(context, 'Speaker', 'speaker.png', Scaffold()),
          _buildCategoryItem(context, 'Powerbank', 'powerbank.png', Scaffold()),
          SizedBox(height: 24), // Increased section spacing

          // Kendaraan dan Aksesori Section
          Text(
            'Kendaraan dan Aksesori',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildCategoryItem(context, 'Motor', 'motor.png', Scaffold()),
          _buildCategoryItem(context, 'Helm', 'helm.png', Scaffold()),
          _buildCategoryItem(
              context, 'Kunci Kendaraan', 'kunci.png', Scaffold()),
          SizedBox(height: 24),

          // Barang Pribadi Section
          Text(
            'Barang Pribadi',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildCategoryItem(context, 'Jam', 'jam.png', Scaffold()),
          _buildCategoryItem(context, 'Dompet', 'dompet.png', Scaffold()),
          _buildCategoryItem(context, 'Tas', 'tas.png', Scaffold()),
          _buildCategoryItem(context, 'Kunci', 'kuncikos.png', Scaffold()),
          _buildCategoryItem(context, 'Sepatu', 'sepatu.png', Scaffold()),
          _buildCategoryItem(context, 'Sandal', 'sandal.png', Scaffold()),
          _buildCategoryItem(context, 'Payung', 'payung.png', Scaffold()),
          SizedBox(height: 24),

          // Mahkluk Hidup Section
          Text(
            'Mahkluk Hidup',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildCategoryItem(context, 'Hewan', 'hewan.png', Scaffold()),
          _buildCategoryItem(context, 'Orang', 'orang.png', Scaffold()),
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
