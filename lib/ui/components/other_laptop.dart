import 'package:flutter/material.dart';

class Laptop {
  final String image;
  final String status;
  final String title;
  final String location;
  final String date;
  final String type;

  Laptop({
    required this.image,
    required this.status,
    required this.title,
    required this.location,
    required this.date,
    required this.type,
  });
}

class LaptopLainnya extends StatelessWidget {
  final List<Laptop> laptops = [
    Laptop(
        title: 'Dell Inspiron 7000 Series',
        image: 'dell.png',
        status: 'Kehilangan',
        location: 'Pendopo bawah, PKM Unsoed',
        date: '12 Agustus 2024, 14:40',
        type: 'lost'),
    Laptop(
        title: 'Acer Nitro 5',
        image: 'acernitro.png',
        status: 'Penemuan',
        location: 'PII FMIPA',
        date: '13 Agustus 2024, 10:40',
        type: 'found'),
    Laptop(
      title: 'HP Pavillion Gaming 15',
      image: 'hppavillion.png',
      status: 'Penemuan',
      location: 'FISIP',
      date: '14 Agustus 2024, 08:40',
      type: 'found',
    ),
    Laptop(
      title: 'Laptop Advan Soulmate 1405',
      image: 'advan.png',
      status: 'Kehilangan',
      location: 'Pendopo bawah, PKM Unsoed',
      date: '12 Agustus 2024, 14.40',
      type: 'lost',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Laptop',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 3 / 4,
          ),
          itemCount: laptops.length,
          itemBuilder: (context, index) {
            final laptop = laptops[index];
            return Container(
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
                        child: Image.asset(
                          laptop.image,
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
                                color: laptop.type == 'lost'
                                    ? const Color(0xFFB60000)
                                    : const Color(0xFF1B6DF4),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Text(
                                laptop.status,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              laptop.title,
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
                                  'loct.png',
                                  width: 14,
                                  height: 14,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    laptop.location,
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
                                  'calendar.png',
                                  width: 14,
                                  height: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  laptop.date,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
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
            );
          },
        ),
      ),
    );
  }
}
