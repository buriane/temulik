import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../models/penemuan_model.dart';
import '../repositories/penemuan_repository.dart';

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
      // Upload image first
      // final imageUrl = await _repository.uploadImage(event.fotoBarang);

      // Create model with uploaded image URL
      final penemuan = PenemuanModel(
        namaBarang: event.namaBarang,
        kategori: event.kategori,
        deskripsi: event.deskripsi,
        // fotoBarang: imageUrl,
        tanggalKehilangan: event.tanggalKehilangan,
        jamKehilangan: event.jamKehilangan,
        lokasi: event.lokasi,
        pinPoint: event.pinPoint,
        noWhatsapp: event.noWhatsapp,
        imbalan: event.imbalan,
      );

      // Submit to Firestore
      await _repository.addPenemuan(penemuan);

      emit(PenemuanSuccess());
    } catch (e) {
      emit(PenemuanError(e.toString()));
    }
  }
}
