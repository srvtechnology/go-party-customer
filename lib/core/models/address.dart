class AddressModel {
  int id;
  String? defaultAddress;
  int userId;
  String city;
  String state;
  String houseNumber;
  String billingName;
  String billingMobile;
  String forAddress;
  String address;
  double latitude;
  double longitude;
  String landmark;
  String country;
  String countryName;
  String area;
  String pinCode;
  String addressType;
  DateTime createdAt;
  DateTime updatedAt;

  AddressModel({
    required this.id,
    required this.defaultAddress,
    required this.userId,
    required this.city,
    required this.state,
    required this.houseNumber,
    required this.billingName,
    required this.billingMobile,
    required this.forAddress,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.landmark,
    required this.country,
    required this.countryName,
    required this.area,
    required this.pinCode,
    required this.addressType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      defaultAddress: json['default_address'],
      userId: json['user_id'],
      city: json['city'],
      state: json['state'],
      houseNumber: json['house_number'],
      billingName: json['billing_name'],
      billingMobile: json['billing_mobile'],
      forAddress: json['for_address'],
      address: json['address'],
      latitude: double.tryParse(json['lat']) ?? 0.0,
      longitude: double.tryParse(json['long']) ?? 0.0,
      landmark: json['landmark'],
      country: json['country'],
      countryName: json["country_name"],
      area: json['area'],
      pinCode: json['pin_code'],
      addressType: json['address_type'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
