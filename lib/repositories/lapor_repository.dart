import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/lapor_model.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class LaporRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImage(String imagePath) async {
    try {
      // Periksa autentikasi
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User tidak terautentikasi');
      }

      final File imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw Exception('File tidak ditemukan');
      }

      // Compress image
      final File compressedFile = await compressImage(imageFile);

      // Generate unique filename dengan struktur yang lebih jelas
      final String fileName =
          'lapor_${currentUser.uid}_${DateTime.now().millisecondsSinceEpoch}${path.extension(imagePath)}';
      final Reference ref =
          _storage.ref().child('lapor_images/${currentUser.uid}/$fileName');

      // Upload dengan mekanisme retry yang lebih baik
      final UploadTask uploadTask = ref.putFile(
        compressedFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'uploadedBy': currentUser.uid,
            'timestamp': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Tunggu upload selesai
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      // Hapus file sementara
      if (compressedFile.path != imagePath) {
        await compressedFile.delete();
      }

      return downloadUrl;
    } on FirebaseException catch (e) {
      print('Firebase Storage Error: ${e.code} - ${e.message}');
      throw Exception('Gagal mengupload gambar: ${e.message}');
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Gagal mengupload gambar: $e');
    }
  }

  Future<File> compressImage(File file) async {
    final img.Image? image = img.decodeImage(await file.readAsBytes());
    if (image == null) throw Exception('Gagal membaca gambar');

    // Calculate new dimensions while maintaining aspect ratio
    final int maxWidth = 1024;
    final int maxHeight = 1024;

    double ratio = image.width / image.height;
    int newWidth = image.width;
    int newHeight = image.height;

    if (newWidth > maxWidth) {
      newWidth = maxWidth;
      newHeight = (newWidth / ratio).round();
    }

    if (newHeight > maxHeight) {
      newHeight = maxHeight;
      newWidth = (newHeight * ratio).round();
    }

    // Resize image
    final img.Image resizedImage = img.copyResize(
      image,
      width: newWidth,
      height: newHeight,
    );

    // Get temporary directory for saving compressed image
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath =
        path.join(tempDir.path, '${DateTime.now().millisecondsSinceEpoch}.jpg');

    // Save compressed image
    final File compressedFile = File(tempPath);
    await compressedFile.writeAsBytes(img.encodeJpg(resizedImage, quality: 85));

    return compressedFile;
  }

  Future<void> addLapor(LaporModel lapor) async {
    try {
      if (_auth.currentUser == null) {
        throw Exception('User tidak terautentikasi');
      }

      final docRef = await _firestore.collection('lapor').add({
        ...lapor.toMap(),
        'userId': _auth.currentUser!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Document added with ID: ${docRef.id}');
    } catch (e) {
      print('Error adding lapor: $e');
      rethrow;
    }
  }
}
