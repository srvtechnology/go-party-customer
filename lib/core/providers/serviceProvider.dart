import 'package:customerapp/core/repo/services.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';
import '../models/service.dart';

class ServiceProvider with ChangeNotifier{
  List<ServiceModel>? _data;

  List<ServiceModel>? get data=> _data;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  ServiceProvider({required FilterProvider filters}){
    if(filters.hasFilters==true){
      CustomLogger.debug("Getting filtered Services");
      getFilteredServices(filters);
    }
    else {
      getAllServices();
    }
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
      if(e is DioException){
        CustomLogger.error(e);
      }
      CustomLogger.error(e);
    }
    finally{
      stopLoading();
    }
  }
  Future<void> getFilteredServices(FilterProvider filters,{String? searchString})async{
    try{
      startLoading();
      Map<String,dynamic> data = {};
      if(filters.startPrice!=null && filters.endPrice!=null){
        data["start_price"]=filters.startPrice;
        data["end_price"]=filters.endPrice;
      }
      if(searchString!=null){
        data["search"]=searchString;
      }
      filters.categories.forEachIndexed(
              (index,value){
                data["category[$index]"]=value;
              });
      CustomLogger.debug(data);
      _data = await searchServices(
          data
      );
    }catch(e)
    {
      CustomLogger.error(e);
    }
    finally{
      stopLoading();
    }
  }
}

class FilterProvider with ChangeNotifier{
  List<String> _categories=[];
  String? _startPrice,_endPrice;
  List<String> get categories=>_categories;
  bool _hasFilters = false;
  bool get hasFilters => _hasFilters;
  String? get startPrice => _startPrice;
  String? get endPrice => _endPrice;

  void setFilters({required List<String> categories,String? startPrice,String? endPrice}){
    _categories = [...categories];
    _startPrice = startPrice;
    _endPrice = endPrice;
    _hasFilters = true;
    notifyListeners();
  }
}