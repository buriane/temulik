import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:temulik/models/pahlawan_model.dart';
import '../models/lapor_model.dart';

class LaporRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  LaporRepository(this._firestore, this._storage);

  Future<String> uploadImage(String imagePath) async {
    try {
      // Buat nama file unik dengan timestamp untuk menghindari nama file yang sama
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final originalFileName = path.basename(imagePath);
      final fileName = '${timestamp}_$originalFileName';
      final storageRef = _storage.ref().child('laporan_images/$fileName');

      if (kIsWeb) {
        // Handle upload untuk platform web
        final bytes = await File(imagePath).readAsBytes();
        await storageRef.putData(bytes);
      } else {
        // Handle upload untuk platform mobile
        final file = File(imagePath);
        await storageRef.putFile(file);
      }

      // Setelah upload selesai, dapatkan URL download
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Gagal mengunggah gambar: ${e.toString()}');
    }
  }

  Future<void> addLapor(LaporModel lapor) async {
    try {
      await _firestore.collection('laporan').add(lapor.toMap());
    } catch (e) {
      print('Error adding report: $e');
      throw Exception('Gagal menyimpan laporan: ${e.toString()}');
    }
  }

  Future<void> updateLapor(String id, Map<String, dynamic> data) async {
    try {
      final docRef = _firestore.collection('laporan').doc(id);

      // Cek apakah dokumen ada
      final docSnap = await docRef.get();
      if (!docSnap.exists) {
        throw Exception('Dokumen tidak ditemukan');
      }

      await docRef.update(data);
    } catch (e) {
      print('Error updating report: $e');
      throw Exception('Gagal mengupdate laporan: ${e.toString()}');
    }
  }

  Future<void> completeLapor(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('laporan').doc(id).update(data);
    } catch (e) {
      print('Error completing report: $e');
      throw Exception('Gagal menyelesaikan laporan: ${e.toString()}');
    }
  }

  Future<void> addPahlawan(PahlawanModel pahlawan) async {
    try {
      await _firestore.collection('pahlawan').add(pahlawan.toMap());
    } catch (e) {
      print('Error adding pahlawan: $e');
      throw Exception('Gagal menambahkan pahlawan: ${e.toString()}');
    }
  }
}
