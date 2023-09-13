import 'package:collection/collection.dart';
import 'package:customerapp/config.dart';
import 'package:customerapp/core/models/service.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:dio/dio.dart';


import '../utils/dio.dart';

Future<List<ServiceModel>> getServices()async{
  try{
    Response response = await customDioClient.client.get("${APIConfig.baseUrl}/api/customer-all-service");
    List<ServiceModel> services = [];
    for (var serviceJson in response.data["services"]){
      try{
        services.add(ServiceModel.fromJson(serviceJson));
      }catch(e){
        CustomLogger.error(serviceJson);
      }
    }
    return services;
  }
  catch(e){
    return Future.error(e);
  }
}

Future<List> getServiceAvailability(List<String> serviceId,String addressId)async{
  try{
    Map<String,dynamic> data ={
      "address_id":addressId,

    };

    serviceId.forEachIndexed((index,e){
      data["service_id[$index]"]=e;
    });
    CustomLogger.debug(data);
    Response response = await customDioClient.client.post(
        "${APIConfig.baseUrl}/api/customer/check-service-availablity",
        data: FormData.fromMap(data)
    );
    CustomLogger.debug(response.data);
    return response.data["data"]["not_available_services"]??[];
  }
  catch(e){
    if(e is DioException){
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}


Future<List<ServiceModel>> searchServices(Map<String,dynamic> data)async{
  try{
    Response response = await customDioClient.client.post(
        "${APIConfig.baseUrl}/api/customer/search",
      data: FormData.fromMap(data),
    );
    List<ServiceModel> services = [];
    for (var serviceJson in response.data["data"]){
      try{
        services.add(ServiceModel.fromJson(serviceJson));
      }catch(e){
        CustomLogger.error(serviceJson);
      }
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


Future<List<String>> getBannerImages()async{
  try{
    Response response = await Dio().get("${APIConfig.baseUrl}/api/adv-banners-list");
    List<String> images = [];
    
    for (var i in response.data["data"]){
      images.add(i["image"]);
    }
    return images;
  }catch(e){
    rethrow;
  }
}
Future<List<String>> getMobileBannerImages()async{
  try{
    Response response = await Dio().get("${APIConfig.baseUrl}/api/mobile-banners-list");
    List<String> images = [];
    for (var i in response.data["data"]){
      images.add(i["image"]);
    }
    return images;
  }catch(e){
    rethrow;
  }
}