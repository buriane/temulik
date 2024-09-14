import 'package:flutter/foundation.dart';
import '../models/item.dart';
import '../services/api_service.dart';

class ItemsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Item> _items = [];
  bool _isLoading = false;

  List<Item> get items => [..._items];
  bool get isLoading => _isLoading;

  Future<void> fetchItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await _apiService.getItems();
    } catch (error) {
      print('Error fetching items: $error');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addItem(Item item) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.addItem(item);
      _items.add(item);
    } catch (error) {
      print('Error adding item: $error');
    }

    _isLoading = false;
    notifyListeners();
  }

// Add more methods as needed (e.g., removeItem, updateItem)
}