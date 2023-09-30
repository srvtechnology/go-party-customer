import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import '../../config.dart';
import '../models/user.dart';
import '../utils/dio.dart';
import '../utils/logger.dart';

Future<String> login(String email,String password)async{
  try{
    Response response = await customDioClient.client.post("${APIConfig.baseUrl}/api/customer-login",data: {
      "email":email,
      "password":password,
    });
    CustomLogger.debug(response.data);
    return response.data['result']['token'];
  }
  catch(e){
    if(e is DioException){
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}

Future<UserModel> get_UserData(String token)async{
  Response response;
  try{
    response = await customDioClient.client.get("${APIConfig.baseUrl}/api/customer-details",
        options: Options(
            headers: {
              "Authorization":"Bearer $token"
            }
        )
    );
    return UserModel.fromJson(response.data);
  }
  catch(e){
    if(e is DioException){
      CustomLogger.error(e.response!.data);
      if(e.response!.data["status"].contains("Token is Expired")){

      }
    }
    return Future.error(e);
  }
}

Future register(String email,String password,String name,String phone)async
{
  try{
    Response response = await customDioClient.client.post(
      "${APIConfig.baseUrl}/api/customer-registration",
      data: {
        "name":name,
        "email":email,
        "password":password,
        "mobile":phone
      }
    );
    return Future.value(true);
  }catch(e){
    return Future.value(e);
  }
}

