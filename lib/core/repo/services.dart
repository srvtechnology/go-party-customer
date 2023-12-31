import 'package:collection/collection.dart';
import 'package:customerapp/config.dart';
import 'package:customerapp/core/models/service.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:dio/dio.dart';


import '../models/package.dart';
import '../utils/dio.dart';

Future<List<ServiceModel>> getServices()async{
  try{
    Response response = await customDioClient.client.get("${APIConfig.baseUrl}/api/customer-all-service");
    List<ServiceModel> services = [];
    for (var serviceJson in response.data["services"]){
      try{
        services.add(ServiceModel.fromJson(serviceJson));
      }catch(e){
        CustomLogger.error(e);
      }
    }
    return services;
  }
  catch(e){
    return Future.error(e);
  }
}

Future<List<PackageModel>> getPackages()async{
  try{
    Response response = await customDioClient.client.get("${APIConfig.baseUrl}/api/customer-all-packages");
    List<PackageModel> packages = [];
    for (var serviceJson in response.data["packages"]){
      try{
        packages.add(PackageModel.fromJson(serviceJson));
      }catch(e){
        CustomLogger.error(serviceJson);
        CustomLogger.error(e);
      }
    }
    return packages;
  }
  catch(e){
    return Future.error(e);
  }
}
Future<List<EventModel>> getEvents()async{
  try{
    Response response = await Dio().get("${APIConfig.baseUrl}/api/view-all-events");
    List<EventModel> events = [];
    for (var eventJson in response.data["data"]){
      try{
        events.add(EventModel.fromJson(eventJson));
      }catch(e){
        CustomLogger.error(eventJson);
      }
    }
    return events;
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


Future<void> writeReview(AuthProvider auth,String orderId,String rating,String message)async{
  try{
    Response response = await Dio().post("${APIConfig.baseUrl}/api/customer/submit-order-rating",
    data: {
      "order_id":orderId,
      "rate":rating,
      "message":message
    },
        options: Options(
            headers: {
              "Authorization":"Bearer ${auth.token}"
            }
        )
    );
    CustomLogger.debug(response.data);
  }
  catch(e){
    if(e is DioException){
      CustomLogger.error(e.response!.data);
    }
    CustomLogger.error(e);
    rethrow;
  }
}