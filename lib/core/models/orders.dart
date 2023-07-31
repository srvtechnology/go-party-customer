class OrderModel {
  String id;
  String paymentType;
  String customerUserId;
  String address;
  String landmark;
  String area;
  String pinCode;
  String addressType;
  String state;
  String houseNumber;
  String billingName;
  String billingMobile;
  String customerEmail;
  String customerPhone;
  String forAddress;
  String vandorOrderStatus;
  String services;
  String categoryId;
  String price;
  String quantity;
  String totalPrice;
  String time;
  String days;
  String eventDate;
  String eventEndDate;
  String eventCity;
  String eventAddress;
  String orderId;

  OrderModel({
    required this.id,
    required this.paymentType,
    required this.customerUserId,
    required this.address,
    required this.landmark,
    required this.area,
    required this.pinCode,
    required this.addressType,
    required this.state,
    required this.houseNumber,
    required this.billingName,
    required this.billingMobile,
    required this.customerEmail,
    required this.customerPhone,
    required this.forAddress,
    required this.vandorOrderStatus,
    required this.services,
    required this.categoryId,
    required this.price,
    required this.quantity,
    required this.totalPrice,
    required this.time,
    required this.days,
    required this.eventDate,
    required this.eventEndDate,
    required this.eventCity,
    required this.eventAddress,
    required this.orderId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'].toString(),
      paymentType: json['payment_type'].toString(),
      customerUserId: json['customer_user_id'].toString(),
      address: json['address'].toString(),
      landmark: json['landmark'].toString(),
      area: json['area'].toString(),
      pinCode: json['pin_code'].toString(),
      addressType: json['address_type'].toString(),
      state: json['state'].toString(),
      houseNumber: json['house_number'].toString(),
      billingName: json['billing_name'].toString(),
      billingMobile: json['billing_mobile'].toString(),
      customerEmail: json['customer_email'].toString(),
      customerPhone: json['customer_phone'].toString(),
      forAddress: json['for_address'].toString(),
      vandorOrderStatus: json['vandor_order_status'].toString(),
      services: json['services'].toString(),
      categoryId: json['category_id'].toString(),
      price: json['price'].toString(),
      quantity: json['quantity'].toString(),
      totalPrice: json['total_price'].toString(),
      time: json['time'].toString(),
      days: json['days'].toString(),
      eventDate: json['event_date'].toString(),
      eventEndDate: json['event_end_date'].toString(),
      eventCity: json['event_city'].toString(),
      eventAddress: json['event_address'].toString(),
      orderId: json['order_id'].toString(),
    );
  }
}
