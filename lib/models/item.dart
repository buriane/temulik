import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime date;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
  });

  factory Item.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Item(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'date': Timestamp.fromDate(date),
    };
  }
}