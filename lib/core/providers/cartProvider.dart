import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../repo/cart.dart' as cartRepo;

class CartProvider with ChangeNotifier{
  List<CartModel> _data=[];
  List<String> _serviceIds =[];
  List<String> get serviceIds => _serviceIds;
  List<CartModel> get data=> _data;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  CartProvider(AuthProvider auth){
    getCategories(auth);
  }
  void startLoading(){
    _isLoading = true;
    notifyListeners();
  }
  void stopLoading(){
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getCategories(AuthProvider auth)async{
    startLoading();
    try{
      _data = await cartRepo.getCartItems(auth);
      for(var i in data){
        _serviceIds.add(i.service.id);
      }
    }catch(e){
      CustomLogger.error(e);
    }
    stopLoading();
  }
}