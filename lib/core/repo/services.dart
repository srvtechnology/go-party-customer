import 'package:customerapp/config.dart';
import 'package:customerapp/core/models/service.dart';
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
