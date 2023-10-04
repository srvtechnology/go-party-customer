import 'dart:convert';

import 'package:customerapp/config.dart';
import 'package:customerapp/core/features/ccavenues/models/enc_val_res.dart';
import 'package:customerapp/core/features/ccavenues/models/order_res.dart';
import 'package:customerapp/core/models/paymentPostData.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:dio/dio.dart';

import '../models/orders.dart';
import '../utils/dio.dart';

Future<OrderRes?> placeOrder(AuthProvider auth, PaymentPostData payload) async {
  try {
    Response response = await customDioClient.client.post(
        "${APIConfig.baseUrl}/api/customer/address-submit",
        data: {
          "payment_method": payload.paymentMethod,
          "address_id": payload.addressId,
          "current_city": payload.currentCity,
          "full_amount": payload.fullAmount,
          "partial_amount": payload.partialAmount,
        },
        options: Options(headers: {"Authorization": "Bearer ${auth.token}"}));

    final result = json.decode(response.toString());
    OrderRes orderRes = OrderRes.fromJson(result);
    return orderRes;
  } catch (e) {
    if (e is DioException) {
      CustomLogger.error(e.response!.data);
    }
    rethrow;
  }
}

Future<GenerateOrderValue?> generateOrderVal(AuthProvider auth, int orderId,
    {double? amount}) async {
  try {
    Response response = await customDioClient.client.post(
        "${APIConfig.baseUrl}/api/part1-enc",
        data: {
          "order_id": orderId,
        },
        options: Options(headers: {"Authorization": "Bearer ${auth.token}"}));
    GenerateOrderValue generateOrderValue =
        GenerateOrderValue.fromMap(response.data);

    return generateOrderValue;
  } catch (e) {
    if (e is DioException) {
      CustomLogger.error(e.response!.data);
    }
    rethrow;
  }
}

Future<List<OrderModel>> getUpcomingOrderItems(AuthProvider auth) async {
  try {
    Response response = await customDioClient.client.get(
        "${APIConfig.baseUrl}/api/customer-upcoming-order",
        options: Options(headers: {"Authorization": "Bearer ${auth.token}"}));
    List<OrderModel> list = [];
    for (var i in response.data["data"]) {
      try {
        list.add(OrderModel.fromJson(i));
      } catch (e) {
        CustomLogger.error(i);
        CustomLogger.error(e);
      }
    }
    return list;
  } catch (e) {
    if (e is DioException) {
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}

Future<List<OrderModel>> getDeliveredOrderItems(AuthProvider auth) async {
  try {
    Response response = await customDioClient.client.get(
        "${APIConfig.baseUrl}/api/customer-delivered-order",
        options: Options(headers: {"Authorization": "Bearer ${auth.token}"}));
    CustomLogger.debug(response.data);
    List<OrderModel> list = [];
    for (var i in response.data["data"]) {
      list.add(OrderModel.fromJson(i));
    }
    return list;
  } catch (e) {
    if (e is DioException) {
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}
