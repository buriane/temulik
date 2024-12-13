import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class ActivityContent extends StatefulWidget {
  final String statusFilter;

  const ActivityContent({super.key, required this.statusFilter});

  @override
  _ActivityContentState createState() => _ActivityContentState();
}

class _ActivityContentState extends State<ActivityContent> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Center(child: Text('User not logged in'));
    }

    return Expanded(
      child: Container(
        color: AppColors.lightGrey,
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          color: AppColors.green,
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _combineData(userId, widget.statusFilter),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print('Error: ${snapshot.error}');
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.green),
                );
              }

              final documents = snapshot.data ?? [];
              print('Jumlah dokumen: ${documents.length}');

              if (documents.isEmpty) {
                return const Center(child: Text('Tidak ada data'));
              }

              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 40.0),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final data = documents[index];
                  print('Data $index: $data');
                  return ActivityCard(
                    activityData: data,
                    docId: data['id'],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Stream<List<Map<String, dynamic>>> _combineData(
      String userId, String statusFilter) async* {
    final laporanStream = (statusFilter == 'Selesai|Dibatalkan')
        ? FirebaseFirestore.instance
            .collection('laporan')
            .where('status', whereIn: ['Selesai', 'Dibatalkan'])
            .where('userId', isEqualTo: userId)
            .snapshots()
        : FirebaseFirestore.instance
            .collection('laporan')
            .where('status', isEqualTo: 'Dalam Proses')
            .where('userId', isEqualTo: userId)
            .snapshots();

    final pencarianStream = FirebaseFirestore.instance
        .collection('pencarian')
        .where('userId', isEqualTo: userId)
        .snapshots();

    await for (var laporanSnapshot in laporanStream) {
      final laporanData = laporanSnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      final pencarianSnapshot =
          await pencarianStream.first; // Get the latest snapshot
      final pencarianData =
          await Future.wait(pencarianSnapshot.docs.map((doc) async {
        final pencarian = doc.data();
        final laporanDoc = await FirebaseFirestore.instance
            .collection('laporan')
            .doc(pencarian['laporId'])
            .get();
        final laporan = laporanDoc.data();
        if (laporan != null) {
          laporan['id'] = laporanDoc.id;
          return laporan;
        }
        return null;
      }).toList());

      final combinedData = [
        ...laporanData,
        ...pencarianData
            .where((data) => data != null)
            .cast<Map<String, dynamic>>()
            .toList()
      ]
          .where((data) => statusFilter == 'Selesai|Dibatalkan'
              ? (data['status'] == 'Selesai' || data['status'] == 'Dibatalkan')
              : data['status'] == 'Dalam Proses')
          .toList();

      yield combinedData;
    }
  }
}
