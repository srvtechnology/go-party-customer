import 'package:customerapp/config.dart';
import 'package:customerapp/core/models/service.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:dio/dio.dart';

Future<List<ServiceModel>> getServices()async{
  try{
    Response response = await Dio().get("${APIConfig.baseUrl}/api/customer-all-service");
    List<ServiceModel> services = [];
    for (var serviceJson in response.data["services"]){
      services.add(ServiceModel.fromJson(serviceJson));
    }
    return services;
  }
  catch(e){
    return Future.error(e);
  }
}


Future<List<ServiceModel>> searchServices(Map<String,dynamic> data)async{
  try{
    Response response = await Dio().post(
        "${APIConfig.baseUrl}/api/customer/search",
      data: FormData.fromMap(data),
    );
    List<ServiceModel> services = [];
    CustomLogger.debug(response.data);
    for (var serviceJson in response.data["data"]){
      services.add(ServiceModel.fromJson(serviceJson));
    }
    return services;
  }
  catch(e){
    if(e is DioException){
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}