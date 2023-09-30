
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import '../utils/logger.dart';

class NetworkProvider with ChangeNotifier{
  bool _isOnline = true ;
  bool get isOnline => _isOnline;
  NetworkProvider(){
    CustomLogger.debug("Init Connection");
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      CustomLogger.debug(result);
      if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
        _isOnline = true;
      }
      else{
        _isOnline = false;
      }
      notifyListeners();
    });
  }
  }