import 'package:customerapp/config.dart';
import 'package:customerapp/core/models/category.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:dio/dio.dart';

Future<List<CategoryModel>> getCategories()async{
    try{
      Response response = await Dio().get("${APIConfig.baseUrl}/api/customer-all-category");
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