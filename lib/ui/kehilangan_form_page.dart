import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temulik/bloc/lapor_bloc.dart';
import 'package:temulik/ui/components/components.dart';
import 'package:temulik/constants/colors.dart';
import 'package:temulik/ui/components/datas.dart';
import 'package:temulik/ui/home_page.dart';

class KehilanganFormPage extends StatefulWidget {
  const KehilanganFormPage({super.key});

  @override
  State<KehilanganFormPage> createState() => _KehilanganFormPageState();
}

class _KehilanganFormPageState extends State<KehilanganFormPage> {
  String? selectedValue;
  String? selectedValueFakultas;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<String> _selectedImages = [];
  bool _isChecked = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _namaBarangController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _pinPointController = TextEditingController();
  final TextEditingController _noWhatsappController = TextEditingController();
  final TextEditingController _imbalanController = TextEditingController();

  void _submitKehilangan() async {
    if (_validateForm()) {
      if (_selectedImages != null) {
        context.read<LaporBloc>().add(
              SubmitLaporEvent(
                namaBarang: _namaBarangController.text,
                kategori: selectedValue ?? '',
                deskripsi: _deskripsiController.text,
                imagePaths: _selectedImages!,
                tanggalKehilangan: _selectedDate ?? DateTime.now(),
                jamKehilangan: _selectedTime ?? TimeOfDay.now(),
                lokasi: selectedValueFakultas ?? '',
                pinPoint: _pinPointController.text,
                noWhatsapp: _noWhatsappController.text,
                imbalan: _imbalanController.text.isNotEmpty
                    ? _imbalanController.text
                    : null,
                tipe: 'kehilangan',
                userId: _auth.currentUser!.uid,
                status: 'Dalam Proses',
              ),
            );
      }
    }
  }

  bool _validateForm() {
    String? errorMessage;

    // Validasi Nama Barang
    if (_namaBarangController.text.isEmpty) {
      errorMessage = 'Nama barang tidak boleh kosong';
    }
    // Validasi Kategori
    else if (selectedValue == null) {
      errorMessage = 'Silakan pilih kategori';
    }
    // Validasi Deskripsi
    else if (_deskripsiController.text.isEmpty) {
      errorMessage = 'Deskripsi barang tidak boleh kosong';
    }
    // Validasi Foto
    else if (_selectedImages.isEmpty) {
      errorMessage = 'Silakan unggah foto barang';
    }
    // Validasi Tanggal
    else if (_selectedDate == null) {
      errorMessage = 'Silakan pilih tanggal penemuan';
    }
    // Validasi Waktu
    else if (_selectedTime == null) {
      errorMessage = 'Silakan pilih waktu penemuan';
    }
    // Validasi Lokasi
    else if (selectedValueFakultas == null) {
      errorMessage = 'Silakan pilih lokasi fakultas';
    }
    // Validasi Pin Point
    else if (_pinPointController.text.isEmpty) {
      errorMessage = 'Silakan tentukan pin point lokasi';
    }
    // Validasi WhatsApp
    else if (_noWhatsappController.text.isEmpty) {
      errorMessage = 'Nomor WhatsApp tidak boleh kosong';
    } else if (!RegExp(r'^08[0-9]{8,11}$')
        .hasMatch(_noWhatsappController.text)) {
      errorMessage = 'Format nomor WhatsApp tidak valid (contoh: 08xxxxxxxxxx)';
    }
    // Validasi Persetujuan
    else if (!_isChecked) {
      errorMessage =
          'Anda harus menyetujui Syarat & Ketentuan serta Kebijakan Privasi';
    }

    // Jika ada error, tampilkan pesan
    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LaporBloc, LaporState>(
      listener: (context, state) {
        if (state is LaporLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(
              child: CircularProgressIndicator(color: AppColors.green),
            ),
          );
        } else if (state is LaporSuccess) {
          Navigator.of(context).pop();

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return SuccessDialog(
                onOkPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(initialIndex: 3),
                    ),
                    (route) => false,
                  );
                },
              );
            },
          );
        } else if (state is LaporError) {
          // Tutup loading dan tampilkan error
          Navigator.of(context).pop(); // Tutup loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: LaporAppBar(
          title: 'Lapor Barang Hilang',
          onSubmit: _submitKehilangan,
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
                    controller: _namaBarangController,
                  ),
                  SizedBox(height: 16.0),
                  SelectForm(
                    label: 'Kategori',
                    hintText: 'Pilih Kategori',
                    items: categories,
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
                    controller: _deskripsiController,
                  ),
                  SizedBox(height: 16.0),
                  ImagePickerForm(
                    label: 'Upload Gambar',
                    hintText: 'Pilih gambar (maksimal 5)',
                    imagePaths: _selectedImages,
                    onImagesSelected: (List<String> paths) {
                      setState(() {
                        _selectedImages = paths;
                      });
                    },
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
                    controller: _pinPointController,
                    initialFaculty: selectedValueFakultas,
                  ),
                  SizedBox(height: 16.0),
                  InputForm(
                    label: 'No. WhatsApp',
                    hintText: 'format: 08xxxxxxxxxx',
                    controller: _noWhatsappController,
                  ),
                  SizedBox(height: 16.0),
                  InputForm(
                    label: 'Imbalan',
                    hintText: 'ex: Rp500.000,00 (opsional)',
                    controller: _imbalanController,
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
      ),
    );
  }
}
