import 'dart:convert';
import 'dart:developer';

import 'package:customerapp/config.dart';
import 'package:customerapp/core/models/cartModel.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:dio/dio.dart';

import '../utils/dio.dart';

Future<void> addtoCart(
  AuthProvider auth,
  Map data,
) async {
  /*  log(jsonEncode(data), name: "addtoCart"); */
  try {
    Response response = await customDioClient.client.post(
        auth.isAgent
            ? "${APIConfig.baseUrl}/api/agent/add-to-cart"
            : "${APIConfig.baseUrl}/api/customer/add-to-cart",
        data: data,
        options: Options(headers: {"Authorization": "Bearer ${auth.token}"}));
    log(jsonEncode(response.data), name: "add to Cart");
  } catch (e) {
    if (e is DioException) {
      CustomLogger.error(e.response?.data ?? e.toString());
    }
    return Future.error(e);
  }
}

Future<List<CartModel>> getCartItems(AuthProvider auth) async {
  if (auth.authState != AuthState.loggedIn &&
      auth.user == null &&
      auth.token == null) {
    return Future.error("User not logged in");
  }
  final url = auth.isAgent
      ? "${APIConfig.baseUrl}/api/agent/show-cart"
      : "${APIConfig.baseUrl}/api/customer/show-cart";
  log("Bearer ${auth.token}", name: "$url getCartItems");
  Response response = await customDioClient.client.get(url,
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

  return list;
  /* } catch (e) {
    if (e is DioException) {
      log(e.response?.data.toString() ?? '', name: "getCartItems");
    }
    return Future.error(e);
  } */
}

Future<void> changeCartItemQuantity(
    AuthProvider auth, String quantity, String itemId) async {
  try {
    log("Bearer ${auth.token}", name: "changeCartItemQuantity");
    log(quantity, name: "changeCartItemQuantity");
    log(itemId, name: "changeCartItemQuantity");

    CustomLogger.debug(quantity);
    Response response = await customDioClient.client.post(
        auth.isAgent
            ? "${APIConfig.baseUrl}/api/agent/update-cart-qty"
            : "${APIConfig.baseUrl}/api/customer/update-cart-qty",
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
        auth.isAgent
            ? "${APIConfig.baseUrl}/api/agent/delete-cart-item"
            : "${APIConfig.baseUrl}/api/customer/delete-cart-item",
        data: {"id": id},
        options: Options(headers: {"Authorization": "Bearer ${auth.token}"}));
  } catch (e) {
    CustomLogger.error(e);
    rethrow;
  }
}
