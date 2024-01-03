import 'package:customerapp/core/models/address.dart';

String getAddressFormat(AddressModel address) {
  return "${address.houseNumber} \n${address.area} \n${address.address.toString() == "0" ? "" : "${address.address}\n"}${address.landmark}, \n${address.city}, ${address.state} ${address.pinCode}  \n${address.countryName} \n${address.billingMobile}";
  // "${address.houseNumber}, ${address.landmark}, \n${address.area} , ${address.city}, \n${address.state} ${address.pinCode}  ${address.countryName}";
}
