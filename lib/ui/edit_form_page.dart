import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temulik/bloc/lapor_bloc.dart';
import 'package:temulik/repositories/lapor_repository.dart';
import 'package:temulik/ui/components/components.dart';
import 'package:temulik/constants/colors.dart';
import 'package:temulik/ui/components/datas.dart';
import 'package:temulik/ui/home_page.dart';

class EditFormPage extends StatefulWidget {
  final Map<String, dynamic> activityData;

  const EditFormPage({
    super.key,
    required this.activityData,
  });

  @override
  State<EditFormPage> createState() => _EditFormPageState();
}

class _EditFormPageState extends State<EditFormPage> {
  String? selectedValue;
  String? selectedValueFakultas;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<String> _selectedImages = [];
  bool _isChecked = false;
  late final LaporBloc _laporBloc;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _namaBarangController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _pinPointController = TextEditingController();
  final TextEditingController _noWhatsappController = TextEditingController();
  final TextEditingController _imbalanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _laporBloc = BlocProvider.of<LaporBloc>(context);
    _namaBarangController.text = widget.activityData['namaBarang'] ?? '';
    _deskripsiController.text = widget.activityData['deskripsi'] ?? '';
    _pinPointController.text = widget.activityData['pinPoint'] ?? '';
    _noWhatsappController.text = widget.activityData['noWhatsapp'] ?? '';
    _imbalanController.text = widget.activityData['imbalan'] ?? '';

    selectedValue = widget.activityData['kategori'];
    selectedValueFakultas = widget.activityData['lokasi'];
    _selectedImages = List<String>.from(widget.activityData['imageUrls'] ?? []);

    if (widget.activityData['tanggalKehilangan'] != null) {
      _selectedDate = DateTime.parse(widget.activityData['tanggalKehilangan']);
    }

    if (widget.activityData['jamKehilangan'] != null) {
      final jamArray = widget.activityData['jamKehilangan'].split(':');
      if (jamArray.length == 2) {
        _selectedTime = TimeOfDay(
            hour: int.parse(jamArray[0]), minute: int.parse(jamArray[1]));
      }
    }
  }

  Future<void> _updateBarang() async {
    if (_validateForm()) {
      _laporBloc.add(UpdateLaporEvent(
        id: widget.activityData['id'],
        namaBarang: _namaBarangController.text,
        kategori: selectedValue!,
        deskripsi: _deskripsiController.text,
        imagePaths: _selectedImages,
        tanggalKehilangan: _selectedDate,
        jamKehilangan: _selectedTime,
        lokasi: selectedValueFakultas!,
        pinPoint: _pinPointController.text,
        noWhatsapp: _noWhatsappController.text,
        imbalan: _imbalanController.text,
      ));
    }
  }

  bool _validateForm() {
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan unggah foto barang')),
      );
      return false;
    }
    if (selectedValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih kategori')),
      );
      return false;
    }
    if (_namaBarangController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama barang tidak boleh kosong')),
      );
      return false;
    }
    if (_deskripsiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deskripsi tidak boleh kosong')),
      );
      return false;
    }
    if (selectedValueFakultas == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih lokasi')),
      );
      return false;
    }
    if (_noWhatsappController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nomor WhatsApp tidak boleh kosong')),
      );
      return false;
    }
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Anda harus menyetujui syarat dan ketentuan')),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LaporBloc, LaporState>(
      bloc: _laporBloc,
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
          Navigator.of(context).pop(); // tutup loading
          // Tampilkan dialog sukses
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 340),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreen,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: AppColors.green,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Sukses!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkest,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Perubahan berhasil disimpan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.dark.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const HomePage(initialIndex: 3),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text(
                            'OK',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (state is LaporError) {
          Navigator.of(context).pop(); // tutup loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      child: Scaffold(
        appBar: LaporAppBar(
          title: 'Edit Informasi Barang',
          onSubmit: _updateBarang,
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
                                text:
                                    " pengubahan informasi barang di Temulik.",
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
    _namaBarangController.dispose();
    _deskripsiController.dispose();
    _pinPointController.dispose();
    _noWhatsappController.dispose();
    _imbalanController.dispose();
    super.dispose();
  }
}
