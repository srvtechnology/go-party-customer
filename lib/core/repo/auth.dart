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
  log('${APIConfig.baseUrl}/api/customer-registration');
  // try {
  Response response = await customDioClient.client
      .post("${APIConfig.baseUrl}/api/customer-registration", data: {
    "name": name,
    "email": email,
    "password": password,
    "mobile": phone
  });
  print(
    jsonEncode(response.data.toString()),
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    String errorMessage = response.data['message'] ?? 'Unknown error';
    throw Exception(errorMessage);
  }
  // } catch (e) {
  //   log(e.toString(), name: "User Registration Error");
  //   return null;
  // }
}

Future<Map<String, dynamic>> verifyOTP(String id, String otp) async {
  print('${APIConfig.baseUrl}/api/customer-login/verify-customer-otp');
  print(id);
  print(otp);
  // try {
  Response response = await customDioClient.client.post(
      "${APIConfig.baseUrl}/api/customer-login/verify-customer-otp",
      data: {
        "user_id": id,
        "reg_otp": otp,
      });
  print(jsonEncode(response.data.toString()),);
  if (response.statusCode == 200) {
    return {
      "status": response.data['success'],
      "message": response.data['message'],
      "token": response.data['token'],
      "user": response.data['user']
    };
  }

  return {"status": false, "message": "Verification failed"};
  // } catch (e) {
  //   log(e.toString(), name: "OTP Verification Error");
  //   return {"status": false, "message": "OTP verification failed"};
  // }
}

// Future<Map<String, dynamic>> verifyOTP(String email, String otp) async {
//   try {
//     // Simulating API call delay
//     await Future.delayed(const Duration(seconds: 2));

//     // Dummy validation - accept only "1234" as valid OTP
//     if (otp == "1234") {
//       return {
//         "status": true,
//         "message": "OTP verified successfully",
//         "token": "dummy_token_${DateTime.now().millisecondsSinceEpoch}"
//       };
//     }
//     return {"status": false, "message": "Invalid OTP"};
//   } catch (e) {
//     return Future.error("OTP verification failed");
//   }
// }

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

Future<Response?> submitAgentOTp(String otp, userId) async {
  // try {
  Response response = await customDioClient.client
      .post("${APIConfig.baseUrl}/api/agent/register/otp-code", data: {
    "opt_code": otp,
    "user_id": userId,
  });
  log(jsonEncode(response.data.toString()));
  return Future.value(response);
  // } catch (e) {
  //   return Future.value(null);
  // }
}

Future<Response?> submitAgentBankData({
  required String user_id,
  required String bankName,
  required String accountNumber,
  required String accountHolderName,
  required String ifscCode,
}) async {
  try {
    Response response = await customDioClient.client
        .post("${APIConfig.baseUrl}/api/agent/register/bank-details", data: {
      "user_id": user_id,
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

Future<Response?> resendOTp(String userId) async {
  try {
    Response response = await customDioClient.client
        .post("${APIConfig.baseUrl}/api/agent/register/otp-code/resend", data: {
      "user_id": userId,
    });
    log(jsonEncode(response.data.toString()));
    return Future.value(response);
  } catch (e) {
    return Future.value(null);
  }
}
