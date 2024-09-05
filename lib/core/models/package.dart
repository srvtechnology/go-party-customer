import 'package:customerapp/core/models/service.dart';
import 'package:flutter/material.dart';

import '../../config.dart';

class PackageModel {
  String id, name, description, price, discountedPrice, category, unit;
  List<String> images;
  List<String> videos;
  List<ServiceModel> services;
  int minQnty;

  PackageModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.unit,
      required this.minQnty,
      required this.category,
      required this.discountedPrice,
      required this.images,
      required this.videos,
      required this.services});
  factory PackageModel.fromJson(Map json) {
    List<String> temp = [
      "${APIConfig.baseUrl}/storage/app/public/packages/${json["image"]}"
    ];

    if (json["additional_images"] != null &&
        json["additional_images"] is! String) {
      for (String i in json["additional_images"]) {
        temp.add("${APIConfig.baseUrl}/storage/app/public/packages/$i");
      }
    }
    /* List<String> images = [];

    if (json["image"] != null && json["image"] is List<dynamic>) {
      for (String imageUrl in json["image"]) {
        images.add(imageUrl);
      }
    }

    if (json["additional_images"] != null &&
        json["additional_images"] is List<dynamic>) {
      for (String imageUrl in json["additional_images"]) {
        images.add(imageUrl);
      }
    } */

    List<String> tempVideos = [];
    var videoUrl = json["video_url"];
    if (videoUrl != null && videoUrl is List<dynamic>) {
      tempVideos = videoUrl.map((e) => e.toString()).toList();
      debugPrint("VideoUrl : $tempVideos");
    } else {
      debugPrint("No video found or invalid data type.");
    }

    List<ServiceModel> servicesList = [];

    if (json["packages_to_service"] != null) {
      for (var i in json["packages_to_service"]) {
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
        videos: tempVideos,
        services: servicesList,
        category: json["category"],
        unit: json["unit"],
        minQnty: json["min_qty"]);
  }
}
