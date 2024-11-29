class SingleOrder {
  final int id;
  final String paymentType;
  final String customerUserId;
  final String address;
  final String lat;
  final String long;
  final String landmark;
  final String area;
  final String pinCode;
  final String addressType;
  final String state;
  final String houseNumber;
  final String billingName;
  final String billingMobile;
  final String customerEmail;
  final String customerPhone;
  final String forAddress;
  final String vendorOrderStatus;
  final String services;
  final int categoryId;
  final double price;
  final int quantity;
  final double totalPrice;
  final String eventDate;
  final String eventEndDate;
  final String eventCity;
  final String eventAddress;
  final String eventPin;
  final String txnNo;
  final String orderId;
  final String paymentStatus;
  final String progressStatus;
  final String orderStatus;
  final String paidStatus;
  final String totalPriceWithGst;

  SingleOrder({
    required this.id,
    required this.paymentType,
    required this.customerUserId,
    required this.address,
    required this.lat,
    required this.long,
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
    required this.vendorOrderStatus,
    required this.services,
    required this.categoryId,
    required this.price,
    required this.quantity,
    required this.totalPrice,
    required this.eventDate,
    required this.eventEndDate,
    required this.eventCity,
    required this.eventAddress,
    required this.eventPin,
    required this.txnNo,
    required this.orderId,
    required this.paymentStatus,
    required this.progressStatus,
    required this.orderStatus,
    required this.paidStatus,
    required this.totalPriceWithGst,
  });

  factory SingleOrder.fromJson(Map<String, dynamic> json) {
    return SingleOrder(
      id: json['id'],
      paymentType: json['payment_type'],
      customerUserId: json['customer_user_id'],
      address: json['address'],
      lat: json['lat'],
      long: json['long'],
      landmark: json['landmark'],
      area: json['area'],
      pinCode: json['pin_code'],
      addressType: json['address_type'],
      state: json['state'],
      houseNumber: json['house_number'],
      billingName: json['billing_name'],
      billingMobile: json['billing_mobile'],
      customerEmail: json['customer_email'],
      customerPhone: json['customer_phone'],
      forAddress: json['for_address'],
      vendorOrderStatus: json['vandor_order_status'],
      services: json['services'],
      categoryId: json['category_id'],
      price: double.parse(json['price']),
      quantity: json['quantity'],
      totalPrice: double.parse(json['total_price']),
      eventDate: json['event_date'],
      eventEndDate: json['event_end_date'],
      eventCity: json['event_city'],
      eventAddress: json['event_address'],
      eventPin: json['event_pin'],
      txnNo: json['txn_no'],
      orderId: json['order_id'],
      paymentStatus: json['payment_status'],
      progressStatus: json['progress_status'],
      orderStatus: json['order_status'].toString(),
      paidStatus: json['paid_status'],
      totalPriceWithGst: json['total_price_with_gst'],
    );
  }
}
