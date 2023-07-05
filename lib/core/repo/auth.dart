import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import '../../config.dart';
import '../models/user.dart';
import '../utils/logger.dart';

Future<String> login(String email,String password)async{
  try{
    Response response = await Dio().post("${APIConfig.baseUrl}/api/customer-login",data: {
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
    response = await Dio().get("${APIConfig.baseUrl}/api/customer-details",
        options: Options(
            headers: {
              "Authorization":"Bearer ${token}"
            }
        )
    );
    return UserModel.fromJson(response.data);
  }
  catch(e){
    if(e is DioException){
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}

