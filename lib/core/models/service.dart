import 'package:customerapp/core/utils/logger.dart';

import '../../config.dart';

class ServiceModel{
  String id,name,description,price,discountedPrice,priceBasis;
  List<String> images;
  String? categoryId;
  final String imageUrl = "storage/app/public/service/";

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.priceBasis,
    required this.discountedPrice,
    required this.price,
    required this.images,
    this.categoryId,
  });
  factory ServiceModel.fromJson(Map json){
    List<String> temp = ["${APIConfig.baseUrl}/storage/app/public/service/${json["image"]}"];
    if(json["additional_images"]!=null)
      {
        for (String i in json["additional_images"]){
          temp.add("${APIConfig.baseUrl}/storage/app/public/service/$i");
        }
      }

    return ServiceModel(
      id: json["id"].toString(),
      name: json["service"],
      description: json["description"],
      price: json["price"].toString(),
      priceBasis: json["price_basis"],
      discountedPrice: json["discount_price"],
      images: temp,
    );
  }
}