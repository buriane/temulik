part of 'lapor_bloc.dart';

abstract class LaporEvent extends Equatable {
  const LaporEvent();

  @override
  List<Object> get props => [];
}

// Event untuk create baru
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

// Event baru untuk update
class UpdateLaporEvent extends LaporEvent {
  final String id;
  final String namaBarang;
  final String kategori;
  final String deskripsi;
  final List<String> imagePaths;
  final DateTime? tanggalKehilangan;
  final TimeOfDay? jamKehilangan;
  final String lokasi;
  final String pinPoint;
  final String noWhatsapp;
  final String? imbalan;

  const UpdateLaporEvent({
    required this.id,
    required this.namaBarang,
    required this.kategori,
    required this.deskripsi,
    required this.imagePaths,
    this.tanggalKehilangan,
    this.jamKehilangan,
    required this.lokasi,
    required this.pinPoint,
    required this.noWhatsapp,
    this.imbalan,
  });

  @override
  List<Object> get props => [
        id,
        namaBarang,
        kategori,
        deskripsi,
        imagePaths,
        lokasi,
        pinPoint,
        noWhatsapp,
      ];
}

class CompleteLaporEvent extends LaporEvent {
  final String id;
  final String pahlawan;
  final List<String> evidenceImageUrls;
  final DateTime tanggalSelesai;
  final TimeOfDay waktuSelesai;
  final String jenisPenemu;

  CompleteLaporEvent({
    required this.id,
    required this.pahlawan,
    required this.evidenceImageUrls,
    required this.tanggalSelesai,
    required this.waktuSelesai,
    required this.jenisPenemu,
  });
}

class AddPahlawanEvent extends LaporEvent {
  final PahlawanModel pahlawan;

  AddPahlawanEvent({required this.pahlawan});

  @override
  List<Object> get props => [pahlawan];
}
