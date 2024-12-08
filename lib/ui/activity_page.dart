import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:temulik/constants/colors.dart';
import 'package:temulik/ui/components/activity_components.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TabActivity(
      tab1: 'Dalam proses',
      tab2: 'Riwayat',
      page1: const DalamProses(),
      page2: const Riwayat(),
    );
  }
}

class DalamProses extends StatelessWidget {
  const DalamProses({super.key});

  @override
  Widget build(BuildContext context) {
    return const ActivityContent(statusFilter: 'Dalam proses');
  }
}

class Riwayat extends StatelessWidget {
  const Riwayat({super.key});

  @override
  Widget build(BuildContext context) {
    return const ActivityContent(statusFilter: 'Selesai|Dibatalkan');
  }
}

class ActivityContent extends StatelessWidget {
  final String statusFilter;

  const ActivityContent({super.key, required this.statusFilter});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: AppColors.lightGrey,
        child: StreamBuilder<QuerySnapshot>(
          stream: statusFilter == 'Selesai|Dibatalkan'
              ? FirebaseFirestore.instance.collection('laporan').where('status',
                  whereIn: ['Selesai', 'Dibatalkan']).snapshots()
              : FirebaseFirestore.instance
                  .collection('laporan')
                  .where('status', isEqualTo: 'Dalam Proses')
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final documents = snapshot.data?.docs ?? [];
            print('Jumlah dokumen: ${documents.length}');

            if (documents.isEmpty) {
              return const Center(child: Text('Tidak ada data'));
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 40.0),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final data = documents[index].data() as Map<String, dynamic>;
                data['id'] = documents[index].id;
                print('Data $index: $data');
                return ActivityCard(activityData: data);
              },
            );
          },
        ),
      ),
    );
  }
}
