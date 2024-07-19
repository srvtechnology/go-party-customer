// To parse this JSON data, do
//
//     final singlePackageData = singlePackageDataFromJson(jsonString);

import 'dart:convert';

SinglePackageData singlePackageDataFromJson(String str) =>
    SinglePackageData.fromJson(json.decode(str));

String singlePackageDataToJson(SinglePackageData data) =>
    json.encode(data.toJson());

class SinglePackageData {
  bool? success;
  Packages? packages;
  Reviews? reviews;

  SinglePackageData({
    this.success,
    this.packages,
    this.reviews,
  });

  factory SinglePackageData.fromJson(Map<String, dynamic> json) =>
      SinglePackageData(
        success: json["success"],
        packages: json["packages"] == null
            ? null
            : Packages.fromJson(json["packages"]),
        reviews:
            json["reviews"] == null ? null : Reviews.fromJson(json["reviews"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "packages": packages?.toJson(),
        "reviews": reviews?.toJson(),
      };
}

class Packages {
  int? id;
  String? name;
  String? description;
  int? price;
  int? discountPrice;
  String? unit;
  int? minQty;
  /* String? videoUrl; */
  String? tags;
  String? image;
  List<String>? additionalImages;
  dynamic featuredImage;
  String? featuredDescription;
  String? relatedPackage;
  String? relatedServices;
  String? category;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String>? otherServices;
  List<PopupCategory>? popupCategories;
  List<PackagesToService>? packagesToService;

  Packages({
    this.id,
    this.name,
    this.description,
    this.price,
    this.discountPrice,
    this.unit,
    this.minQty,
    /* this.videoUrl, */
    this.tags,
    this.image,
    this.additionalImages,
    this.featuredImage,
    this.featuredDescription,
    this.relatedPackage,
    this.relatedServices,
    this.category,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.otherServices,
    this.popupCategories,
    this.packagesToService,
  });

  factory Packages.fromJson(Map<String, dynamic> json) => Packages(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        discountPrice: json["discount_price"],
        unit: json["unit"],
        minQty: json["min_qty"],
        /* videoUrl: json["video_url"], */
        tags: json["tags"],
        image: json["image"],
        additionalImages: json["additional_images"] == null
            ? []
            : List<String>.from(json["additional_images"]!.map((x) => x)),
        featuredImage: json["featured_image"],
        featuredDescription: json["featured_description"],
        relatedPackage: json["related_package"],
        relatedServices: json["related_services"],
        category: json["category"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        otherServices: json["other_services"] == null
            ? []
            : List<String>.from(json["other_services"]!.map((x) => x)),
        popupCategories: json["popup_categories"] == null
            ? []
            : List<PopupCategory>.from(json["popup_categories"]!
                .map((x) => PopupCategory.fromJson(x))),
        packagesToService: json["packages_to_service"] == null
            ? []
            : List<PackagesToService>.from(json["packages_to_service"]!
                .map((x) => PackagesToService.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "discount_price": discountPrice,
        "unit": unit,
        "min_qty": minQty,
        /* "video_url": videoUrl, */
        "tags": tags,
        "image": image,
        "additional_images": additionalImages == null
            ? []
            : List<dynamic>.from(additionalImages!.map((x) => x)),
        "featured_image": featuredImage,
        "featured_description": featuredDescription,
        "related_package": relatedPackage,
        "related_services": relatedServices,
        "category": category,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "other_services": otherServices == null
            ? []
            : List<dynamic>.from(otherServices!.map((x) => x)),
        "popup_categories": popupCategories == null
            ? []
            : List<dynamic>.from(popupCategories!.map((x) => x.toJson())),
        "packages_to_service": packagesToService == null
            ? []
            : List<dynamic>.from(packagesToService!.map((x) => x.toJson())),
      };
}

class PackagesToService {
  int? id;
  int? packageId;
  int? serviceId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Service? service;

  PackagesToService({
    this.id,
    this.packageId,
    this.serviceId,
    this.createdAt,
    this.updatedAt,
    this.service,
  });

  factory PackagesToService.fromJson(Map<String, dynamic> json) =>
      PackagesToService(
        id: json["id"],
        packageId: json["package_id"],
        serviceId: json["service_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        service:
            json["service"] == null ? null : Service.fromJson(json["service"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "package_id": packageId,
        "service_id": serviceId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "service": service?.toJson(),
      };
}

class Service {
  int? id;
  String? service;
  String? description;
  String? priceBasis;
  dynamic minQty;
  int? price;
  String? status;
  String? discountPrice;
  /* String? videoUrl; */
  String? image;
  dynamic additionalImages;
  dynamic featuredImage;
  dynamic featuredDescription;
  dynamic relatedServices;
  dynamic relatedPackage;
  dynamic vendorServiceId;
  dynamic vendorUserId;
  dynamic category;
  dynamic serviceId;
  dynamic address;
  dynamic materialDesc;
  dynamic companyName;
  dynamic countryId;
  dynamic stateId;
  dynamic cityId;
  dynamic pinCode;
  dynamic driverName;
  dynamic driverMobileNo;
  dynamic driverKycType;
  dynamic dricerKycNo;
  dynamic driverLicenceNo;
  dynamic driverPincode;
  dynamic driverHouseNo;
  dynamic driverArea;
  dynamic driverLandmark;
  dynamic driverCity;
  dynamic driverState;
  dynamic driverImage;
  dynamic dlImage;
  dynamic video;
  DateTime? createdAt;
  DateTime? updatedAt;

  Service({
    this.id,
    this.service,
    this.description,
    this.priceBasis,
    this.minQty,
    this.price,
    this.status,
    this.discountPrice,
    /* this.videoUrl, */
    this.image,
    this.additionalImages,
    this.featuredImage,
    this.featuredDescription,
    this.relatedServices,
    this.relatedPackage,
    this.vendorServiceId,
    this.vendorUserId,
    this.category,
    this.serviceId,
    this.address,
    this.materialDesc,
    this.companyName,
    this.countryId,
    this.stateId,
    this.cityId,
    this.pinCode,
    this.driverName,
    this.driverMobileNo,
    this.driverKycType,
    this.dricerKycNo,
    this.driverLicenceNo,
    this.driverPincode,
    this.driverHouseNo,
    this.driverArea,
    this.driverLandmark,
    this.driverCity,
    this.driverState,
    this.driverImage,
    this.dlImage,
    this.video,
    this.createdAt,
    this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        service: json["service"],
        description: json["description"],
        priceBasis: json["price_basis"],
        minQty: json["min_qty"],
        price: json["price"],
        status: json["status"],
        discountPrice: json["discount_price"],
        /* videoUrl: json["video_url"], */
        image: json["image"],
        additionalImages: json["additional_images"],
        featuredImage: json["featured_image"],
        featuredDescription: json["featured_description"],
        relatedServices: json["related_services"],
        relatedPackage: json["related_package"],
        vendorServiceId: json["vendor_service_id"],
        vendorUserId: json["vendor_user_id"],
        category: json["category"],
        serviceId: json["service_id"],
        address: json["address"],
        materialDesc: json["material_desc"],
        companyName: json["company_name"],
        countryId: json["country_id"],
        stateId: json["state_id"],
        cityId: json["city_id"],
        pinCode: json["pin_code"],
        driverName: json["driver_name"],
        driverMobileNo: json["driver_mobile_no"],
        driverKycType: json["driver_kyc_type"],
        dricerKycNo: json["dricer_kyc_no"],
        driverLicenceNo: json["driver_licence_no"],
        driverPincode: json["driver_pincode"],
        driverHouseNo: json["driver_house_no"],
        driverArea: json["driver_area"],
        driverLandmark: json["driver_landmark"],
        driverCity: json["driver_city"],
        driverState: json["driver_state"],
        driverImage: json["driver_image"],
        dlImage: json["dl_image"],
        video: json["video"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service": service,
        "description": description,
        "price_basis": priceBasis,
        "min_qty": minQty,
        "price": price,
        "status": status,
        "discount_price": discountPrice,
        /* "video_url": videoUrl, */
        "image": image,
        "additional_images": additionalImages,
        "featured_image": featuredImage,
        "featured_description": featuredDescription,
        "related_services": relatedServices,
        "related_package": relatedPackage,
        "vendor_service_id": vendorServiceId,
        "vendor_user_id": vendorUserId,
        "category": category,
        "service_id": serviceId,
        "address": address,
        "material_desc": materialDesc,
        "company_name": companyName,
        "country_id": countryId,
        "state_id": stateId,
        "city_id": cityId,
        "pin_code": pinCode,
        "driver_name": driverName,
        "driver_mobile_no": driverMobileNo,
        "driver_kyc_type": driverKycType,
        "dricer_kyc_no": dricerKycNo,
        "driver_licence_no": driverLicenceNo,
        "driver_pincode": driverPincode,
        "driver_house_no": driverHouseNo,
        "driver_area": driverArea,
        "driver_landmark": driverLandmark,
        "driver_city": driverCity,
        "driver_state": driverState,
        "driver_image": driverImage,
        "dl_image": dlImage,
        "video": video,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class PopupCategory {
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
  Category? category;

  PopupCategory({
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

  factory PopupCategory.fromJson(Map<String, dynamic> json) => PopupCategory(
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
}

class Category {
  int? id;
  String? categoryName;
  String? categoryDescription;
  String? categoryStatus;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;

  Category({
    this.id,
    this.categoryName,
    this.categoryDescription,
    this.categoryStatus,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        categoryName: json["category_name"],
        categoryDescription: json["category_description"],
        categoryStatus: json["category_status"],
        image: json["image"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
        "category_description": categoryDescription,
        "category_status": categoryStatus,
        "image": image,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Reviews {
  int? avgRating;
  int? exactRating;
  int? totalNoOfRatings;
  List<dynamic>? listOfRatings;

  Reviews({
    this.avgRating,
    this.exactRating,
    this.totalNoOfRatings,
    this.listOfRatings,
  });

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
        avgRating: json["avg_rating"],
        exactRating: json["exact_rating"],
        totalNoOfRatings: json["total_no_of_ratings"],
        listOfRatings: json["list_of_ratings"] == null
            ? []
            : List<dynamic>.from(json["list_of_ratings"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "avg_rating": avgRating,
        "exact_rating": exactRating,
        "total_no_of_ratings": totalNoOfRatings,
        "list_of_ratings": listOfRatings == null
            ? []
            : List<dynamic>.from(listOfRatings!.map((x) => x)),
      };
}
