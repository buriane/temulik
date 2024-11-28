import 'package:flutter/material.dart';
import 'package:temulik/ui/components/components.dart';

class PenemuanFormPage extends StatefulWidget {
  const PenemuanFormPage({super.key});

  @override
  State<PenemuanFormPage> createState() => _PenemuanFormPageState();
}

class _PenemuanFormPageState extends State<PenemuanFormPage> {
  String? selectedValue;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedImagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LaporAppBar(
        title: 'Lapor Barang Temuan',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
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
                  hintText: 'Unggah Foto',
                  imagePath: _selectedImagePath,
                  onImageSelected: (String? path) {
                    setState(() {
                      _selectedImagePath = path;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                DatePickerForm(
                  label: 'Tanggal Kehilangan Barang',
                  hintText: 'Pilih Tanggal',
                  selectedDate: _selectedDate, // DateTime? variable
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
                  label: 'no. WhatsApp',
                  hintText: 'format: 08xxxxxxxxxx',
                ),
                SizedBox(height: 16.0),
                InputForm(
                  label: 'Imbalan',
                  hintText: 'ex: Rp. 500.000 (opsional)',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
