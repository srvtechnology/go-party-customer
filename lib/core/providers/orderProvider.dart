import 'dart:developer';

import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/utils/file_open.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:flutter/material.dart';
import '../models/orders.dart';
import '../repo/order.dart' as OrderRepo;

class OrderProvider with ChangeNotifier {
  List<OrderModel> _upcomingData = [];
  List<OrderModel> _deliveredData = [];
  List<OrderModel> get upcomingData => _upcomingData;
  List<OrderModel> get deliveredData => _deliveredData;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  double _rating = 0;
  double get rating => _rating;

  set rating(double value) {
    _rating = value;
    notifyListeners();
  }

  OrderProvider(AuthProvider auth) {
    getUpcomingOrders(auth);
    getDeliveredOrders(auth);
  }

  void startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getUpcomingOrders(AuthProvider auth) async {
    startLoading();
    try {
      _upcomingData = await OrderRepo.getUpcomingOrderItems(auth);
      notifyListeners();
    } catch (e) {
      CustomLogger.error(e);
    }
    stopLoading();
  }

  Future<void> cancelOrder(AuthProvider auth, String payload, String reason) async {
    startLoading();
    try {
      final v = await OrderRepo.cancelOrder(auth, payload, reason);
      if (v) {
        getUpcomingOrders(auth);
      }
    } catch (e) {
      CustomLogger.error(e);
    }
    stopLoading();
  }

  Future<String?> downloadAndOpenInvoicePdf(
      BuildContext context, AuthProvider auth, String payload) async {
    startLoading();
    try {
      final pdfUrl = await OrderRepo.getInvoiceLink(auth, payload);
      if (pdfUrl != null) {
        log("Invoice Link $pdfUrl");
        final file = await getFileFromUrl(pdfUrl);
        openFile(file);
      }
    } catch (e) {
      CustomLogger.error(e);
    }
    stopLoading();
    return null;
  }

  Future<void> getDeliveredOrders(AuthProvider auth) async {
    startLoading();
    try {
      _deliveredData = await OrderRepo.getDeliveredOrderItems(auth);
    } catch (e) {
      CustomLogger.error(e);
    }
    stopLoading();
  }

  Future<bool> rateOrder(AuthProvider auth,
      {required String orderId, rate, feedback}) async {
    startLoading();
    log("RateOrder $orderId");
    try {
      final v = await OrderRepo.rateOrder(auth,
          orderId: orderId, rate: rate, feedback: feedback);
      if (v) {
        getDeliveredOrders(auth);
      }
      return v;
    } catch (e) {
      CustomLogger.error(e);
      return false;
    }
  }

  Future<void> refresh() async {
    _isLoading = true;
    await getUpcomingOrders(AuthProvider());
    await getDeliveredOrders(AuthProvider());
    notifyListeners();
  }
}
