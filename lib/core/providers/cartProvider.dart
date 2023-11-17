import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../repo/cart.dart' as cartRepo;

class CartProvider with ChangeNotifier {
  List<CartModel> _data = [];
  double _totalPrice = 0;
  double get totalPrice => _totalPrice;
  final List<String> _serviceIds = [];
  List<String> get serviceIds => _serviceIds;
  List<CartModel> get data => _data;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  CartProvider(AuthProvider auth) {
    getCart(auth);
  }
  void startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  void calculateTotal() {
    startLoading();
    _totalPrice = 0;
    for (var i in _data) {
      _totalPrice += double.parse(i.totalPrice);
    }
    stopLoading();
  }

  Future<void> getCart(AuthProvider auth) async {
    startLoading();
    try {
      _data = await cartRepo.getCartItems(auth);

      for (var i in data) {
        _serviceIds.add(i.service.id);
      }
      calculateTotal();
    } catch (e) {
      CustomLogger.error(e);
    }
    stopLoading();
  }
}
