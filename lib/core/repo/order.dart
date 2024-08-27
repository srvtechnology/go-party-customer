import 'dart:convert';
import 'dart:developer';

import 'package:customerapp/config.dart';
import 'package:customerapp/core/features/ccavenues/models/enc_val_res.dart';
import 'package:customerapp/core/features/ccavenues/models/order_res.dart';
import 'package:customerapp/core/models/paymentPostData.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/orders.dart';
import '../utils/dio.dart';

Future<OrderRes?> placeOrder(AuthProvider auth, PaymentPostData payload) async {
  try {
    if (kDebugMode) {
      print({
        "payment_method": payload.paymentMethod,
        "address_id": payload.addressId,
        "current_city": payload.currentCity,
        "full_amount": payload.fullAmount,
        "partial_amount": payload.partialAmount,
      });
    }
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

Future<Map> placeOrderAgent(
  AuthProvider auth, {
  required String payment_method,
  required String payment_type,
  required String txn_id,
  required String address_id,
  required String current_city,
}) async {
  try {
    Response response = await customDioClient.client.post(
        "${APIConfig.baseUrl}/api/agent/payment",
        data: {
          "payment_method": payment_method,
          "payment_type": payment_type,
          "txn_id": txn_id,
          "address_id": address_id,
          "current_city": current_city,
        },
        options: Options(headers: {"Authorization": "Bearer ${auth.token}"}));

    final result = jsonDecode(response.toString());
    log(jsonEncode(result), name: "placeOrderAgent");
    return result;
  } catch (e) {
    if (e is DioException) {
      CustomLogger.error(e.response!.data);
    }
    rethrow;
  }
}

Future<Map?> payRemainingOrder(AuthProvider auth,
    {required String userID, amount, orderID}) async {
  try {
    Response response = await customDioClient.client.post(
        "${APIConfig.baseUrl}/api/partial/part2/create-enc",
        data: {"user_id": userID, "amount": amount, "orderId": orderID},
        options: Options(headers: {"Authorization": "Bearer ${auth.token}"}));
    // log(jsonEncode(response.data), name: "payRemainingOrder");
    return response.data;
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
    // log("getUpcomingOrderItems");
    Response response = await customDioClient.client.get(
        "${APIConfig.baseUrl}/api/customer-upcoming-order",
        options: Options(headers: {"Authorization": "Bearer ${auth.token}"}));
    log(jsonEncode(response.data), name: "customer-upcoming-order");
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

Future<bool> rateOrder(AuthProvider auth,
    {required String orderId, rate, feedback}) async {
  try {
    log("RateOrder");
    // url
    log("${APIConfig.baseUrl}/api/customer/submit-order-rating");
    Response response = await customDioClient.client.post(
        "${APIConfig.baseUrl}/api/customer/submit-order-rating",
        data: {
          "order_id": orderId,
          "rate": rate,
          "message": feedback,
        },
        options: Options(headers: {"Authorization": "Bearer ${auth.token}"}));

    log(jsonEncode(response.data), name: "RateOrder");

    return response.data["success"];
  } catch (e) {
    if (e is DioException) {
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}

Future<bool> cancelOrder(
    AuthProvider auth, String payload, String reason) async {
  try {
    log("Bearer ${auth.token}", name: "Token");
    // url
    log("${APIConfig.baseUrl}/api/customer/cancel-order/$payload",
        name: "customer-cancel-order");

    Response response = await customDioClient.client.post(
        "${APIConfig.baseUrl}/api/customer/cancel-order",
        data: {
          "id": payload,
          "reason": reason,
        },
        options: Options(headers: {"Authorization": "Bearer ${auth.token}"}));

    /* Response response = await customDioClient.client.get(
        "${APIConfig.baseUrl}/api/customer/cancel-order/$payload",
        options: Options(headers: {"Authorization": "Bearer ${auth.token}"}));*/

    log(jsonEncode(response.data), name: "customer-cancel-order");

    return response.data["success"];
  } catch (e) {
    if (e is DioException) {
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}

Future<String?> getInvoiceLink(AuthProvider auth, String id) async {
  try {
    log("Bearer ${auth.token}", name: "Token");
    // url
    log("${APIConfig.baseUrl}/api/customer/orders/download-invoice",
        name: "GetInvoiceLink");
    Response response = await customDioClient.client.post(
        "${APIConfig.baseUrl}/api/customer/orders/download-invoice",
        data: {"order_id": id},
        options: Options(headers: {"Authorization": "Bearer ${auth.token}"}));
    log(jsonEncode(response.data), name: "GetInvoiceLink");
    return response.data["pdf_path"];
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
    log(jsonEncode(response.data), name: "customer-delivered-order");
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
