import 'package:flutter/material.dart';
import 'package:shoesly_flutter/core/models/cart_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem({
    required String name,
    required double price,
    required String color,
    required double shoeSize,
    required int quantity,
    required String imageUrl,
    required String brand,
  }) {
    final existingItemIndex = _items.indexWhere((item) =>
        item.name == name &&
        item.color == color &&
        item.shoeSize == shoeSize &&
        item.brand == brand);
    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        name: name,
        price: price,
        color: color,
        shoeSize: shoeSize,
        quantity: quantity,
        imageUrl: imageUrl,
        brand: brand,
      ));
    }
    notifyListeners();
  }

  void updateQuantity(CartItem item, int quantity) {
    final itemIndex = _items.indexWhere((i) =>
        i.name == item.name &&
        i.color == item.color &&
        i.shoeSize == item.shoeSize &&
        i.brand == item.brand);
    if (itemIndex >= 0) {
      _items[itemIndex].quantity = quantity;
      if (_items[itemIndex].quantity <= 0) {
        _items.removeAt(itemIndex);
      }
      notifyListeners();
    }
  }

  void deleteItem(CartItem item) {
    _items.removeWhere((i) =>
        i.name == item.name &&
        i.color == item.color &&
        i.shoeSize == item.shoeSize &&
        i.brand == item.brand);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double calculateTotalPrice() {
    double total = 0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }
}
