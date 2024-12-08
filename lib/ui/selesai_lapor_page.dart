import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:temulik/constants/colors.dart';
import 'package:temulik/ui/components/components.dart';

class DoneFormPage extends StatefulWidget {
  @override
  _DoneFormPageState createState() => _DoneFormPageState();
}

class _DoneFormPageState extends State<DoneFormPage> {
  String? _selectedPenemu;
  bool _isChecked = false;
  List<String> _selectedImagesPath = [];
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> users = [];
  bool isLoading = false;

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
          'Selesai Pengajuan Barang',
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            title: Text("Penemu non-Unsoed"),
                            value: "non-Unsoed",
                            groupValue: _selectedPenemu,
                            activeColor: AppColors.green,
                            contentPadding: EdgeInsets.only(left: -20.0),
                            onChanged: (value) {
                              setState(() {
                                _selectedPenemu = value;
                                // Reset pencarian ketika berganti ke non-Unsoed
                                if (value == "non-Unsoed") {
                                  searchController.clear();
                                  users = [];
                                }
                              });
                            },
                          ),
                          RadioListTile<String>(
                            title: Text("Penemu Unsoed"),
                            value: "Unsoed",
                            groupValue: _selectedPenemu,
                            activeColor: AppColors.green,
                            contentPadding: EdgeInsets.only(left: -20.0),
                            onChanged: (value) {
                              setState(() {
                                _selectedPenemu = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                if (_selectedPenemu == "Unsoed") ...[
                  UserSearchDropdown(
                    label: 'Cari Pengguna',
                    hintText: 'Cari berdasarkan nama atau email',
                    controller: searchController,
                    users: users,
                    isLoading: isLoading,
                    onSearch: (query) {
                      if (query.length >= 3) {
                        setState(() => isLoading = true);

                        final nameQuery = FirebaseFirestore.instance
                            .collection('users')
                            .where('fullName', isGreaterThanOrEqualTo: query)
                            .where('fullName',
                                isLessThanOrEqualTo: query + '\uf8ff')
                            .get();

                        final emailQuery = FirebaseFirestore.instance
                            .collection('users')
                            .where('email', isGreaterThanOrEqualTo: query)
                            .where('email',
                                isLessThanOrEqualTo: query + '\uf8ff')
                            .get();

                        Future.wait([nameQuery, emailQuery]).then((results) {
                          final nameResults = results[0].docs;
                          final emailResults = results[1].docs;

                          final Map<String, Map<String, dynamic>> uniqueUsers =
                              {};

                          for (var doc in nameResults) {
                            uniqueUsers[doc.id] = {
                              ...doc.data(),
                              'id': doc.id,
                            };
                          }

                          for (var doc in emailResults) {
                            uniqueUsers[doc.id] = {
                              ...doc.data(),
                              'id': doc.id,
                            };
                          }

                          setState(() {
                            users = uniqueUsers.values.toList();
                            isLoading = false;
                          });
                        });
                      } else {
                        setState(() => users = []);
                      }
                    },
                    onUserSelected: (user) {
                      print(
                          'Selected user: ${user['fullName']} (${user['email']})');
                      setState(() => users = []);
                    },
                  ),
                  SizedBox(height: 16),
                ],
                ImagePickerForm(
                    label: 'Lampiran bukti',
                    hintText: 'Pilih gambar (maksimal 5)',
                    imagePaths: _selectedImagesPath,
                    onImagesSelected: (List<String> path) {
                      setState(() {
                        _selectedImagesPath = path;
                      });
                    }),
                SizedBox(height: 16),
                DatePickerForm(
                  label: 'Tanggal Penemuan Barang',
                  hintText: 'Pilih Tanggal',
                  selectedDate: _selectedDate,
                  onChanged: (DateTime? date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
                SizedBox(height: 16),
                TimePickerForm(
                  label: 'Waktu Penemuan Barang',
                  hintText: 'Pilih Waktu',
                  selectedTime: _selectedTime,
                  onChanged: (TimeOfDay? time) {
                    setState(() {
                      _selectedTime = time;
                    });
                  },
                ),
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
                              text: " pengajuan barang di Temulik.",
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
