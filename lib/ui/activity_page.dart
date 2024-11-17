import 'package:flutter/material.dart';
import 'package:temulik/ui/components/activity_components.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    return TabActivity(
      tab1: 'Dalam proses',
      tab2: 'Riwayat',
      page1: DalamProses(),
      page2: Riwayat(),
    );
  }
}

class DalamProses extends StatefulWidget {
  const DalamProses({super.key});

  @override
  State<DalamProses> createState() => _DalamProsesState();
}

class _DalamProsesState extends State<DalamProses> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Dalam proses'),
    );
  }
}

class Riwayat extends StatefulWidget {
  const Riwayat({super.key});

  @override
  State<Riwayat> createState() => _RiwayatState();
}

class _RiwayatState extends State<Riwayat> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Riwayat'),
    );
  }
}
