import 'package:customerapp/core/utils/logger.dart';

import '../../config.dart';

class ServiceModel{
  String id,name,description,price,discountedPrice,priceBasis;
  List<String> images;

  String? rating,categoryId;
  final String imageUrl = "storage/app/public/service/";
  List<ReviewModel> reviews=[];
  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.priceBasis,
    required this.discountedPrice,
    required this.price,
    required this.images,
    required this.reviews,
    this.rating,
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

    List<ReviewModel> tempReviews =[];
    String? tempavgReview;
    if(json["reviews"]!=null){
      tempavgReview=json["reviews"]["avg_rating"].toString();
      for(var reviewJson in json["reviews"]["list_of_ratings"])
      {
        tempReviews.add(ReviewModel.fromJson(reviewJson));
      }
    }
    return ServiceModel(
      reviews: tempReviews,
      rating: tempavgReview,
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


class EventModel {
  String id,name,image;

  EventModel({
    required this.id,
   required this.name,
   required this.image,
});

  factory EventModel.fromJson(Map json){
    return EventModel(id: json["id"].toString(), name: json["category_name"], image: json["image"]);
  }
}

class ReviewModel{
  String name,message,rating;
  ReviewModel(
      {
        required this.name,
        required this.message,
        required this.rating,
      }
      );

  factory ReviewModel.fromJson(Map json){
    return ReviewModel(name: json["user"]["name"], message: json["message"], rating: json["rating"].toString());
  }

}