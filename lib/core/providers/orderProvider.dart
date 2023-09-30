import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:flutter/material.dart';
import '../models/orders.dart';
import '../repo/order.dart' as OrderRepo;

class OrderProvider with ChangeNotifier{
  List<OrderModel> _upcomingData=[];
  List<OrderModel> _deliveredData=[];
  List<OrderModel> get upcomingData=> _upcomingData;
  List<OrderModel> get deliveredData=> _deliveredData;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  OrderProvider(AuthProvider auth){
    getUpcomingOrders(auth);
    getDeliveredOrders(auth);
  }
  void startLoading(){
    _isLoading = true;
    notifyListeners();
  }
  void stopLoading(){
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getUpcomingOrders(AuthProvider auth)async{
    startLoading();
    try{
      _upcomingData = await OrderRepo.getUpcomingOrderItems(auth);
    }catch(e){
      CustomLogger.error(e);
    }
    stopLoading();
  }
  Future<void> getDeliveredOrders(AuthProvider auth)async{
    startLoading();
    try{
      _deliveredData = await OrderRepo.getDeliveredOrderItems(auth);
    }catch(e){
      CustomLogger.error(e);
    }
    stopLoading();
  }
}