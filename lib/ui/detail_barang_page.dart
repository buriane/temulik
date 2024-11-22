import 'package:flutter/material.dart';

class DetailBarangPage extends StatelessWidget {
  final Map<String, dynamic> activityData;
  const DetailBarangPage({
    super.key,
    required this.activityData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Barang Hilang',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Text(activityData['date']),
          Text(activityData['time']),
          Text(activityData['item']),
          Text(activityData['category']),
          Text(activityData['name']),
          Text(activityData['status']),
          Text(activityData['lastLocation']),
          Image.asset(activityData['image']),
        ],
      ),
    );
  }
}
