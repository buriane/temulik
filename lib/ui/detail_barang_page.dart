import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:temulik/constants/colors.dart';
import 'package:temulik/ui/components/components.dart';
import 'package:temulik/ui/leaderboard_page.dart';

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
              _buildDetailsSection(context, activityData['user']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSlider() {
    return CustomImageSlider(
      height: 225.0,
      imageUrls: activityData['image'] ?? [],
      autoPlay: false,
    );
  }

  Widget _buildItemName() {
    return TextBold(text: activityData['item'] ?? 'Tidak Ada Nama Barang');
  }

  Widget _buildDetailsSection(
      BuildContext context, Map<String, dynamic> userInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLeftDetails(context, userInfo),
            _buildRightDetails(),
          ],
        ),
        const SizedBox(height: 12.0),
        _buildDescription(),
        const SizedBox(height: 12.0),
        _buildReward(),
        const SizedBox(height: 20.0),
        _buildButtons(),
      ],
    );
  }

  Widget _buildLeftDetails(
      BuildContext context, Map<String, dynamic> userInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailItem('Nama Pemilik', _buildOwnerButton(context, userInfo)),
        const SizedBox(height: 12.0),
        _buildDetailItem(
            'Tanggal Kehilangan', activityData['date']?.toString() ?? '-'),
        const SizedBox(height: 12.0),
        _buildDetailItem('Lokasi Terakhir Terlihat',
            activityData['lastLocation']?.toString() ?? '-'),
      ],
    );
  }

  Widget _buildRightDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailItem(
            'Kategori', activityData['category']?.toString() ?? '-'),
        const SizedBox(height: 12.0),
        _buildDetailItem(
            'Jam Kehilangan', activityData['time']?.toString() ?? '-'),
        const SizedBox(height: 12.0),
        _buildDetailItem('Status Barang', _buildStatusBarang()),
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
          TextSmallBold(text: activityData['name'] ?? '-'),
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

  Widget _buildStatusBarang() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: TextSmallBold(
        text: activityData['statusBarang'] ?? '-',
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
        TextSmallBold(text: 'Ada sticker MU di spakbor belakang'),
      ],
    );
  }

  Widget _buildReward() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextTinyMedium(text: 'Imbalan'),
        const SizedBox(height: 4.0),
        TextSmallBold(text: 'Uang tunai 200rb rupiah'),
      ],
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        WhatsappButton(onPressed: () {}),
        const SizedBox(height: 12.0),
        DoneButton(onPressed: () {}),
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
