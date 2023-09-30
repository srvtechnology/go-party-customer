import 'package:customerapp/core/utils/logger.dart';
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../repo/category.dart' as categoryRepo;

class CategoryProvider with ChangeNotifier{
  List<CategoryModel> _data=[];
  List<CategoryModel> get data=> _data;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  CategoryProvider(){
    getCategories();
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
}