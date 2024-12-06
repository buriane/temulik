import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../models/penemuan_model.dart';
import '../repositories/penemuan_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'penemuan_event.dart';
part 'penemuan_state.dart';

class PenemuanBloc extends Bloc<PenemuanEvent, PenemuanState> {
  final PenemuanRepository _repository;

  PenemuanBloc(this._repository) : super(PenemuanInitial()) {
    on<SubmitPenemuanEvent>(_onSubmitPenemuan);
  }

  Future<void> _onSubmitPenemuan(
      SubmitPenemuanEvent event, Emitter<PenemuanState> emit) async {
    emit(PenemuanLoading());
    try {
      // Validasi path gambar untuk Android
      if (!kIsWeb &&
          (event.imageUrl.isEmpty || !File(event.imageUrl).existsSync())) {
        throw Exception('Silakan pilih gambar terlebih dahulu');
      }

      // Upload gambar
      final imageUrl = await _repository.uploadImage(event.imageUrl);

      final penemuan = PenemuanModel(
        namaBarang: event.namaBarang,
        kategori: event.kategori,
        deskripsi: event.deskripsi,
        imageUrl: imageUrl,
        tanggalKehilangan: event.tanggalKehilangan,
        jamKehilangan: event.jamKehilangan,
        lokasi: event.lokasi,
        pinPoint: event.pinPoint,
        noWhatsapp: event.noWhatsapp,
        imbalan: event.imbalan,
      );

      await _repository.addPenemuan(penemuan);
      emit(PenemuanSuccess());
    } catch (e) {
      print('Error in bloc: $e');
      emit(PenemuanError(e.toString()));
    }
  }
}
