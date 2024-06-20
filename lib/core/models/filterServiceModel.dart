class FilterServicesModel {
  int id;
  String service;

  FilterServicesModel({
    required this.id,
    required this.service,
  });

  factory FilterServicesModel.fromJson(Map<String, dynamic> json) {
    return FilterServicesModel(
      id: json['id'] ?? 0,
      service: json['service'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service': service,
    };
  }
}
