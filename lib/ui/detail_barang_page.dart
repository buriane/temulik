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
                _buildRightDetails(context, activityData),
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
            EditButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditFormPage(
                            activityData: activityData,
                            docId: docId,
                          )),
                );
              },
            ),
            const SizedBox(height: 12.0),
            DoneButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoneFormPage(
                      laporId: docId,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12.0),
            CancelButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CancelFormPage(
                      laporId: docId,
                    ),
                  ),
                );
              },
            ),
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
                      await pencarianRef.add(
                        {
                          'laporId': docId,
                          'userId': currentUser?.uid,
                          'createdAt': FieldValue.serverTimestamp(),
                        },
                      );
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

  Widget _buildRightDetails(
      BuildContext context, Map<String, dynamic> activityData) {
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
          Row(
            children: [
              _buildDetailItem(
                'Status Barang',
                _buildStatusBarang(context, activityData),
                isInfo: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBarang(
      BuildContext context, Map<String, dynamic> activityData) {
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

    return GestureDetector(
      onTap: () => _showStatusDetail(context, activityData),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextSmallBold(
              text: activityData['status'] ?? '-',
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusDetail(
      BuildContext context, Map<String, dynamic> activityData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(bottom: 80.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Konten berbeda berdasarkan status
              _buildModalContent(context, activityData),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModalContent(
      BuildContext context, Map<String, dynamic> activityData) {
    switch (activityData['status']) {
      case 'Dalam Proses':
        return _buildDalamProsesModal(docId);
      case 'Selesai':
        return _buildSelesaiModal(context, activityData);
      case 'Dibatalkan':
        return _buildDibatalkanModal(context, activityData);
      default:
        return const SizedBox();
    }
  }

  Widget _buildDalamProsesModal(String docId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pencarian')
          .where('laporId', isEqualTo: docId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Text('Terjadi kesalahan'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(color: AppColors.green),
            ),
          );
        }

        final searches = snapshot.data?.docs ?? [];

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.1),
                  border: Border(
                    bottom: BorderSide(color: AppColors.green.withOpacity(0.2)),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: AppColors.green),
                    const SizedBox(width: 8),
                    TextBold(
                      text: 'Daftar Pengajuan Pencarian',
                      color: AppColors.green,
                    ),
                  ],
                ),
              ),
              searches.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.person_search,
                            size: 48,
                            color: AppColors.green.withOpacity(0.5),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Belum ada yang mencari',
                            style: TextStyle(
                              color: AppColors.green.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: searches.length,
                        itemBuilder: (context, index) {
                          final search =
                              searches[index].data() as Map<String, dynamic>;
                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(search['userId'])
                                .get(),
                            builder: (context, userSnapshot) {
                              if (!userSnapshot.hasData)
                                return const SizedBox();

                              final userData = userSnapshot.data!.data()
                                  as Map<String, dynamic>;
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.green.withOpacity(0.2),
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  leading: CircleAvatar(
                                    radius: 24,
                                    backgroundColor:
                                        AppColors.green.withOpacity(0.1),
                                    backgroundImage: NetworkImage(
                                        userData['photoUrl'] ?? ''),
                                  ),
                                  title: Text(
                                    userData['fullName'] ?? '-',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${userData['nim']} - ${userData['faculty']}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        _formatDateTime(
                                            search['createdAt']?.toDate()),
                                        style: TextStyle(
                                          color:
                                              AppColors.green.withOpacity(0.8),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelesaiModal(
      BuildContext context, Map<String, dynamic> activityData) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(color: AppColors.green.withOpacity(0.2)),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.green),
                const SizedBox(width: 8),
                TextBold(
                  text: 'Detail Penyelesaian',
                  color: AppColors.green,
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              children: [
                if (activityData['evidenceImageUrls']?.isNotEmpty ?? false) ...[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.green.withOpacity(0.2),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CustomImageSlider(
                        imageUrls: activityData['evidenceImageUrls'],
                        height: 200,
                        autoPlay: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                _buildInfoCard(
                  title: 'Informasi Penyelesaian',
                  content: [
                    _buildInfoRow(
                        'Jenis Penemu', activityData['jenisPenemu'] ?? '-'),
                    _buildInfoRow('Tanggal Selesai',
                        activityData['tanggalSelesai'] ?? '-'),
                    _buildInfoRow(
                        'Waktu Selesai', activityData['waktuSelesai'] ?? '-'),
                  ],
                ),
                if (activityData['pahlawan'] != null) ...[
                  const SizedBox(height: 16),
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(activityData['pahlawan'])
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox();

                      final userData =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return _buildInfoCard(
                        title: 'Informasi Pahlawan',
                        content: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.green.withOpacity(0.1),
                              backgroundImage:
                                  NetworkImage(userData['photoUrl'] ?? ''),
                            ),
                            title: Text(
                              userData['fullName'] ?? '-',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${userData['nim']} - ${userData['faculty']}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDibatalkanModal(
      BuildContext context, Map<String, dynamic> activityData) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.red.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(color: AppColors.red.withOpacity(0.2)),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.cancel, color: AppColors.red),
                const SizedBox(width: 8),
                TextBold(
                  text: 'Detail Pembatalan',
                  color: AppColors.red,
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              children: [
                if (activityData['evidenceImageUrls']?.isNotEmpty ?? false) ...[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.red.withOpacity(0.2),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CustomImageSlider(
                        imageUrls: activityData['evidenceImageUrls'],
                        height: 200,
                        autoPlay: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                _buildInfoCard(
                  title: 'Alasan Pembatalan',
                  content: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        activityData['alasanBatal'] ?? '-',
                        style: TextStyle(
                          color: Colors.grey[800],
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                  color: AppColors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> content,
    Color color = AppColors.green,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.darkest,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-';

    // Format tanggal dan waktu ke format yang lebih readable
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = _getIndonesianMonth(dateTime.month);
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day $month $year, $hour:$minute';
  }

  String _getIndonesianMonth(int month) {
    const months = [
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
    return months[month - 1];
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

  Widget _buildDetailItem(String label, dynamic content,
      {bool isInfo = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextTinyMedium(text: label),
            if (isInfo) ...[
              SizedBox(width: 4.0),
              const Icon(
                Icons.info_outline_rounded,
                size: 12.0,
                color: AppColors.darkest,
              ),
            ]
          ],
        ),
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
