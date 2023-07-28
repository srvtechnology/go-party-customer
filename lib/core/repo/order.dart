import 'package:customerapp/config.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:dio/dio.dart';

Future<void> placeOrder(AuthProvider auth,String paymentMethod)async{
  try{
    Response response = await Dio().post("${APIConfig.baseUrl}/");
  }catch(e){
    
  }
}