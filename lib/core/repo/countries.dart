import 'package:customerapp/core/models/countries.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:dio/dio.dart';

import '../../config.dart';

Future<List<Country>> getCountries(AuthProvider auth)async{
  try{
    Response response = await Dio().get("${APIConfig.baseUrl}/api/customer/get-countries");
    List<Country> data = [];

    for (var country in response.data["data"]){
      data.add(Country.fromJson(country));
    }
    return data;
  }catch(e){
    if(e is DioException){
      CustomLogger.debug(e);
    }
    return Future.error(e);
  }
}