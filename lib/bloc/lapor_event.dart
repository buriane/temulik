part of 'lapor_bloc.dart';

abstract class LaporEvent extends Equatable {
  const LaporEvent();

  @override
  List<Object> get props => [];
}

class SubmitLaporEvent extends LaporEvent {
  final String namaBarang;
  final String kategori;
  final String deskripsi;
  final List<String> imagePaths;
  final DateTime tanggalKehilangan;
  final TimeOfDay jamKehilangan;
  final String lokasi;
  final String pinPoint;
  final String noWhatsapp;
  final String? imbalan;
  final String tipe;
  final String userId;
  final String status;

  const SubmitLaporEvent({
    required this.namaBarang,
    required this.kategori,
    required this.deskripsi,
    required this.imagePaths,
    required this.tanggalKehilangan,
    required this.jamKehilangan,
    required this.lokasi,
    required this.pinPoint,
    required this.noWhatsapp,
    this.imbalan,
    required this.tipe,
    required this.userId,
    required this.status,
  });

  @override
  List<Object> get props => [
        namaBarang,
        kategori,
        deskripsi,
        imagePaths,
        tanggalKehilangan,
        jamKehilangan,
        lokasi,
        pinPoint,
        noWhatsapp,
        tipe,
        userId,
        status,
      ];
}
