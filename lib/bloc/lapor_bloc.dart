import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../models/lapor_model.dart';
import '../repositories/lapor_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'lapor_event.dart';
part 'lapor_state.dart';

class LaporBloc extends Bloc<LaporEvent, LaporState> {
  final LaporRepository _repository;

  LaporBloc(this._repository) : super(LaporInitial()) {
    on<SubmitLaporEvent>(_onSubmitLapor);
  }

  Future<void> _onSubmitLapor(
      SubmitLaporEvent event, Emitter<LaporState> emit) async {
    emit(LaporLoading());
    try {
      // Validasi path gambar untuk Android
      if (!kIsWeb) {
        for (String path in event.imagePaths) {
          if (path.isEmpty || !File(path).existsSync()) {
            throw Exception('Ada gambar yang tidak valid');
          }
        }
      }

      if (event.imagePaths.isEmpty) {
        throw Exception('Silakan pilih minimal 1 gambar');
      }

      if (event.imagePaths.length > 5) {
        throw Exception('Maksimal 5 gambar yang dapat diunggah');
      }

      // Upload semua gambar
      List<String> imageUrls = [];
      for (String path in event.imagePaths) {
        final imageUrl = await _repository.uploadImage(path);
        imageUrls.add(imageUrl);
      }

      final penemuan = LaporModel(
        namaBarang: event.namaBarang,
        kategori: event.kategori,
        deskripsi: event.deskripsi,
        imageUrls: imageUrls, // Gunakan list URL gambar
        tanggalKehilangan: event.tanggalKehilangan,
        jamKehilangan: event.jamKehilangan,
        lokasi: event.lokasi,
        pinPoint: event.pinPoint,
        noWhatsapp: event.noWhatsapp,
        imbalan: event.imbalan,
        tipe: event.tipe,
        userId: event.userId,
        status: event.status,
      );

      await _repository.addLapor(penemuan);
      emit(LaporSuccess());
    } catch (e) {
      print('Error in bloc: $e');
      emit(LaporError(e.toString()));
    }
  }
}
