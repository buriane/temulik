import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:temulik/constants/colors.dart';
import 'package:temulik/ui/components/components.dart';

class CancelFormPage extends StatefulWidget {
  @override
  _CancelFormPageState createState() => _CancelFormPageState();
}

class _CancelFormPageState extends State<CancelFormPage> {
  bool _isChecked = false;
  List<String> _selectedImagesPath = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/cancel.svg',
            width: 17.0,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Batal Pencarian Barang',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
              ),
              onPressed: () {},
              child: Text(
                'Selesai',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                InputForm(
                  label: 'Alasan',
                  hintText: 'Kenapa Anda membatalkan pencarian barang?',
                  controller: TextEditingController(),
                ),
                SizedBox(height: 16),
                ImagePickerForm(
                    label: 'Lampiran Bukti',
                    hintText: 'Pilih gambar (maksimal 5)',
                    imagePaths: _selectedImagesPath,
                    onImagesSelected: (List<String> paths) {
                      setState(() {
                        _selectedImagesPath = paths;
                      });
                    }),
                SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value!;
                        });
                      },
                      activeColor: AppColors.blue,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: "Dengan klik tombol ini, kamu menyetujui ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13.0,
                          ),
                          children: [
                            TextSpan(
                              text: "Syarat & Ketentuan",
                              style: TextStyle(
                                color: AppColors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: " serta ",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: "Kebijakan Privasi",
                              style: TextStyle(
                                color: AppColors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: " batal pencarian barang di Temulik.",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
