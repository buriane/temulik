import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:temulik/constants/colors.dart';
import 'package:temulik/ui/detail_barang_page.dart';
import 'package:temulik/ui/detail_category_page.dart';

class LaporanSlider extends StatelessWidget {
  final String kategori;
  LaporanSlider({Key? key, required this.kategori}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                kategori,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailCategoryPage(kategori: kategori),
                    ),
                  );
                },
                child: Text(
                  'Lainnya',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.green,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(
                    AppColors.lightGreen,
                  ),
                  shape: WidgetStatePropertyAll<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  shadowColor: WidgetStatePropertyAll<Color>(
                    Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 320,
          margin: const EdgeInsets.only(bottom: 16),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('laporan')
                .where('kategori', isEqualTo: kategori)
                .where('status', isEqualTo: 'Dalam Proses')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Terjadi kesalahan dalam mengambil data'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.green),
                );
              }

              final documents = snapshot.data?.docs ?? [];

              if (documents.isEmpty) {
                return Center(
                  child: Text('Tidak ada data'),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final item = documents[index].data() as Map<String, dynamic>;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailBarangPage(activityData: item),
                        ),
                      );
                    },
                    child: Container(
                      width: 220,
                      margin: const EdgeInsets.only(right: 20, bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
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
                                            item['tipe'][0].toUpperCase()),
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
                                        fontSize: 20,
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
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/calendar.png',
                                          width: 14,
                                          height: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Row(
                                          children: [
                                            Text(
                                              DateFormat('dd MMMM yyyy').format(
                                                    DateTime.parse(item[
                                                        'tanggalKehilangan']),
                                                  ) +
                                                  ', ' +
                                                  item['jamKehilangan'],
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: GestureDetector(
                              onTap: () {
                                // Tambahkan aksi
                              },
                              child: const Icon(
                                Icons.more_horiz,
                                color: Colors.black,
                                size: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
