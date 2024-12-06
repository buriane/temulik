import 'package:flutter/material.dart';
import 'package:temulik/constants/colors.dart';
import 'package:temulik/ui/detail_barang_page.dart';

class TabActivity extends StatefulWidget {
  final String tab1;
  final String tab2;
  final Widget page1;
  final Widget page2;

  const TabActivity({
    super.key,
    required this.tab1,
    required this.tab2,
    required this.page1,
    required this.page2,
  });

  @override
  State<TabActivity> createState() => _TabActivityState();
}

class _TabActivityState extends State<TabActivity> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Aktivitas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          elevation: 0,
          bottom: TabBar(
            indicatorColor: AppColors.green,
            indicatorWeight: 3,
            labelColor: AppColors.green,
            unselectedLabelColor: Colors.black,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            tabs: [
              Tab(text: widget.tab1),
              Tab(text: widget.tab2),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            widget.page1,
            widget.page2,
          ],
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final Map<String, dynamic> activityData;

  const ActivityCard({
    super.key,
    required this.activityData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.only(
        top: 12.0,
        left: 12.0,
        right: 12.0,
      ),
      decoration: _buildCardDecoration(),
      child: Column(
        children: [
          _buildTimeDateRow(),
          const SizedBox(height: 12.0),
          _buildItemNameStatusRow(),
        ],
      ),
    );
  }

  Widget _buildTimeDateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TinyMediumText(
            text: activityData['time'],
            color: AppColors.dark,
            fontWeight: FontWeight.normal),
        TinyMediumText(
            text: activityData['date'],
            color: AppColors.dark,
            fontWeight: FontWeight.normal),
      ],
    );
  }

  Widget _buildItemNameStatusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ItemInfo(
            item: activityData['item'],
            status: activityData['status'],
            category: activityData['category']),
        NameAndButton(activityData: activityData),
      ],
    );
  }
}

class ItemInfo extends StatelessWidget {
  final String item;
  final String status;
  final String category;

  const ItemInfo({
    super.key,
    required this.item,
    required this.status,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    String _getCategoryImage() {
      switch (category) {
        case 'Laptop':
          return 'assets/categories/laptop.png';
        case 'Handphone':
          return 'assets/categories/handphone.png';
        case 'Dompet':
          return 'assets/categories/dompet.png';
        case 'Helm':
          return 'assets/categories/helm.png';
        case 'Hewan':
          return 'assets/categories/hewan.png';
        case 'Jam':
          return 'assets/categories/jam.png';
        case 'Kunci':
          return 'assets/categories/kunci.png';
        case 'Kuncikos':
          return 'assets/categories/kuncikos.png';
        case 'Motor':
          return 'assets/categories/motor.png';
        case 'Orang':
          return 'assets/categories/orang.png';
        case 'Powerbank':
          return 'assets/categories/powerbank.png';
        case 'Payung':
          return 'assets/categories/payung.png';
        case 'Sandal':
          return 'assets/categories/sandal.png';
        case 'Sepatu':
          return 'assets/categories/sepatu.png';
        case 'Speaker':
          return 'assets/categories/speaker.png';
        case 'Tas':
          return 'assets/categories/tas.png';
        default:
          return 'assets/categories/lainnya.png';
      }
    }

    return Container(
      height: 64.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(_getCategoryImage(), fit: BoxFit.cover),
          _buildItemTextStatus(),
        ],
      ),
    );
  }

  Widget _buildItemTextStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          item.length > 25 ? item.substring(0, 25) + '...' : item,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        _buildStatusRow(),
      ],
    );
  }

  Widget _buildStatusRow() {
    return Row(
      children: [
        _buildStatusIndicator(),
        const SizedBox(width: 4.0),
        TinyMediumText(
            text: status, color: AppColors.dark, fontWeight: FontWeight.w700),
      ],
    );
  }

  Widget _buildStatusIndicator() {
    Color _getStatusColor() {
      if (status == 'Dalam proses') {
        return AppColors.yellow;
      } else if (status == 'Selesai') {
        return AppColors.green;
      } else {
        return AppColors.red;
      }
    }

    Icon _getStatusIcon() {
      if (status == 'Dalam proses') {
        return const Icon(Icons.search, color: Colors.white, size: 12.0);
      } else if (status == 'Selesai') {
        return const Icon(Icons.check, color: Colors.white, size: 12.0);
      } else {
        return const Icon(Icons.close, color: Colors.white, size: 12.0);
      }
    }

    return Container(
      padding: const EdgeInsets.all(2.0),
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: _getStatusColor()),
      child: _getStatusIcon(),
    );
  }
}

class NameAndButton extends StatelessWidget {
  final Map<String, dynamic> activityData;

  const NameAndButton({
    super.key,
    required this.activityData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Tooltip(
            message: activityData['name'],
            child: Text(
              activityData['name'].length > 15
                  ? activityData['name'].substring(0, 15) + '...'
                  : activityData['name'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return DetailBarangPage(
                      activityData: activityData,
                    );
                  },
                ),
              );
            },
            child: const Text('Lihat Detail'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _buildCardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(6),
    boxShadow: const [
      BoxShadow(
          color: Color.fromARGB(51, 0, 0, 0),
          blurRadius: 8,
          offset: Offset(0, 0)),
    ],
  );
}

class TinyMediumText extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight fontWeight;

  const TinyMediumText({
    super.key,
    required this.text,
    required this.color,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 12.0, fontWeight: fontWeight),
    );
  }
}
