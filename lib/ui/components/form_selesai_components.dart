import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:temulik/constants/colors.dart';
import 'package:file_picker/file_picker.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  String? _selectedPenemu;
  bool _isChecked = false;
  String? _selectedFileName;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _pickImageFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFileName = result.files.single.name;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            TextField(
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: "Siapa yang menemukan?",
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                filled: true,
                fillColor: Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImageFile,
              child: Stack(
                children: [
                  TextField(
                    enabled: false,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: _selectedFileName ?? "Lampiran bukti",
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20.0,
                    top: 10.0,
                    child: Image.asset(
                      'assets/attach.png',
                      width: 14.67,
                      height: 23.04,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Stack(
                children: [
                  TextField(
                    enabled: false,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: _selectedDate != null
                          ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                          : "Pilih Tanggal",
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20.0,
                    top: 10.0,
                    child: Image.asset(
                      'assets/date.png',
                      width: 17.38,
                      height: 19.56,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectTime(context),
              child: Stack(
                children: [
                  TextField(
                    enabled: false, // Disable input manual
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: _selectedTime != null
                          ? _selectedTime!.format(context)
                          : "Pilih Waktu",
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20.0,
                    top: 10.0,
                    child: Image.asset(
                      'assets/time.png',
                      width: 19.56,
                      height: 19.56,
                    ),
                  ),
                ],
              ),
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
    );
  }
}
