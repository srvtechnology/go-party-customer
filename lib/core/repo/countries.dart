import 'package:customerapp/core/models/countries.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:dio/dio.dart';

import '../../config.dart';
import '../utils/dio.dart';

Future<List<Country>> getCountries(AuthProvider auth)async{
  try{
    Response response = await customDioClient.client.get(
        "${APIConfig.baseUrl}/api/customer/get-countries",
        options: Options(
          headers: {
            "Authorization": "Bearer ${auth.token}"
          }
        )
    );
    List<Country> data = [];
    for (var country in response.data["data"]){
      data.add(Country.fromJson(country));
    }
    return data;
  }catch(e){
    if(e is DioException){
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}