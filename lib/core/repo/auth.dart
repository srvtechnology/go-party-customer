import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../config.dart';
import '../models/user.dart';
import '../utils/dio.dart';
import '../utils/logger.dart';

Future<String> login(String email, String password) async {
  try {
    Response response = await customDioClient.client
        .post("${APIConfig.baseUrl}/api/customer-login", data: {
      "email": email,
      "password": password,
    });
    log(jsonEncode(response.data.toString()));
    CustomLogger.debug(response.data);
    return response.data['result']['token'];
  } catch (e) {
    if (e is DioException) {
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}

Future<UserModel> get_UserData(String token) async {
  Response response;
  try {
    response = await customDioClient.client.get(
        "${APIConfig.baseUrl}/api/customer-details",
        options: Options(headers: {"Authorization": "Bearer $token"}));
    log(jsonEncode(response.data.toString()), name: "User Data");
    return UserModel.fromJson(response.data);
  } catch (e) {
    if (e is DioException) {
      CustomLogger.error(e.response!.data);
      if (e.response!.data["status"].contains("Token is Expired")) {}
    }
    return Future.error(e);
  }
}

Future<Response> get_AgentData(String token) async {
  Response response;
  try {
    response = await customDioClient.client.get(
        "${APIConfig.baseUrl}/api/agent/detail",
        options: Options(headers: {"Authorization": "Bearer $token"}));
    log(jsonEncode(response.data.toString()), name: "User Data");
    return response;
  } catch (e) {
    if (e is DioException) {
      CustomLogger.error(e.response!.data);
      if (e.response!.data["status"].contains("Token is Expired")) {}
    }
    return Future.error(e);
  }
}

Future<Map<String, dynamic>> de_Activate(String token, customerId) async {
  Response response;
  try {
    response = await customDioClient.client
        .post("${APIConfig.baseUrl}/api/customer/change-status",
            data: {
              "customer_id": customerId,
              "status": "I",
            },
            options: Options(headers: {"Authorization": "Bearer $token"}));
    return response.data;
  } catch (e) {
    if (e is DioException) {
      CustomLogger.error(e.response!.data);
      if (e.response!.data["status"].contains("Token is Expired")) {}
    }
    return Future.error(e);
  }
}

/*Future<Response?> register(
    String email, String password, String name, String phone) async {
  try {
    Response response = await customDioClient.client
        .post("${APIConfig.baseUrl}/api/customer-registration", data: {
      "name": name,
      "email": email,
      "password": password,
      "mobile": phone
    });
    log(jsonEncode(response.data.toString()));
    return Future.value(response);
  } catch (e) {
    return Future.value(null);
  }
}*/

/*--- modified on 25-07-24 ----*/
Future<Response?> register(
    String email, String password, String name, String phone) async {
  try {
    Response response = await customDioClient.client
        .post("${APIConfig.baseUrl}/api/customer-registration", data: {
      "name": name,
      "email": email,
      "password": password,
      "mobile": phone
    });
    log(jsonEncode(response.data.toString()));
    if (response.statusCode == 200) {
      return response;
    } else {
      String errorMessage = response.data['message'] ?? 'Unknown error';
      throw Exception(errorMessage);
    }
  } catch (e) {
    log(e.toString(), name: "User Registration Error");
    return null;
  }
}

Future<Response?> registerAgent(
    String email, String password, String name, String phone) async {
  try {
    Response response = await customDioClient.client
        .post("${APIConfig.baseUrl}/api/agent/register", data: {
      "name": name,
      "phone": phone,
      "email": email,
      "password": password,
      "confirm_password": password
    });
    log(jsonEncode(response.data.toString()), name: "Agent Registered");
    return Future.value(response);
  } catch (e) {
    log(e.toString(), name: "Agent Registration Error");
    return Future.value(null);
  }
}

Future<Response?> submitAgentOTp(String otp, email) async {
  try {
    Response response = await customDioClient.client
        .post("${APIConfig.baseUrl}/api/agent/register/otp-code", data: {
      "opt_code": otp,
      "email": email,
    });
    log(jsonEncode(response.data.toString()));
    return Future.value(response);
  } catch (e) {
    return Future.value(null);
  }
}

Future<Response?> submitAgentBankData({
  required String email,
  required String bankName,
  required String accountNumber,
  required String accountHolderName,
  required String ifscCode,
}) async {
  try {
    Response response = await customDioClient.client
        .post("${APIConfig.baseUrl}/api/agent/register/bank-details", data: {
      "email": email,
      "bank_name": bankName,
      "account_no": accountNumber,
      "holder_name": accountHolderName,
      "ifsc_no": ifscCode,
    });
    log(jsonEncode(response.data.toString()));
    return Future.value(response);
  } catch (e) {
    return Future.value(null);
  }
}

Future<Response?> agentLogin({
  required String email,
  required String password,
}) async {
  try {
    Response response = await customDioClient.client
        .post("${APIConfig.baseUrl}/api/agent/login", data: {
      "email": email,
      "password": password,
    });
    log(jsonEncode(response.data.toString()));
    return Future.value(response);
  } catch (e) {
    return Future.value(null);
  }
}

Future<Response?> resendOTp(String email) async {
  try {
    Response response = await customDioClient.client
        .post("${APIConfig.baseUrl}/api/agent/register/otp-code/resend", data: {
      "email": email,
    });
    log(jsonEncode(response.data.toString()));
    return Future.value(response);
  } catch (e) {
    return Future.value(null);
  }
}
