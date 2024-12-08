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
  final Map<String, dynamic> activityData;

  const DetailBarangPage({
    super.key,
    required this.activityData,
  });

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          activityData['tipe'] == 'kehilangan'
              ? 'Detail Barang Hilang'
              : 'Detail Barang Temuan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSlider(),
              const SizedBox(height: 20.0),
              _buildItemName(),
              const SizedBox(height: 12.0),
              _buildDetailsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSlider() {
    return CustomImageSlider(
      height: 225.0,
      imageUrls: activityData['imageUrls'] ?? [],
      autoPlay: false,
    );
  }

  Widget _buildItemName() {
    return TextBold(
        text: activityData['namaBarang'] ?? 'Tidak Ada Nama Barang');
  }

  Widget _buildDetailsSection(BuildContext context) {
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
                _buildLeftDetails(context, userData),
                _buildRightDetails(),
              ],
            ),
            const SizedBox(height: 12.0),
            _buildDescription(),
            const SizedBox(height: 12.0),
            _buildReward(),
            const SizedBox(height: 20.0),
            _buildButtons(context),
          ],
        );
      },
    );
  }

  Widget _buildButtons(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final isOwner = currentUserId == activityData['userId'];
    final isSelesai = activityData['status'] == 'Selesai';
    final isBatal = activityData['status'] == 'Batal';

    return Column(
      children: [
        if (!isSelesai && !isBatal) ...[
          if (!isOwner) ...[
            WhatsappButton(phoneNumber: activityData['noWhatsapp']),
            const SizedBox(height: 12.0),
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
                        )),
              );
            }),
            const SizedBox(height: 12.0),
            CancelButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CancelFormPage()),
              );
            }),
          ] else ...[
            AjukanButton(onPressed: () {
              // TODO: Implement claim logic
            }),
          ],
        ],
      ],
    );
  }

  Widget _buildLeftDetails(
      BuildContext context, Map<String, dynamic> userData) {
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

  Widget _buildRightDetails() {
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
          _buildDetailItem('Status Barang', _buildStatusBarang()),
        ],
      ),
    );
  }

  Widget _buildStatusBarang() {
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

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextTinyMedium(text: 'Deskripsi'),
        const SizedBox(height: 4.0),
        TextSmallBold(text: activityData['deskripsi'] ?? '-'),
      ],
    );
  }

  Widget _buildReward() {
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
