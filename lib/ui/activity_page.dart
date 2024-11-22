import 'package:flutter/material.dart';
import 'package:temulik/constants/colors.dart';
import 'package:temulik/ui/components/activity_components.dart';
import 'package:temulik/ui/components/datas.dart';

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
    // Filter data
    List<Map<String, dynamic>> filteredActivities =
        activities.where((activity) {
      if (statusFilter == 'Selesai|Dibatalkan') {
        return activity['status'] == 'Selesai' ||
            activity['status'] == 'Dibatalkan';
      }
      return activity['status'] == statusFilter;
    }).toList();

    return Expanded(
      child: Container(
        color: AppColors.lightGrey,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: filteredActivities.length,
          itemBuilder: (context, index) {
            final data = filteredActivities[index];
            return ActivityCard(
              date: data['date'],
              time: data['time'],
              item: data['item'],
              category: data['category'],
              name: data['name'],
              status: data['status'],
            );
          },
        ),
      ),
    );
  }
}
