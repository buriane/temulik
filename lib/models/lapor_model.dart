import 'package:flutter/material.dart';

class LaporModel {
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
  final String tipe;
  final String userId;
  final String status;

  LaporModel({
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
    required this.tipe,
    required this.userId,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'namaBarang': namaBarang,
      'kategori': kategori,
      'deskripsi': deskripsi,
      'imageUrl': imageUrl,
      'tanggalKehilangan': tanggalKehilangan.toIso8601String(),
      'jamKehilangan': '${jamKehilangan.hour}:${jamKehilangan.minute}',
      'lokasi': lokasi,
      'pinPoint': pinPoint,
      'noWhatsapp': noWhatsapp,
      'imbalan': imbalan,
      'tipe': tipe,
      'userId': userId,
      'status': status,
    };
  }
}
