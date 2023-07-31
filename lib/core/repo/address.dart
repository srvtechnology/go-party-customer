import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:dio/dio.dart';

import '../../config.dart';
import '../models/address.dart';
import '../utils/logger.dart';

Future<String> addAddress(AuthProvider auth,Map data)async{
  try{
    Response response = await Dio().post("${APIConfig.baseUrl}/api/customer/add-address",
        data:data,
        options: Options(
            headers: {
              "Authorization":"Bearer ${auth.token}"
            }
        )
    );
    CustomLogger.debug(response.data);
    return response.data["address_id"];
  }catch(e){
    if(e is DioException){
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}

Future<List<AddressModel>> getAddress(AuthProvider auth)async{
  try{
    Response response = await Dio().get(
        "${APIConfig.baseUrl}/api/customer/view-address",
        options: Options(
          headers: {
            "Authorization":"Bearer ${auth.token}"
          }
        )
    );
    List<AddressModel> list = [];
    CustomLogger.debug(response.data);
    for(var i in response.data["data"]["all_address"])
    {
      list.add(AddressModel.fromJson(i));
    }
    return list;
  } catch(e){
    if(e is DioException){
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}