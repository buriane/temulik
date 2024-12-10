import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:temulik/models/pahlawan_model.dart';
import '../models/lapor_model.dart';
import '../repositories/lapor_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'lapor_event.dart';
part 'lapor_state.dart';

class LaporBloc extends Bloc<LaporEvent, LaporState> {
  final LaporRepository _repository;

  LaporBloc(this._repository) : super(LaporInitial()) {
    on<SubmitLaporEvent>(_onSubmitLapor);
    on<UpdateLaporEvent>(_onUpdateLapor);
    on<CompleteLaporEvent>(_onCompleteLapor);
    on<AddPahlawanEvent>(_onAddPahlawan);
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
        imageUrls: imageUrls,
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
      emit(LaporError(e.toString()));
    }
  }

  Future<void> _onUpdateLapor(
      UpdateLaporEvent event, Emitter<LaporState> emit) async {
    emit(LaporLoading());
    try {
      // Validasi gambar
      if (event.imagePaths.isEmpty) {
        throw Exception('Minimal harus ada 1 gambar');
      }

      // Upload gambar baru jika ada
      List<String> finalImageUrls = [];
      for (String path in event.imagePaths) {
        if (!path.startsWith('http')) {
          // Ini gambar baru, perlu diupload
          final imageUrl = await _repository.uploadImage(path);
          finalImageUrls.add(imageUrl);
        } else {
          // Ini gambar yang sudah ada
          finalImageUrls.add(path);
        }
      }

      // Siapkan data update
      final updatedData = {
        'namaBarang': event.namaBarang,
        'kategori': event.kategori,
        'deskripsi': event.deskripsi,
        'imageUrls': finalImageUrls,
        'tanggalKehilangan': event.tanggalKehilangan?.toIso8601String(),
        'jamKehilangan': event.jamKehilangan != null
            ? '${event.jamKehilangan!.hour.toString().padLeft(2, '0')}:${event.jamKehilangan!.minute.toString().padLeft(2, '0')}'
            : null,
        'lokasi': event.lokasi,
        'pinPoint': event.pinPoint,
        'noWhatsapp': event.noWhatsapp,
        'imbalan': event.imbalan,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Update ke Firestore
      await _repository.updateLapor(event.id, updatedData);
      emit(LaporSuccess());
    } catch (e) {
      emit(LaporError(e.toString()));
    }
  }

  Future<void> _onCompleteLapor(
      CompleteLaporEvent event, Emitter<LaporState> emit) async {
    emit(LaporLoading());
    try {
      // Upload evidence images if they're not already URLs
      List<String> finalImageUrls = [];
      for (String path in event.evidenceImageUrls) {
        if (!path.startsWith('http')) {
          // Upload new image
          final imageUrl = await _repository.uploadImage(path);
          finalImageUrls.add(imageUrl);
        } else {
          // Keep existing URL
          finalImageUrls.add(path);
        }
      }

      final completionData = {
        'status': 'Selesai',
        'pahlawan': event.pahlawan,
        'evidenceImageUrls': finalImageUrls,
        'tanggalSelesai': event.tanggalSelesai.toIso8601String(),
        'waktuSelesai':
            '${event.waktuSelesai.hour.toString().padLeft(2, '0')}:${event.waktuSelesai.minute.toString().padLeft(2, '0')}',
        'jenisPenemu': event.jenisPenemu,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _repository.completeLapor(event.id, completionData);
      emit(LaporSuccess());
    } catch (e) {
      emit(LaporError(e.toString()));
    }
  }

  Future<void> _onAddPahlawan(
      AddPahlawanEvent event, Emitter<LaporState> emit) async {
    emit(LaporLoading());
    try {
      await _repository.addPahlawan(event.pahlawan);
      emit(PahlawanAdded());
    } catch (e) {
      emit(LaporError(e.toString()));
    }
  }
}
