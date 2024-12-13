import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:temulik/constants/colors.dart';
import 'package:temulik/ui/batal_lapor_page.dart';
import 'package:temulik/ui/components/components.dart';
import 'package:temulik/ui/edit_form_page.dart';
import 'package:temulik/ui/leaderboard_page.dart';
import 'package:temulik/ui/selesai_lapor_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailBarangPage extends StatelessWidget {
  final String docId;

  const DetailBarangPage({
    super.key,
    required this.docId,
  });

  Future<Map<String, dynamic>> _fetchActivityData() async {
    final docSnapshot =
        await FirebaseFirestore.instance.collection('laporan').doc(docId).get();
    return docSnapshot.data() as Map<String, dynamic>;
  }

  // Fungsi helper untuk format tanggal
  String formatTanggal(String tanggal) {
    try {
      DateTime dateTime = DateTime.parse(tanggal);

      List<String> namaBulan = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember'
      ];

      String hari = dateTime.day.toString().padLeft(2, '0');
      String bulan = namaBulan[dateTime.month - 1];
      String tahun = dateTime.year.toString();

      return '$hari $bulan $tahun';
    } catch (e) {
      return tanggal;
    }
  }

  // Fungsi helper untuk format jam
  String formatJam(String jam) {
    try {
      DateTime dateTime = DateTime.parse(jam);
      String hours = dateTime.hour.toString().padLeft(2, '0');
      String minutes = dateTime.minute.toString().padLeft(2, '0');
      return '$hours:$minutes';
    } catch (e) {
      return jam;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchActivityData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Loading...'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('No Data'),
            ),
            body: const Center(
              child: Text('No Data Available'),
            ),
          );
        }

        final activityData = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              activityData['tipe'] == 'kehilangan'
                  ? 'Detail Barang Hilang'
                  : 'Detail Barang Temuan',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageSlider(activityData),
                  const SizedBox(height: 20.0),
                  _buildItemName(activityData),
                  const SizedBox(height: 12.0),
                  _buildDetailsSection(context, activityData),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSlider(Map<String, dynamic> activityData) {
    return CustomImageSlider(
      height: 225.0,
      imageUrls: activityData['imageUrls'] ?? [],
      autoPlay: false,
    );
  }

  Widget _buildItemName(Map<String, dynamic> activityData) {
    return TextBold(
        text: activityData['namaBarang'] ?? 'Tidak Ada Nama Barang');
  }

  Widget _buildDetailsSection(
      BuildContext context, Map<String, dynamic> activityData) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(activityData['userId'])
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: AppColors.green,
          );
        }

        final userData = snapshot.data?.data() as Map<String, dynamic>? ?? {};

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLeftDetails(context, userData, activityData),
                _buildRightDetails(activityData),
              ],
            ),
            const SizedBox(height: 12.0),
            _buildDescription(activityData),
            const SizedBox(height: 12.0),
            _buildReward(activityData),
            const SizedBox(height: 20.0),
            _buildButtons(context, activityData),
          ],
        );
      },
    );
  }

  Widget _buildButtons(
      BuildContext context, Map<String, dynamic> activityData) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final isOwner = currentUserId == activityData['userId'];
    final isSelesai = activityData['status'] == 'Selesai';
    final isBatal = activityData['status'] == 'Dibatalkan';

    return Column(
      children: [
        if (!isSelesai && !isBatal) ...[
          if (!isOwner) ...[
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(activityData['userId'])
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final ownerName =
                      snapshot.data?.get('fullName') as String? ?? '';
                  return Column(
                    children: [
                      WhatsappButton(
                        phoneNumber: activityData['noWhatsapp'],
                        ownerName: ownerName,
                      ),
                      const SizedBox(height: 12.0),
                    ],
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
          if (isOwner) ...[
            EditButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditFormPage(
                          activityData: activityData,
                        )),
              );
            }),
            const SizedBox(height: 12.0),
            DoneButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoneFormPage(
                    laporId: activityData['id'],
                  ),
                ),
              );
            }),
            const SizedBox(height: 12.0),
            CancelButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CancelFormPage(
                    laporId: activityData['id'],
                  ),
                ),
              );
            }),
          ] else ...[
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('pencarian')
                  .where('laporId', isEqualTo: docId)
                  .where('userId',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                final bool sudahMengajukan =
                    snapshot.hasData && snapshot.data!.docs.isNotEmpty;

                return AjukanButton(
                  isAjukan: !sudahMengajukan,
                  onPressed: () async {
                    final pencarianRef =
                        FirebaseFirestore.instance.collection('pencarian');
                    final currentUser = FirebaseAuth.instance.currentUser;

                    if (sudahMengajukan) {
                      // Hapus dokumen pencarian
                      final docId = snapshot.data!.docs.first.id;
                      await pencarianRef.doc(docId).delete();
                    } else {
                      // Tambah dokumen pencarian baru
                      await pencarianRef.add({
                        'laporId': docId,
                        'userId': currentUser?.uid,
                        'createdAt': FieldValue.serverTimestamp(),
                      });
                    }
                  },
                );
              },
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildLeftDetails(BuildContext context, Map<String, dynamic> userData,
      Map<String, dynamic> activityData) {
    return Flexible(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailItem(
              'Nama Pemilik', _buildOwnerButton(context, userData)),
          const SizedBox(height: 12.0),
          _buildDetailItem('Tanggal Kehilangan',
              formatTanggal(activityData['tanggalKehilangan'])),
          const SizedBox(height: 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextTinyMedium(text: 'Lokasi Terakhir Terlihat'),
              const SizedBox(height: 4.0),
              Container(
                constraints: const BoxConstraints(maxWidth: 200),
                child: Text(
                  activityData['lokasi'] ?? '-',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRightDetails(Map<String, dynamic> activityData) {
    return Flexible(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailItem('Kategori', activityData['kategori'] ?? '-'),
          const SizedBox(height: 12.0),
          _buildDetailItem(
              'Jam Kehilangan', formatJam(activityData['jamKehilangan'])),
          const SizedBox(height: 12.0),
          _buildDetailItem('Status Barang', _buildStatusBarang(activityData)),
        ],
      ),
    );
  }

  Widget _buildStatusBarang(Map<String, dynamic> activityData) {
    Color statusColor;
    switch (activityData['status']) {
      case 'Dalam Proses':
        statusColor = AppColors.yellow;
        break;
      case 'Selesai':
        statusColor = AppColors.green;
        break;
      default:
        statusColor = AppColors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: TextSmallBold(
        text: activityData['status'] ?? '-',
        color: Colors.white,
      ),
    );
  }

  Widget _buildDescription(Map<String, dynamic> activityData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextTinyMedium(text: 'Deskripsi'),
        const SizedBox(height: 4.0),
        TextSmallBold(text: activityData['deskripsi'] ?? '-'),
      ],
    );
  }

  Widget _buildReward(Map<String, dynamic> activityData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextTinyMedium(text: 'Imbalan'),
        const SizedBox(height: 4.0),
        TextSmallBold(text: activityData['imbalan'] ?? '-'),
      ],
    );
  }

  Widget _buildDetailItem(String label, dynamic content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextTinyMedium(text: label),
        const SizedBox(height: 4.0),
        if (content is String)
          TextSmallBold(text: content)
        else if (content is Widget)
          content,
      ],
    );
  }

  Widget _buildOwnerButton(
      BuildContext context, Map<String, dynamic> userInfo) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        overlayColor: Colors.transparent,
      ),
      onPressed: () => _showUserDetail(context, userInfo),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextSmallBold(text: userInfo['fullName'] ?? '-'),
          const SizedBox(width: 4.0),
          Icon(
            Icons.open_in_new,
            size: 16.0,
            color: AppColors.darkest,
          ),
        ],
      ),
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
