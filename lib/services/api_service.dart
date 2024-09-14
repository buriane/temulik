import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item.dart';

class ApiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Item>> getItems() async {
    final snapshot = await _firestore.collection('items').get();
    return snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList();
  }

  Future<void> addItem(Item item) async {
    await _firestore.collection('items').add(item.toMap());
  }

// Add more methods as needed
}