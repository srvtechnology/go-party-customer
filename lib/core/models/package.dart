import 'package:customerapp/core/models/service.dart';
import 'package:customerapp/core/utils/logger.dart';

import '../../config.dart';

class PackageModel {
  String id,name,description,price,discountedPrice;
  List<String> images;
  List<ServiceModel> services;

  PackageModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.discountedPrice,
    required this.images,
    required this.services
});
  factory PackageModel.fromJson(Map json){

    List<String> temp = ["${APIConfig.baseUrl}/storage/app/public/packages/${json["image"]}"];

    if(json["additional_images"]!=null && json["additional_images"] is! String)
    {
      for (String i in json["additional_images"]){
        temp.add("${APIConfig.baseUrl}/storage/app/public/packages/$i");
      }
    }

    List<ServiceModel> servicesList = [];

    if(json["packages_to_service"]!=null){
      for(var i in json["packages_to_service"]){
        servicesList.add(ServiceModel.fromJson(i["service"]));
      }
    }
    return PackageModel(
        id: json["id"].toString(),
        name: json["name"],
        description: json["description"],
        price: json["price"].toString(),
        discountedPrice: json["discount_price"].toString(),
        images: temp,
        services: servicesList
      );
  }
}