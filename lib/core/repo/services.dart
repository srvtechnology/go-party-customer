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
      options: Options(
        headers: {
          "Authorization":"Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvdXRzYXZsaWZlLmNvbVwvYXBpXC9jdXN0b21lci1sb2dpbiIsImlhdCI6MTY4OTgzMzAwNiwiZXhwIjoxNjg5ODM2NjA2LCJuYmYiOjE2ODk4MzMwMDYsImp0aSI6InNSZFVqTTYxS2pOZ1RHNVIiLCJzdWIiOjIzOSwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.mN0AgfdAi_9xwAbQ60HgznRp6-cjGJ83D65wsV7XudI"
        }
      )

    );
    List<ServiceModel> services = [];
    CustomLogger.debug(response.data);
    for (var serviceJson in response.data){
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