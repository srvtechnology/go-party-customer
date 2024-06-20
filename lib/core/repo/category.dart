import 'package:customerapp/config.dart';
import 'package:customerapp/core/models/citiesModel.dart';
import 'package:customerapp/core/models/event.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:dio/dio.dart';

import '../models/filterServiceModel.dart';
import '../utils/dio.dart';

Future<List<CategoryModel>> getCategories()async{
    try{
      Response response = await customDioClient.client.get("${APIConfig.baseUrl}/api/customer-all-category");
      List<CategoryModel> list = [];
      for(var i in response.data["category"])
      {
        list.add(CategoryModel.fromJson(i));
      }
      return list;
    } catch(e){
      if(e is DioException){
        CustomLogger.error(e.response!.data);
      }
      return Future.error(e);
    } 
}


Future<List<FilterServicesModel>> getFilterServices()async{
  try{
    Response response = await customDioClient.client.get("${APIConfig.baseUrl}/api/get_services");
    List<FilterServicesModel> list = [];
    for(var i in response.data["data"])
    {
      list.add(FilterServicesModel.fromJson(i));
    }
    return list;
  } catch(e){
    if(e is DioException){
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}

Future<List<FilterCitiesModel>> getFilterCities()async{
  try{
    Response response = await customDioClient.client.get("${APIConfig.baseUrl}/api/get_cities");
    List<FilterCitiesModel> list = [];
    for(var i in response.data["data"])
    {
      list.add(FilterCitiesModel.fromJson(i));
    }
    return list;
  } catch(e){
    if(e is DioException){
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}





