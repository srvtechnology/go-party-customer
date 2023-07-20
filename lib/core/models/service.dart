import '../../config.dart';

class ServiceModel{
  String id,name,description,price,priceBasis,image;
  String? categoryId;
  final String imageUrl = "storage/app/public/service/";

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.priceBasis,
    required this.price,
    required this.image,
    this.categoryId,
  });
  factory ServiceModel.fromJson(Map json){
    return ServiceModel(
      id: json["id"].toString(),
      name: json["service"],
      description: json["description"],
      price: json["price"].toString(),
      priceBasis: json["price_basis"],
      image: "${APIConfig.baseUrl}/storage/app/public/service/${json["image"]}",
      //categoryId: json["service_category_details"]["category_id"],
    );
  }
}