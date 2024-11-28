import 'package:flutter/material.dart';
import 'package:temulik/ui/components/components.dart';
import 'package:file_picker/file_picker.dart';
import 'package:temulik/constants/colors.dart';

class KehilanganFormPage extends StatefulWidget {
  const KehilanganFormPage({super.key});

  @override
  State<KehilanganFormPage> createState() => _KehilanganFormPageState();
}

class _KehilanganFormPageState extends State<KehilanganFormPage> {
  String? selectedValue;
  String? _selectedFileName;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedImagePath;
  bool _isChecked = false;

  Future<void> _pickImageFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFileName = result.files.single.name;
        _selectedImagePath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LaporAppBar(
        title: 'Lapor Barang Hilang',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            left: 20.0,
            right: 20.0,
            bottom: 20.0,
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                InputForm(
                  label: 'Nama Barang',
                  hintText: 'ex: Iphone 12 Pro Max',
                ),
                SizedBox(height: 16.0),
                SelectForm(
                  label: 'Kategori',
                  hintText: 'Pilih Kategori',
                  items: [
                    'Elektronik',
                    'Buku',
                    'Pakaian',
                    'Lainnya',
                  ],
                  value: selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                TextAreaForm(
                  label: 'Deskripsi',
                  hintText: 'ex: ukuran, ciri khas, atau tanda pengenal',
                  maxLength: 100,
                  onChanged: (value) {
                    print(value);
                  },
                ),
                SizedBox(height: 16.0),
                ImagePickerForm(
                  label: 'Foto Barang',
                  hintText: _selectedFileName ?? "Unggah Foto",
                  imagePath: _selectedImagePath,
                  onImageSelected: (String? path) {
                    setState(() {
                      _selectedImagePath = path;
                    });
                  },
                  onTap: _pickImageFile,
                ),
                SizedBox(height: 16.0),
                DatePickerForm(
                  label: 'Tanggal Kehilangan Barang',
                  hintText: 'Pilih Tanggal',
                  selectedDate: _selectedDate,
                  onChanged: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                TimePickerForm(
                  label: 'Jam Kehilangan Barang',
                  hintText: 'Pilih Jam',
                  selectedTime: _selectedTime,
                  onChanged: (time) {
                    setState(() {
                      _selectedTime = time;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                PinPointInput(
                  label: 'Pin Point',
                  hintText: 'Tentukan Pin Point Lokasi',
                ),
                SizedBox(height: 16.0),
                InputForm(
                  label: 'No. WhatsApp',
                  hintText: 'format: 08xxxxxxxxxx',
                ),
                SizedBox(height: 16.0),
                InputForm(
                  label: 'Imbalan',
                  hintText: 'ex: Rp500.000,00 (opsional)',
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
                              text: " lapor barang hilang di Temulik.",
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
