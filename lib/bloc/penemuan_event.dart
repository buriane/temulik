part of 'penemuan_bloc.dart';

abstract class PenemuanEvent extends Equatable {
  const PenemuanEvent();

  @override
  List<Object> get props => [];
}

class SubmitPenemuanEvent extends PenemuanEvent {
  final String namaBarang;
  final String kategori;
  final String deskripsi;
  final String imageUrl;
  final DateTime tanggalKehilangan;
  final TimeOfDay jamKehilangan;
  final String lokasi;
  final String pinPoint;
  final String noWhatsapp;
  final String? imbalan;

  const SubmitPenemuanEvent({
    required this.namaBarang,
    required this.kategori,
    required this.deskripsi,
    required this.imageUrl,
    required this.tanggalKehilangan,
    required this.jamKehilangan,
    required this.lokasi,
    required this.pinPoint,
    required this.noWhatsapp,
    this.imbalan,
  });

  @override
  List<Object> get props => [
        namaBarang,
        kategori,
        deskripsi,
        imageUrl,
        tanggalKehilangan,
        jamKehilangan,
        lokasi,
        pinPoint,
        noWhatsapp
      ];
}
