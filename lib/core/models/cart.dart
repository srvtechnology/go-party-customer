import 'package:customerapp/core/models/category.dart';
import 'package:customerapp/core/models/service.dart';

import 'package.dart';

class CartModel{
  List<ServiceModel> items = [];
  String id,price,quantity,totalPrice,startDate,endDate,days,duration;
  dynamic service;
  CategoryModel category;
  
  CartModel({
    required this.id,
    required this.service,
    required this.category,
    required this.price,
    required this.quantity,
    required this.totalPrice,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.duration
});
  factory CartModel.fromJson(Map json){
    return CartModel(
        id: json["id"].toString(),
        service: json["service_details"]==null?PackageModel.fromJson(json["package_details"]):ServiceModel.fromJson(json["service_details"]),
        category: CategoryModel.fromJson(json["category_details"]),
        price: json["price"].toString(),
        quantity: json["quantity"].toString(),
        totalPrice: json["total_price"].toString(),
        startDate: json["order_date"],
        endDate: json["order_end_date"],
        days: json["days"].toString(),
        duration: json["duration"]=="M"?"Morning":json["duration"]=="N"?"Night":"Full Day");
  }
}