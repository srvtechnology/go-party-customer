import 'dart:convert';
import 'dart:developer';

import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config.dart';
import '../models/addressModel.dart';
import '../utils/dio.dart';
import '../utils/logger.dart';

Future<String> addAddress(AuthProvider auth, Map data) async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userType = pref.getString("userType") ?? "";
    log(">>>>User Type: $userType");

    Response response = await customDioClient.client.post(
        userType=="agent"
            ? "${APIConfig.baseUrl}/api/agent/add-address"
            : "${APIConfig.baseUrl}/api/customer/add-address",
        data: data,
        options: Options(headers: {"Authorization": "Bearer ${auth.token}"}));
    CustomLogger.debug(response.data);
    return response.data["address_id"].toString();
  } catch (e) {
    if (e is DioException) {
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}

Future<String> editAddress(AuthProvider auth, Map data) async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userType = pref.getString("userType") ?? "";
    log(">>>>User Type: $userType");

    Response response = await customDioClient.client.post(
        userType=="agent"
            ? "${APIConfig.baseUrl}/api/agent/update-address"
            : "${APIConfig.baseUrl}/api/customer/update-address",
        data: data,
        options: Options(headers: {"Authorization": "Bearer ${auth.token}"}));
    CustomLogger.debug(response.data);
    return response.data["address_id"].toString();
  } catch (e) {
    if (e is DioException) {
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}

Future<List<AddressModel>> getAddress(AuthProvider auth) async {
  try {
    log(auth.token.toString(), name: "token");
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userType = pref.getString("userType") ?? "";
    log(">>>>User Type: $userType");

    Response response = await customDioClient.client.get(
        userType=="agent"
            ? "${APIConfig.baseUrl}/api/agent/view-address"
            : "${APIConfig.baseUrl}/api/customer/view-address",
        options: Options(headers: {"Authorization": "Bearer ${auth.token}"}));
    log(jsonEncode(response.data), name: "Address Response");
    List<AddressModel> list = [];
    for (var i in response.data["data"]["all_address"]) {
      try {
        list.add(AddressModel.fromJson(i));
      } catch (e) {
        CustomLogger.error(i);
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

Future<void> deleteAddressbyId(AuthProvider auth, String addressId) async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userType = pref.getString("userType") ?? "";
    log(">>>>User Type: $userType");

    Response response = await Dio().post(
        userType=="agent"
            ? "${APIConfig.baseUrl}/api/agent/delete-address"
            : "${APIConfig.baseUrl}/api/customer/delete-address",
        options: Options(headers: {"Authorization": "Bearer ${auth.token}"}),
        data: {"address_id": addressId});
  } catch (e) {
    if (e is DioException) {
      CustomLogger.error(e.response!.data);
    }
    rethrow;
  }
}
