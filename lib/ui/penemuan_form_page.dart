import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temulik/bloc/auth_bloc.dart';
import 'package:temulik/bloc/penemuan_bloc.dart';
import 'package:temulik/ui/components/components.dart';
import 'package:file_picker/file_picker.dart';
import 'package:temulik/constants/colors.dart';

class PenemuanFormPage extends StatefulWidget {
  const PenemuanFormPage({super.key});

  @override
  State<PenemuanFormPage> createState() => _PenemuanFormPageState();
}

class _PenemuanFormPageState extends State<PenemuanFormPage> {
  String? selectedValue;
  String? selectedValueFakultas;
  String? _selectedFileName;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  // String? _selectedImagePath;
  bool _isChecked = false;

  // Future<void> _pickImageFile() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     type: FileType.image,
  //   );
  //
  //   if (result != null && result.files.isNotEmpty) {
  //     setState(() {
  //       _selectedFileName = result.files.single.name;
  //       _selectedImagePath = result.files.single.path;
  //     });
  //   }
  // }

  final TextEditingController _namaBarangController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _pinPointController = TextEditingController();
  final TextEditingController _noWhatsappController = TextEditingController();
  final TextEditingController _imbalanController = TextEditingController();

  void _submitPenemuan() {
    // Validasi form
    if (_validateForm()) {
      context.read<PenemuanBloc>().add(
            SubmitPenemuanEvent(
              namaBarang: _namaBarangController.text,
              kategori: selectedValue ?? '',
              deskripsi: _deskripsiController.text,
              // fotoBarang: _selectedImagePath ?? '',
              tanggalKehilangan: _selectedDate ?? DateTime.now(),
              jamKehilangan: _selectedTime ?? TimeOfDay.now(),
              lokasi: selectedValueFakultas ?? '',
              pinPoint: _pinPointController.text,
              noWhatsapp: _noWhatsappController.text,
              imbalan: _imbalanController.text.isNotEmpty
                  ? _imbalanController.text
                  : null,
            ),
          );
    }
  }

  bool _validateForm() {
    // if (_selectedImagePath == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Silakan unggah foto barang')),
    //   );
    //   return false;
    // }
    if (selectedValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silakan pilih kategori')),
      );
      return false;
    }
    // Tambahkan validasi lain sesuai kebutuhan

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PenemuanBloc, PenemuanState>(
      listener: (context, state) {
        if (state is PenemuanLoading) {
          // Tampilkan loading indicator
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is PenemuanSuccess) {
          // Tutup loading dan tampilkan sukses
          Navigator.of(context).pop(); // Tutup loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Laporan berhasil dikirim')),
          );
          // Optional: Navigasi ke halaman lain atau reset form
        } else if (state is PenemuanError) {
          // Tutup loading dan tampilkan error
          Navigator.of(context).pop(); // Tutup loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      child: Scaffold(
        appBar: LaporAppBar(
          title: 'Lapor Barang Temuan',
          onSubmit: _submitPenemuan,
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
                  // ImagePickerForm(
                  //   label: 'Foto Barang',
                  //   hintText: _selectedFileName ?? "Unggah Foto",
                  //   imagePath: _selectedImagePath,
                  //   onImageSelected: (String? path) {
                  //     setState(() {
                  //       _selectedImagePath = path;
                  //     });
                  //   },
                  //   onTap: _pickImageFile,
                  // ),
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
                  SelectForm(
                    label: 'Lokasi Terakhir Dilihat',
                    hintText: 'Pilih Lokasi',
                    items: [
                      'Fakultas Pertanian',
                      'Fakultas Biologi',
                      'Fakultas Ekonomi dan Bisnis',
                      'Fakultas Peternakan',
                      'Fakultas Hukum',
                      'Fakultas Ilmu Sosial dan Politik',
                      'Fakultas Kedokteran',
                      'Fakultas Teknik',
                      'Fakultas Ilmu Budaya',
                      'Fakultas Ilmu-Ilmu Kesehatan',
                      'Fakultas Matematika dan Ilmu Pengetahuan Alam',
                      'Fakultas Perikanan dan Ilmu Kelautan',
                    ],
                    value: selectedValueFakultas,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValueFakultas = newValue;
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
                                text: " lapor barang temuan di Temulik.",
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
      ),
    );
  }

  @override
  void dispose() {
    // Jangan lupa dispose controller
    _namaBarangController.dispose();
    _deskripsiController.dispose();
    _pinPointController.dispose();
    _noWhatsappController.dispose();
    _imbalanController.dispose();
    super.dispose();
  }
}
