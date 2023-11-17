import 'dart:convert';
import 'dart:developer';

import 'package:customerapp/config.dart';
import 'package:customerapp/core/models/cart.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:dio/dio.dart';

import '../utils/dio.dart';

Future<void> addtoCart(AuthProvider auth, Map data) async {
  log(jsonEncode(data), name: "addtoCart");
  try {
    Response response = await customDioClient.client.post(
        "${APIConfig.baseUrl}/api/customer/add-to-cart",
        data: data,
        options: Options(headers: {"Authorization": "Bearer ${auth.token}"}));
    log(jsonEncode(response.data), name: "addtoCart");
  } catch (e) {
    if (e is DioException) {
      CustomLogger.error(e.response?.data ?? e.toString());
    }
    return Future.error(e);
  }
}

Future<List<CartModel>> getCartItems(AuthProvider auth) async {
  CustomLogger.debug(auth.token);
  try {
    log("Bearer ${auth.token}", name: "/api/customer/show-cart");
    Response response = await customDioClient.client.get(
        "${APIConfig.baseUrl}/api/customer/show-cart",
        options: Options(headers: {"Authorization": "Bearer ${auth.token}"}));
    log(jsonEncode(response.data), name: "getCartItems");
    List<CartModel> list = [];
    for (var i in response.data["data"]["cart"]) {
      try {
        list.add(CartModel.fromJson(i));
      } catch (e) {
        CustomLogger.error(e);
      }
    }
    CustomLogger.debug(list);
    return list;
  } catch (e) {
    if (e is DioException) {
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}

Future<void> changeCartItemQuantity(
    AuthProvider auth, String quantity, String itemId) async {
  try {
    log("Bearer ${auth.token}", name: "changeCartItemQuantity");
    log(quantity, name: "changeCartItemQuantity");
    log(itemId, name: "changeCartItemQuantity");

    CustomLogger.debug(quantity);
    Response response = await customDioClient.client.post(
        "${APIConfig.baseUrl}/api/customer/update-cart-qty",
        data: {"cart_id": itemId, "qty": quantity},
        options: Options(headers: {"Authorization": "Bearer ${auth.token}"}));
    log(response.data.toString(), name: "changeCartItemQuantity");
  } catch (e) {
    CustomLogger.error(e);
    rethrow;
  }
}

Future<void> removeFromCart(AuthProvider auth, String id) async {
  try {
    Response response = await customDioClient.client.post(
        "${APIConfig.baseUrl}/api/customer/delete-cart-item",
        data: {"id": id},
        options: Options(headers: {"Authorization": "Bearer ${auth.token}"}));
  } catch (e) {
    CustomLogger.error(e);
    rethrow;
  }
}
