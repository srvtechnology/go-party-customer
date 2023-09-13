import 'package:customerapp/config.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:dio/dio.dart';

import '../models/orders.dart';
import '../utils/dio.dart';

Future<void> placeOrder(AuthProvider auth,String paymentMethod,String paymentType,String addressId,String currentCity)async{
  try{
    Response response = await customDioClient.client.post("${APIConfig.baseUrl}/api/customer/payment",
    data: {
      "payment_method":paymentMethod,
      "payment_type":paymentType,
      "address_id":addressId,
      "current_city":currentCity
    },
      options: Options(
        headers: {
          "Authorization":"Bearer ${auth.token}"
        }
      )
    );
  }catch(e){
    if(e is DioException){
      CustomLogger.error(e.response!.data);
    }
    rethrow;
  }
}


Future<List<OrderModel>> getUpcomingOrderItems(AuthProvider auth)async{
  try{
    Response response = await customDioClient.client.get(
        "${APIConfig.baseUrl}/api/customer-upcoming-order",
        options: Options(
            headers: {
              "Authorization":"Bearer ${auth.token}"
            }
        )
    );
    List<OrderModel> list = [];
    CustomLogger.debug(response.data);
    for(var i in response.data["data"])
    {
      try{
        list.add(OrderModel.fromJson(i));
      }catch(e){
        CustomLogger.error(i);
        CustomLogger.error(e);
      }
    }
    return list;
  } catch(e){
    if(e is DioException){
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}

Future<List<OrderModel>> getDeliveredOrderItems(AuthProvider auth)async{
  try{
    Response response = await customDioClient.client.get(
        "${APIConfig.baseUrl}/api/customer-delivered-order",
        options: Options(
            headers: {
              "Authorization":"Bearer ${auth.token}"
            }
        )
    );
    List<OrderModel> list = [];
    for(var i in response.data["data"])
    {
      list.add(OrderModel.fromJson(i));
    }
    return list;
  } catch(e){
    if(e is DioException){
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}
