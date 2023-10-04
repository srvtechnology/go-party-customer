import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:customerapp/core/features/ccavenues/models/enc_val_res.dart';
import 'package:customerapp/core/features/ccavenues/patmentWebview.dart';
import 'package:customerapp/core/repo/order.dart';
import 'package:customerapp/core/utils/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:customerapp/core/models/paymentPostData.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';

class PaymentPage extends StatefulWidget {
  String addressId;
  double total;
  PaymentPage({
    Key? key,
    required this.addressId,
    required this.total,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _paymentModeController =
      TextEditingController(text: "Online");
  final TextEditingController _paymentTypeController = TextEditingController();
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
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Theme.of(context).primaryColorLight,
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
                    CustomDropdown(
                        hintText: "Select Payment Type",
                        items: const ["Complete", "Partial"],
                        controller: _paymentTypeController),
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
        addressId: widget.addressId,
        currentCity: locationData["city"], fullAmount: widget.total,
        // 25% of total amount
        partialAmount: widget.total * 0.25,
      );
      await placeOrder(auth, data).then((value) {
        if (value == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text("There was something wrong. Please try again later")));
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentWebView(
              generateOrderValue: GenerateOrderValue(
                orderId: value.orderId,
                accessCode: _paymentTypeController.text.contains("completed")
                    ? value.fullPayObject!.accessCode
                    : value.partialPayObject!.accessCode,
                redirectUrl: _paymentTypeController.text.contains("completed")
                    ? value.fullPayObject!.redirectUrl
                    : value.partialPayObject!.redirectUrl,
                cancelUrl: _paymentTypeController.text.contains("completed")
                    ? value.fullPayObject!.cancelUrl
                    : value.partialPayObject!.cancelUrl,
                encVal: _paymentTypeController.text.contains("completed")
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
