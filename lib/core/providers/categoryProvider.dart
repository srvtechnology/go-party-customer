import 'package:customerapp/core/models/filterServiceModel.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../config.dart';
import '../models/citiesModel.dart';
import '../models/event.dart';
import '../repo/category.dart' as categoryRepo;
import '../repo/category.dart' as filterServicesRepo;
import '../repo/category.dart' as filterCitiesRepo;
import '../utils/dio.dart';

class CategoryProvider with ChangeNotifier{
  List<CategoryModel> _data=[];
  List<CategoryModel> get data=> _data;

  List<FilterServicesModel> _filterServices = [];
  List<FilterServicesModel> get filterServices=> _filterServices;

  /*FilterCitiesModel? filterCities;*/

  List<FilterCitiesModel> _filterCities = [];
  List<FilterCitiesModel> get filterCities => _filterCities;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  CategoryProvider(){
    getCategories();
    getFilterServices();
    getFilterCities();
  }
  void startLoading(){
    _isLoading = true;
    notifyListeners();
  }
  void stopLoading(){
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getCategories()async{
    startLoading();
    try{
      _data = await categoryRepo.getCategories();
    }catch(e){
      CustomLogger.error(e);
    }
    stopLoading();
  }

  Future<void> getFilterServices() async{
    startLoading();
    try{
      _filterServices = await filterServicesRepo.getFilterServices();
    }catch(e){
      CustomLogger.error(e);
    }
    stopLoading();
  }

  Future<void> getFilterCities() async{
    startLoading();
    try{
      _filterCities = await filterServicesRepo.getFilterCities();
    }catch(e){
      CustomLogger.error(e);
    }
    stopLoading();
  }




/*Future<void> getFilterCities() async{
    startLoading();
    try{
      filterCities = await filterCitiesRepo.getFilterCities();
    }catch(e){
      CustomLogger.error(e);
    }
    stopLoading();
  }*/


}


