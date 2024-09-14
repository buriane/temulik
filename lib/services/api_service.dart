import '../models/item.dart';

class ApiService {
  Future<List<Item>> getItems() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Return mock data
    return [
      Item(
        id: '1',
        title: 'Lost Wallet',
        description: 'Brown leather wallet lost near the library',
        location: 'Central Library',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Item(
        id: '2',
        title: 'Found Keys',
        description: 'Set of keys found in the parking lot',
        location: 'Main Parking Lot',
        date: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
  }

  Future<void> addItem(Item item) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // In a real app, you would send the item to a server here
    print('Item added: ${item.title}');
  }

  // Add more methods as needed (e.g., updateItem, deleteItem)
}