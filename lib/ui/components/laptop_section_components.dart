import 'package:flutter/material.dart';
import 'package:temulik/ui/components/other_laptop_components.dart';

class LaptopItem {
  final String title;
  final String image;
  final String status;
  final String location;
  final String date;
  final String type;

  LaptopItem({
    required this.title,
    required this.image,
    required this.status,
    required this.location,
    required this.date,
    required this.type,
  });
}

class LaptopSection extends StatelessWidget {
  LaptopSection({Key? key}) : super(key: key);

  // Data simulasi
  final List<LaptopItem> laptops = [
    LaptopItem(
        title: 'Dell Inspiron 7000 Series',
        image: 'assets/laptop/dell.png',
        status: 'Kehilangan',
        location: 'Pendopo bawah, PKM Unsoed',
        date: '12 Agustus 2024, 14:40',
        type: 'lost'),
    LaptopItem(
        title: 'Acer Nitro 5',
        image: 'assets/laptop/acernitro.png',
        status: 'Penemuan',
        location: 'PII FMIPA',
        date: '13 Agustus 2024, 10:40',
        type: 'found'),
    LaptopItem(
        title: 'HP Pavillion Gaming 15',
        image: 'assets/laptop/hppavillion.png',
        status: 'Penemuan',
        location: 'FISIP',
        date: '14 Agustus 2024, 08:40',
        type: 'found'),
  ];

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
              const Text(
                'Laptop',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LaptopLainnya(),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0FBD2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Lainnya',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF055C0E),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 320,
          margin: const EdgeInsets.only(bottom: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: laptops.length,
            itemBuilder: (context, index) {
              final laptop = laptops[index];
              return Container(
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
                                    'assets/calendar.png',
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
      ],
    );
  }
}
