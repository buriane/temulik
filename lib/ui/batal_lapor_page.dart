import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:temulik/bloc/lapor_bloc.dart';
import 'package:temulik/constants/colors.dart';
import 'package:temulik/repositories/lapor_repository.dart';
import 'package:temulik/ui/components/components.dart';
import 'package:temulik/ui/home_page.dart';

class CancelFormPage extends StatefulWidget {
  final String laporId;

  const CancelFormPage({Key? key, required this.laporId}) : super(key: key);

  @override
  _CancelFormPageState createState() => _CancelFormPageState();
}

class _CancelFormPageState extends State<CancelFormPage> {
  List<String> _selectedImagesPath = [];
  TextEditingController _alasanController = TextEditingController();
  bool _isSubmitting = false;

  late final LaporBloc _laporBloc;

  @override
  void initState() {
    super.initState();
    _laporBloc = LaporBloc(LaporRepository(
      FirebaseFirestore.instance,
      FirebaseStorage.instance,
    ));

    _laporBloc.stream.listen((state) {
      if (state is LaporLoading) {
        setState(() {
          _isSubmitting = true;
        });
      } else if (state is LaporCancelled) {
        setState(() {
          _isSubmitting = false;
        });

        Future.delayed(Duration.zero, () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => SuccessDialog(
              title: 'Berhasil!',
              message: 'Laporan berhasil dibatalkan.',
              iconColor: Colors.white,
              iconBackgroundColor: AppColors.red,
              buttonColor: AppColors.red,
              buttonText: 'OK',
              icon: Icons.thumb_down,
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
            ),
          );
        });
      } else if (state is LaporError) {
        setState(() {
          _isSubmitting = false;
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage)),
        );
      }
    });
  }

  @override
  void dispose() {
    _laporBloc.close();
    _alasanController.dispose();
    super.dispose();
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
          'Batal Pengajuan Barang',
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
              onPressed: _isSubmitting
                  ? null
                  : () {
                      if (_selectedImagesPath.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Harap lampirkan bukti pembatalan barang'),
                          ),
                        );
                        return;
                      }

                      if (_alasanController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Harap isi alasan pembatalan'),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        _isSubmitting = true;
                      });

                      try {
                        _laporBloc.add(CancelLaporEvent(
                          id: widget.laporId,
                          evidenceImageUrls: _selectedImagesPath,
                          alasanBatal: _alasanController.text,
                        ));
                      } catch (e) {
                        setState(() {
                          _isSubmitting = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                          ),
                        );
                      }
                    },
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Batal',
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
                TextAreaForm(
                  label: 'Alasan Pembatalan',
                  hintText: 'Isi alasan pembatalan',
                  controller: _alasanController,
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
