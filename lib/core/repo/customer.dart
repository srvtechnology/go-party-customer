import 'package:customerapp/config.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:dio/dio.dart';

Future<void> editProfile(AuthProvider auth,Map<String,dynamic> data)async{
  try{
    CustomLogger.debug(data);
    Response response = await Dio().post("${APIConfig.baseUrl}/api/customer-update",
        data: FormData.fromMap(data),
      options: Options(
        headers: {
          "Authorization":"Bearer ${auth.token}"
        }
      )

    );

  }catch(e){
    if (e is DioException){
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
}