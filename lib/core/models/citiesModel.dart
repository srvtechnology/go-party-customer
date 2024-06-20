class FilterCitiesModel {
  String city;

  FilterCitiesModel({
    required this.city,
  });

  factory FilterCitiesModel.fromJson(Map<String, dynamic> json) {
    return FilterCitiesModel(
      city: json['city_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city_id': city,
    };
  }
}