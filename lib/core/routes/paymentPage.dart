import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:customerapp/core/Constant/themData.dart';
import 'package:customerapp/core/features/ccavenues/models/enc_val_res.dart';
import 'package:customerapp/core/features/ccavenues/patmentWebview.dart';
import 'package:customerapp/core/models/address.dart';
import 'package:customerapp/core/repo/order.dart';
import 'package:customerapp/core/utils/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:customerapp/core/models/paymentPostData.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';

class PaymentPage extends StatefulWidget {
  AddressModel? selectedAddress;
  double total;
  PaymentPage({
    Key? key,
    required this.selectedAddress,
    required this.total,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _paymentModeController =
      TextEditingController(text: "Online");
  final TextEditingController _paymentTypeController =
      TextEditingController(text: "Complete");
  final TextEditingController _cardNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showCard = true;
  bool isloading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        elevation: 0,
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: const [
                        CircleAvatar(
                          radius: 10,
                          child: Icon(
                            Icons.check,
                            size: 10,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Cart",
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                    Column(
                      children: const [
                        CircleAvatar(
                          radius: 10,
                          child: Icon(
                            Icons.check,
                            size: 10,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Select Address",
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                    Column(
                      children: const [
                        CircleAvatar(
                          radius: 10,
                          child: Icon(
                            Icons.circle,
                            size: 10,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Payment",
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                    Column(
                      children: const [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.grey,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Order Placed",
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Delivery Address",
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.selectedAddress?.billingName ?? "",
                      style: TextStyle(
                          fontSize: 16, color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      widget.selectedAddress?.addressType ?? "",
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Text(
                        "${widget.selectedAddress?.houseNumber ?? ''}, ${widget.selectedAddress?.landmark ?? ''}, ${widget.selectedAddress?.area ?? ''}, ${widget.selectedAddress?.state ?? ''}"),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Payment Details",
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomDropdown(
                        onChanged: (text) {
                          // if (text == "Online") {
                          //   setState(() {
                          //     showCard = true;
                          //   });
                          // } else {
                          //   setState(() {
                          //     showCard = false;
                          //   });
                          // }
                        },
                        hintText: "Select Payment Mode",
                        items: const ["Online"],
                        controller: _paymentModeController),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomDropdown(
                        onChanged: (p0) {
                          if (p0 == "Partial") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "25% of total amount will be paid now. Rest will be paid at the time of delivery")));
                          }
                          setState(() {});
                        },
                        hintText: "Select Payment Type",
                        items: const ["Complete", "Partial"],
                        controller: _paymentTypeController),
                    const SizedBox(
                      height: 20,
                    ),
                    // show total amount
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              Text(
                                'Total Price ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Distribution ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Price",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                _paymentTypeController.text.contains("Partial")
                                    ? "₹ ${widget.total * 0.25}"
                                    : "₹ ${widget.total}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Tax",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "+ 18% GST",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            color: Colors.grey.withOpacity(0.6),
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total Amount",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  _paymentTypeController.text
                                          .contains("Partial")
                                      ? "₹ ${widget.total * 0.25 + widget.total * 0.25 * 0.18}"
                                      : "₹ ${widget.total + widget.total * 0.18}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: InkWell(
                                onTap: isloading
                                    ? null
                                    : () {
                                        submit(context.read<AuthProvider>());
                                      },
                                child: Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                  child: isloading
                                      ? const Text(
                                          'Loading...',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : const Text(
                                          "Place Order",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ),
                              ))
                            ],
                          )
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    // if (showCard)
                    //   Form(
                    //     key: _formKey,
                    //     child: Column(
                    //       children: [
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.start,
                    //           children: [
                    //             const SizedBox(
                    //               width: 5,
                    //             ),
                    //             Text(
                    //               "Card Details",
                    //               style: TextStyle(
                    //                   fontSize: 15.sp,
                    //                   fontWeight: FontWeight.w600),
                    //             )
                    //           ],
                    //         ),
                    //         const SizedBox(
                    //           height: 10,
                    //         ),
                    //         Row(
                    //           children: [
                    //             Expanded(
                    //               flex: 3,
                    //               child: TextFormField(
                    //                 validator: (text) {
                    //                   if (text == null || text.isEmpty) {
                    //                     return "Required";
                    //                   }
                    //                   if (text.length != 16) {
                    //                     return "Please enter valid Card Number";
                    //                   }
                    //                   return null;
                    //                 },
                    //                 controller: _cardNumberController,
                    //                 decoration: InputDecoration(
                    //                     border: OutlineInputBorder(
                    //                       borderSide:
                    //                           const BorderSide(width: 0),
                    //                       borderRadius:
                    //                           BorderRadius.circular(15),
                    //                     ),
                    //                     labelText: "Enter Card Number"),
                    //               ),
                    //             ),
                    //             const SizedBox(
                    //               width: 20,
                    //             ),
                    //             Expanded(
                    //               child: TextFormField(
                    //                 validator: (text) {
                    //                   if (text == null || text.isEmpty) {
                    //                     return "Required";
                    //                   }
                    //                   if (text.length != 3) {
                    //                     return "Please enter valid cvv";
                    //                   }
                    //                   return null;
                    //                 },
                    //                 controller: _cardNumberController,
                    //                 decoration: InputDecoration(
                    //                     border: OutlineInputBorder(
                    //                       borderSide:
                    //                           const BorderSide(width: 0),
                    //                       borderRadius:
                    //                           BorderRadius.circular(15),
                    //                     ),
                    //                     labelText: "CVV"),
                    //               ),
                    //             ),
                    //             const SizedBox(
                    //               width: 20,
                    //             ),
                    //           ],
                    //         ),
                    //         const SizedBox(
                    //           height: 30,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submit(AuthProvider auth) async {
    if (_paymentTypeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select payment type")));
      return;
    }
    log(_paymentTypeController.text, name: "paymentType");
    log(
        (_paymentTypeController.text.contains("Partial")
                ? widget.total * 0.25
                : 0)
            .toString(),
        name: "Amount");
    setState(() {
      isloading = true;
    });
    try {
      Map locationData = await getCountryCityState();
      PaymentPostData data = PaymentPostData(
        paymentMethod: "ONLINE",
        //   _paymentModeController.text.contains("Cash") ? "cod" : "online",
        paymentType: _paymentTypeController.text.contains("Partial")
            ? "partial"
            : "completed",
        addressId: widget.selectedAddress?.id.toString() ?? "",
        currentCity: locationData["city"],
        fullAmount: widget.total + widget.total * 0.18,
        // 25% of total amount
        partialAmount: _paymentTypeController.text.contains("Partial")
            ? widget.total * 0.25 + widget.total * 0.25 * 0.18
            : 0,
      );

      await placeOrder(auth, data).then((value) {
        if (value == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text("There was something wrong. Please try again later")));
          return;
        }
        log(value.fullPayObject!.encVal.toString(), name: "fullPayObject");
        log(value.partialPayObject!.encVal.toString(),
            name: "partialPayObject");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentWebView(
              generateOrderValue: GenerateOrderValue(
                orderId: value.orderId,
                accessCode: !_paymentTypeController.text.contains("Partial")
                    ? value.fullPayObject!.accessCode
                    : value.partialPayObject!.accessCode,
                redirectUrl: !_paymentTypeController.text.contains("Partial")
                    ? value.fullPayObject!.redirectUrl
                    : value.partialPayObject!.redirectUrl,
                cancelUrl: !_paymentTypeController.text.contains("Partial")
                    ? value.fullPayObject!.cancelUrl
                    : value.partialPayObject!.cancelUrl,
                encVal: !_paymentTypeController.text.contains("Partial")
                    ? value.fullPayObject!.encVal
                    : value.partialPayObject!.encVal,
              ),
            ),
          ),
        );
      }).whenComplete(() => setState(() => isloading = false));

      setState(() {
        isloading = false;
      });
    } catch (e) {
      setState(() => isloading = false);
      log(e.toString(), name: "PaymentPage");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("There was something wrong. Please try again later")));
    }
  }
}
