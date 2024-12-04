import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/penemuan_model.dart';

class PenemuanRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(String imagePath) async {
    try {
      final File imageFile = File(imagePath);
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference storageRef =
          _storage.ref().child('penemuan_images/$fileName');

      final UploadTask uploadTask = storageRef.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  Future<void> addPenemuan(PenemuanModel penemuan) async {
    try {
      await _firestore.collection('penemuan').add(penemuan.toMap());
    } catch (e) {
      print('Error adding penemuan: $e');
      rethrow;
    }
  }
}
