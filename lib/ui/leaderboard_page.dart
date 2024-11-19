import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:temulik/constants/colors.dart';
import 'package:temulik/ui/components/datas.dart';
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
  BulanIni({super.key});

  @override
  State<BulanIni> createState() => _BulanIniState();
}

class _BulanIniState extends State<BulanIni> {
  void _showLeaderboardBottomSheet(
      BuildContext context, Map<String, dynamic> userData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      builder: (context) => LeaderboardDetail(userData: userData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'pahlawan_gensoed.png',
          width: double.infinity,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
        Expanded(
          child: Container(
            // padding: const EdgeInsets.only(bottom: 6.0),
            color: AppColors.sky,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: bulanIniList.length,
              itemBuilder: (context, index) {
                final leaderboard = bulanIniList[index];
                return LeaderboardCard(
                  rank: leaderboard['rank'],
                  name: leaderboard['name'],
                  faculty: leaderboard['faculty'],
                  points: leaderboard['points'],
                  image: leaderboard['image'],
                  onTap: () =>
                      _showLeaderboardBottomSheet(context, leaderboard),
                );
              },
            ),
          ),
        ),
      ],
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
  void _showLeaderboardBottomSheet(
      BuildContext context, Map<String, dynamic> userData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      builder: (context) => LeaderboardDetail(userData: userData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'pahlawan_gensoed.png',
          width: double.infinity,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
        Expanded(
          child: Container(
            // padding: const EdgeInsets.only(bottom: 6.0),
            color: AppColors.sky,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: keseluruhanWaktuList.length,
              itemBuilder: (context, index) {
                final leaderboard = keseluruhanWaktuList[index];
                return LeaderboardCard(
                  rank: leaderboard['rank'],
                  name: leaderboard['name'],
                  faculty: leaderboard['faculty'],
                  points: leaderboard['points'],
                  image: leaderboard['image'],
                  onTap: () =>
                      _showLeaderboardBottomSheet(context, leaderboard),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class LeaderboardDetail extends StatelessWidget {
  final Map<String, dynamic> userData;

  const LeaderboardDetail({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        children: [
          // Handle bar indicator
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12.0),
          Column(
            children: [
              Container(
                width: 120.0,
                height: 120.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.green,
                    width: 4.0,
                  ),
                ),
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundImage: AssetImage(userData['image']),
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12.0),
              Column(
                children: [
                  Text(
                    userData['name'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Column(
                    children: [
                      Text(
                        userData['nim'],
                        style: TextStyle(
                          color: AppColors.dark,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      Text(
                        userData['faculty'],
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.dark,
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            userData['no'],
                            style: TextStyle(
                              color: AppColors.dark,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.open_in_new,
                            size: 20,
                            color: AppColors.dark,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
