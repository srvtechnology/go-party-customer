class PaymentPostData {
  String paymentMethod;
  String paymentType;
  String addressId;
  String currentCity;
  double fullAmount;
  double partialAmount;
  PaymentPostData({
    required this.paymentMethod,
    required this.paymentType,
    required this.addressId,
    required this.currentCity,
    required this.fullAmount,
    required this.partialAmount,
  });
}
