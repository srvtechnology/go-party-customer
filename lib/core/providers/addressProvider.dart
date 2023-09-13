import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:flutter/material.dart';
import '../models/address.dart';
import '../repo/address.dart' as AddressRepo;

class AddressProvider with ChangeNotifier{
  List<AddressModel> _data=[];
  List<AddressModel> get data=> _data;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AddressProvider(AuthProvider auth){
    getAddress(auth);
  }
  void startLoading(){
    _isLoading = true;
    notifyListeners();
  }
  void stopLoading(){
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getAddress(AuthProvider auth)async{
    startLoading();
    try{
      _data = await AddressRepo.getAddress(auth);
    }catch(e){
      CustomLogger.error(e);
      _data = [];
    }
    stopLoading();
  }

  Future<void> deleteAddress(AuthProvider auth,String addressId)async{
    startLoading();
    try{
        await AddressRepo.deleteAddressbyId(auth, addressId);
    }catch(e){
      CustomLogger.error(e);
    }
    await getAddress(auth);
    stopLoading();
  }

}