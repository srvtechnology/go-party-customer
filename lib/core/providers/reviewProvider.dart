import 'package:flutter/cupertino.dart';

import '../models/user.dart';

class ReviewProvider extends ChangeNotifier {
  List<ReviewModel> _data=[];
  List<ReviewModel> get data=>_data;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void startLoading(){
    _isLoading = true;
    notifyListeners();
  }
  void stopLoading(){
    _isLoading = false;
    notifyListeners();
  }

  ReviewProvider({required String serviceId}){
    getReviews(serviceId);
  }
  Future<void> getReviews(String serviceId)async{
    startLoading();
    try{
      _data = [
        ReviewModel(name: "User1", message: "Great product!", rating: "5"),
        ReviewModel(name: "User2", message: "Good service.", rating: "4"),
        ReviewModel(name: "User3", message: "Not satisfied.", rating: "2"),
        ReviewModel(name: "User4", message: "Amazing experience!", rating: "5"),
        ReviewModel(name: "User5", message: "Could be better.", rating: "3"),
        ReviewModel(name: "User6", message: "Quick delivery.", rating: "4"),
        ReviewModel(name: "User7", message: "Highly recommended.", rating: "5"),
        ReviewModel(name: "User8", message: "Terrible quality.", rating: "1"),
        ReviewModel(name: "User9", message: "Average product.", rating: "3"),
        ReviewModel(name: "User10", message: "Excellent support.", rating: "5"),
      ];
    }catch(e){
      stopLoading();
      rethrow;
    }
    stopLoading();
  }
}