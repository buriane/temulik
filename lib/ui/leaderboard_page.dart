import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:temulik/ui/components/leaderboard_components.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  Widget build(BuildContext context) {
    return TabLeaderBoard(
      tab1: 'Bulan ini',
      tab2: 'Keseluruhan waktu',
      page1: BulanIni(),
      page2: KeseluruhanWaktu(),
    );
  }
}

// Tab Bulan ini
class BulanIni extends StatefulWidget {
  const BulanIni({super.key});

  @override
  State<BulanIni> createState() => _BulanIniState();
}

class _BulanIniState extends State<BulanIni> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image(
        image: AssetImage('assets/pahlawan_gensoed.png'),
      ),
    );
  }
}

// Tab Keseluruhan waktu
class KeseluruhanWaktu extends StatefulWidget {
  const KeseluruhanWaktu({super.key});

  @override
  State<KeseluruhanWaktu> createState() => _KeseluruhanWaktuState();
}

class _KeseluruhanWaktuState extends State<KeseluruhanWaktu> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Keseluruhan waktu'),
    );
  }
}
