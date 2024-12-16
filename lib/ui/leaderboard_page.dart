import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:temulik/constants/colors.dart';
import 'package:temulik/ui/components/leaderboard_components.dart';
import 'package:url_launcher/url_launcher.dart';

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
      leaderboardData: 'monthly',
    );
  }
}

class AllTimeLeaderboard extends StatelessWidget {
  const AllTimeLeaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return LeaderboardContent(
      leaderboardData: 'allTime',
    );
  }
}

class LeaderboardContent extends StatelessWidget {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference pahlawan =
      FirebaseFirestore.instance.collection('pahlawan');
  final String leaderboardData;

  LeaderboardContent({
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
            child: StreamBuilder<QuerySnapshot>(
              stream: _getLeaderboardStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: AppColors.green,
                  ));
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.hasData) {
                  return FutureBuilder<List<Map<String, dynamic>>>(
                    future: _processLeaderboardData(snapshot.data!),
                    builder: (context, futureSnapshot) {
                      if (futureSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: AppColors.green,
                        ));
                      }

                      if (futureSnapshot.hasError) {
                        return Center(
                          child: Text('Error: ${futureSnapshot.error}'),
                        );
                      }

                      if (futureSnapshot.hasData) {
                        final leaderboard = futureSnapshot.data!;
                        return ListView.builder(
                          itemCount: leaderboard.length,
                          itemBuilder: (context, index) {
                            var userData = leaderboard[index];
                            return LeaderboardCard(
                              rank: index + 1,
                              name: userData['fullName'],
                              faculty: userData['faculty'],
                              points: userData['points'],
                              image:
                                  userData['photoUrl'] ?? 'assets/profile.png',
                              onTap: () => _showUserDetail(context, userData),
                            );
                          },
                        );
                      }

                      return const Center(child: Text('No Data Available'));
                    },
                  );
                }

                return const Center(child: Text('No Data Available'));
              },
            ),
          ),
        ),
      ],
    );
  }

  Stream<QuerySnapshot> _getLeaderboardStream() {
    if (leaderboardData == 'monthly') {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      return pahlawan
          .where('tanggalSelesai',
              isGreaterThanOrEqualTo: startOfMonth.toIso8601String())
          .snapshots();
    } else {
      return pahlawan.snapshots();
    }
  }

  Future<List<Map<String, dynamic>>> _processLeaderboardData(
      QuerySnapshot snapshot) async {
    final Map<String, int> userPoints = {};
    // Hitung point untuk setiap user
    for (var doc in snapshot.docs) {
      final userId = doc['userId'];
      final tanggalSelesai = DateTime.parse(doc['tanggalSelesai']);
      if (leaderboardData == 'monthly' &&
          tanggalSelesai.isBefore(DateTime.now()
              .subtract(Duration(days: DateTime.now().day - 1)))) {
        continue;
      }
      userPoints[userId] = (userPoints[userId] ?? 0) + 1;
    }

    final List<Map<String, dynamic>> leaderboard = [];
    final usersSnapshot = await users.get();

    // Hanya proses user yang memiliki data lengkap
    for (var userDoc in usersSnapshot.docs) {
      final userData = userDoc.data() as Map<String, dynamic>;

      // Pastikan semua field yang dibutuhkan ada dan tidak null
      if (userData['fullName'] != null && userData['faculty'] != null) {
        userData['points'] = userPoints[userDoc.id] ?? 0;

        // Tambahkan default value untuk field yang mungkin null
        userData['photoUrl'] = userData['photoUrl'] ?? 'assets/profile.png';
        userData['whatsapp'] = userData['whatsapp'] ?? '-';
        userData['nim'] = userData['nim'] ?? '-';

        leaderboard.add(userData);
      }
    }

    // Sort berdasarkan points
    leaderboard.sort((a, b) => b['points'].compareTo(a['points']));
    return leaderboard;
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

  Future<void> _launchWhatsApp(
      BuildContext context, String phoneNumber, String ownerName) async {
    try {
      // Format the phone number
      String formattedPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
      if (!formattedPhone.startsWith('+')) {
        formattedPhone = formattedPhone.startsWith('0')
            ? '+62${formattedPhone.substring(1)}'
            : '+62$formattedPhone';
      }

      // Create WhatsApp URL with a pre-filled message
      final url =
          Uri.parse('https://wa.me/$formattedPhone?text=Halo, $ownerName');

      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Tidak dapat membuka WhatsApp. Pastikan WhatsApp terinstall',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        children: [
          _buildHandleBar(),
          const SizedBox(height: 12.0),
          _buildUserProfile(context),
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

  Widget _buildUserProfile(BuildContext context) {
    return Column(
      children: [
        _buildProfileImage(),
        const SizedBox(height: 12.0),
        _buildUserInfo(context),
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
        backgroundImage: userData['photoUrl'] != null
            ? NetworkImage(userData['photoUrl'])
            : const AssetImage('assets/profile.png') as ImageProvider,
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    const textStyle = TextStyle(
      color: AppColors.dark,
      fontSize: 16,
    );

    return Column(
      children: [
        Text(
          userData['fullName'],
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
        GestureDetector(
          onTap: () => _launchWhatsApp(
              context, userData['whatsapp'], userData['fullName']),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                userData['whatsapp'],
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
        ),
      ],
    );
  }
}
