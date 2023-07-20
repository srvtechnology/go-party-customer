import 'package:customerapp/config.dart';
import 'package:customerapp/core/models/cart.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:dio/dio.dart';

Future<void> addtoCart(AuthProvider auth,Map data)async{
  try{
    CustomLogger.debug(auth.token);
    Response response = await Dio().post("${APIConfig.baseUrl}/api/customer/add-to-cart",
    data:data,
      options: Options(
        headers: {
          "Authorization":"Bearer ${auth.token}"
        }
      )
    );
  }catch(e){
    if(e is DioException){
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}

Future<List<CartModel>> getCartItems(AuthProvider auth)async{
  try{
    Response response = await Dio().get(
        "${APIConfig.baseUrl}/api/customer/show-cart",
      options: Options(
        headers: {
          "Authorization":"Bearer ${auth.token}"
        }
      )
    );
    List<CartModel> list = [];
    CustomLogger.debug(response.data);
    for(var i in response.data["data"]["cart"])
    {
      list.add(CartModel.fromJson(i));
    }
    return list;
  } catch(e){
    if(e is DioException){
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}

