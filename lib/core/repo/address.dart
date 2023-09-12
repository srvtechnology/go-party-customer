import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:dio/dio.dart';

import '../../config.dart';
import '../models/address.dart';
import '../utils/dio.dart';
import '../utils/logger.dart';

Future<String> addAddress(AuthProvider auth,Map data)async{
  try{
    Response response = await customDioClient.client.post("${APIConfig.baseUrl}/api/customer/add-address",
        data:data,
        options: Options(
            headers: {
              "Authorization":"Bearer ${auth.token}"
            }
        )
    );
    CustomLogger.debug(response.data);
    return response.data["address_id"].toString();
  }catch(e){
    if(e is DioException){
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}
Future<String> editAddress(AuthProvider auth,Map data)async{
  try{
    Response response = await customDioClient.client.post("${APIConfig.baseUrl}/api/customer/update-address",
        data:data,
        options: Options(
            headers: {
              "Authorization":"Bearer ${auth.token}"
            }
        )
    );
    CustomLogger.debug(response.data);
    return response.data["address_id"].toString();
  }catch(e){
    if(e is DioException){
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}

Future<List<AddressModel>> getAddress(AuthProvider auth)async{
  try{
    Response response = await customDioClient.client.get(
        "${APIConfig.baseUrl}/api/customer/view-address",
        options: Options(
          headers: {
            "Authorization":"Bearer ${auth.token}"
          }
        )
    );
    List<AddressModel> list = [];
    for(var i in response.data["data"]["all_address"])
    {
      try{
        list.add(AddressModel.fromJson(i));
      }catch(e){
        CustomLogger.error(i);
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