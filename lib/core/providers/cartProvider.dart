import 'dart:developer';

import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/cartModel.dart';
import '../repo/cartRepo.dart' as cartRepo;

class CartProvider with ChangeNotifier {
  List<CartModel> _data = [];
  double _totalPrice = 0;
  double get totalPrice => _totalPrice;
  final List<String> _serviceIds = [];
  List<String> get serviceIds => _serviceIds;
  List<CartModel> get data => _data;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  CartProvider({AuthProvider? auth}) {
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

  Future<void> getCart(AuthProvider? auth) async {
    log("GET CART CALL");
    if (auth == null &&
        auth!.authState != AuthState.LoggedIn &&
        auth.user == null) {
      log("GET CART CALL FAILED");
      return;
    }
    startLoading();
    try {
      _data = await cartRepo.getCartItems(auth);
      log(_data.toString());
      if (kDebugMode) {
        print("Cart : ${data.toString()}");
      }
      for (var i in data) {
        _serviceIds.add(i.service.id);
      }
      calculateTotal();
    } catch (e) {
      log(e.toString());
      _data = [];
    }
    stopLoading();
    notifyListeners();
  }

  Future<void> refresh() async {
    startLoading();
    try {
      _data = await cartRepo.getCartItems(AuthProvider());
      calculateTotal();
    } catch (e) {
      CustomLogger.error(e);
    }
    stopLoading();
  }

  Future init(AuthProvider? auth) async {
    await getCart(auth);
  }
}
