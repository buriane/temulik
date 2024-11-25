import 'package:flutter/material.dart';
import 'package:temulik/constants/colors.dart';
import 'package:temulik/ui/components/datas.dart';
import 'package:temulik/ui/components/leaderboard_components.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabLeaderBoard(
      tab1: 'Bulan ini',
      tab2: 'Keseluruhan waktu',
      page1: MonthlyLeaderboard(),
      page2: AllTimeLeaderboard(),
    );
  }
}

class MonthlyLeaderboard extends StatelessWidget {
  const MonthlyLeaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return LeaderboardContent(
      leaderboardData: bulanIniList,
    );
  }
}

class AllTimeLeaderboard extends StatelessWidget {
  const AllTimeLeaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return LeaderboardContent(
      leaderboardData: keseluruhanWaktuList,
    );
  }
}

class LeaderboardContent extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboardData;

  const LeaderboardContent({
    super.key,
    required this.leaderboardData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/pahlawan_gensoed.png',
          width: double.infinity,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
        Expanded(
          child: Container(
            color: AppColors.sky,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: leaderboardData.length,
              itemBuilder: (context, index) {
                final data = leaderboardData[index];
                return LeaderboardCard(
                  rank: data['rank'],
                  name: data['name'],
                  faculty: data['faculty'],
                  points: data['points'],
                  image: data['image'],
                  onTap: () => _showUserDetail(context, data),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showUserDetail(BuildContext context, Map<String, dynamic> userData) {
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
      builder: (context) => UserDetail(userData: userData),
    );
  }
}

class UserDetail extends StatelessWidget {
  final Map<String, dynamic> userData;

  const UserDetail({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        children: [
          _buildHandleBar(),
          const SizedBox(height: 12.0),
          _buildUserProfile(),
        ],
      ),
    );
  }

  Widget _buildHandleBar() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Column(
      children: [
        _buildProfileImage(),
        const SizedBox(height: 12.0),
        _buildUserInfo(),
      ],
    );
  }

  Widget _buildProfileImage() {
    return Container(
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
    );
  }

  Widget _buildUserInfo() {
    const textStyle = TextStyle(
      color: AppColors.dark,
      fontSize: 16,
    );

    return Column(
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
        Text(userData['nim'], style: textStyle),
        const SizedBox(height: 3.0),
        Text(userData['faculty'], style: textStyle),
        const SizedBox(height: 3.0),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              userData['no'],
              style: textStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.open_in_new,
              size: 20,
              color: AppColors.dark,
            ),
          ],
        ),
      ],
    );
  }
}
