import 'package:flutter/material.dart';

import '../../config.dart';
import 'single_package.dart';

class ServiceModel {
  String? id, name, description, price, discountedPrice, priceBasis;
  List<String>? images;
  int? minQnty;
  String? rating, categoryId;
  final String? imageUrl = "storage/app/public/service/";
  List<ReviewModel>? reviews = [];
  List<PopupCategory>? popupCategories;
  List<String>? availableCities;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.priceBasis,
    required this.discountedPrice,
    required this.price,
    required this.images,
    required this.reviews,
    this.popupCategories,
    this.availableCities,
    this.rating,
    this.categoryId,
    required this.minQnty,
  });

  factory ServiceModel.fromJson(Map json) {
    List<String> temp = [
      "${APIConfig.baseUrl}/storage/app/public/service/${json["image"]}"
    ];

    if (json["additional_images"] != null &&
        json["additional_images"] is! String) {
      for (String i in json["additional_images"]) {
        temp.add("${APIConfig.baseUrl}/storage/app/public/service/$i");
      }
    }

    List<ReviewModel> tempReviews = [];
    String? tempavgReview;
    if (json["reviews"] != null) {
      tempavgReview = json["reviews"]["avg_rating"].toString();
      for (var reviewJson in json["reviews"]["list_of_ratings"]) {
        tempReviews.add(ReviewModel.fromJson(reviewJson));
      }
    }

    List<String> tempAvailableCities = [];
    var cities = json["available_cities"];
    debugPrint("Cities : ${cities.runtimeType}");
    if (cities != null && cities is List<dynamic>) {
      tempAvailableCities = cities.map((e) => e.toString()).toList();
      debugPrint("Cities : $tempAvailableCities");
    } else {
      debugPrint("No available cities found or invalid data type.");
    }

    List<PopupCategory> tempPopupCategories = [];
    var serviceCategory = json["popup_categories"];
    debugPrint("ServiceCategories: ${serviceCategory.runtimeType}");
    if (serviceCategory != null) {
      for (var popupCategoryJson in json["popup_categories"]) {
        tempPopupCategories.add(PopupCategory.fromJson(popupCategoryJson));
        debugPrint("ServiceCategories : $tempPopupCategories");
      }
    } else {
      debugPrint("No popup categories found or invalid data type.");
    }

    return ServiceModel(
      reviews: tempReviews,
      rating: tempavgReview,
      popupCategories: tempPopupCategories,
      availableCities: tempAvailableCities,
      id: json["id"].toString(),
      name: json["service"],
      description: json["description"],
      price: json["price"].toString(),
      priceBasis: json["price_basis"],
      discountedPrice: json["discount_price"],
      images: temp,
      minQnty: json["min_qty"],
    );
  }
}

class EventModel {
  String id, name, image;

  EventModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory EventModel.fromJson(Map json) {
    return EventModel(
        id: json["id"].toString(),
        name: json["category_name"],
        image: json["image"]);
  }
}

class ReviewModel {
  String name, message, rating;

  ReviewModel({
    required this.name,
    required this.message,
    required this.rating,
  });

  factory ReviewModel.fromJson(Map json) {
    return ReviewModel(
        name: json["user"]["name"],
        message: json["message"],
        rating: json["rating"].toString());
  }
}

/* class ServicePopUpCategory {
  int? id;
  String? categoryId;
  dynamic serviceId;
  String? packageId;
  int? servicePrice;
  int? discountPrice;
  String? unit;
  dynamic minQty;
  dynamic serviceStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  /*--- Note :
  Category is imported from Single package since both has same name and fields
  ---*/
  Category? category;

  ServicePopUpCategory({
    this.id,
    this.categoryId,
    this.serviceId,
    this.packageId,
    this.servicePrice,
    this.discountPrice,
    this.unit,
    this.minQty,
    this.serviceStatus,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  factory ServicePopUpCategory.fromJson(Map<String, dynamic> json) =>
      ServicePopUpCategory(
        id: json["id"],
        categoryId: json["category_id"],
        serviceId: json["service_id"],
        packageId: json["package_id"],
        servicePrice: json["service_price"],
        discountPrice: json["discount_price"],
        unit: json["unit"],
        minQty: json["min_qty"],
        serviceStatus: json["service_status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "service_id": serviceId,
        "package_id": packageId,
        "service_price": servicePrice,
        "discount_price": discountPrice,
        "unit": unit,
        "min_qty": minQty,
        "service_status": serviceStatus,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "category": category?.toJson(),
      };
} */
