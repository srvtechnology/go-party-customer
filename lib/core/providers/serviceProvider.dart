import 'package:customerapp/core/repo/services.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:flutter/cupertino.dart';

import '../models/service.dart';

class ServiceProvider with ChangeNotifier{
  List<ServiceModel>? _data;
  List<ServiceModel>? get data=> _data;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  ServiceProvider(){
    getAllServices();
  }
  void startLoading(){
    _isLoading = true;
    notifyListeners();
  }
  void stopLoading(){
    _isLoading = false;
    notifyListeners();
  }
  Future<void> getAllServices()async{
    try{
      startLoading();
      _data = await getServices();
    }catch(e)
    {
      CustomLogger.error(e);
    }
    finally{
      stopLoading();
    }
  }

}