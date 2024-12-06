import 'package:flutter/material.dart';

class PenemuanModel {
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

  PenemuanModel({
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
    };
  }
}
