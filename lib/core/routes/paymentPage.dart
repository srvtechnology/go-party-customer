// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../constant/themData.dart';
import 'package:customerapp/core/components/htmlTextView.dart';
import 'package:customerapp/core/features/ccavenues/models/enc_val_res.dart';
import 'package:customerapp/core/features/ccavenues/patmentWebview.dart';
import 'package:customerapp/core/models/addressModel.dart';
import 'package:customerapp/core/models/cartModel.dart';
import 'package:customerapp/core/repo/order.dart';
import 'package:customerapp/core/routes/mainpage.dart';
import 'package:customerapp/core/routes/profile.dart';
import 'package:customerapp/core/utils/addressFormater.dart';
import 'package:customerapp/core/utils/geolocator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:customerapp/core/models/paymentPostData.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';

import 'checkoutPage.dart';

class PaymentPage extends StatefulWidget {
  List<String> serviceIds;
  AddressModel? selectedAddress;
  double total;
  List<CartModel> cartItems;

  PaymentPage({
    Key? key,
    required this.serviceIds,
    required this.selectedAddress,
    required this.total,
    required this.cartItems,
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
  bool _isShowMore = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('CartItems : ${widget.cartItems}');
    }
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
              /* const SizedBox(
                height: 10,
              ), */
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.cartItems.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        //if length is 1 then show border bottom
                        border: Border(
                          bottom: BorderSide(
                            color: widget.cartItems.length == 1
                                ? Colors.transparent
                                : Colors.grey.withOpacity(0.5),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image of service
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(widget
                                              .cartItems[index]
                                              .service
                                              ?.images
                                              ?.first ??
                                          ''),
                                      fit: BoxFit.cover)),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 0,
                                  ),
                                  Text(
                                    widget.cartItems[index].service.name ?? "",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Days : ",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: widget.cartItems[index].days,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 600),
                                    child: Column(
                                      key: ValueKey<bool>(_isShowMore),
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 600),
                                          constraints: BoxConstraints(
                                            minHeight: 1.h,
                                            maxHeight: _isShowMore
                                                ? double.infinity
                                                : 10.h,
                                            minWidth: double.infinity,
                                            maxWidth: double.infinity,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 0.w,
                                          ),
                                          alignment: Alignment.centerLeft,
                                          child: SingleChildScrollView(
                                            physics: _isShowMore
                                                ? const NeverScrollableScrollPhysics()
                                                : null,
                                            child: HtmlTextView(
                                                htmlText: widget
                                                    .cartItems[index]
                                                    .service
                                                    .description),
                                          ),
                                        ),
                                        if (widget.cartItems[index].service
                                                .description.length >
                                            100)
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _isShowMore = !_isShowMore;
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 4.w,
                                              ),
                                              child: Text(
                                                _isShowMore
                                                    ? "Show Less"
                                                    : "Show More",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge!
                                                    .copyWith(
                                                        fontSize: 14,
                                                        color: primaryColor),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  /* --- commented for the fix below on : 29-07-24 --*/
                                  /*AnimatedContainer(
                                      constraints: BoxConstraints(
                                          minHeight: 1.h,
                                          maxHeight:
                                              _isShowMore ? double.infinity : 6.h,
                                          minWidth: double.infinity,
                                          maxWidth: double.infinity),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 0.w,
                                      ),
                                      alignment: Alignment.centerLeft,
                                      duration: const Duration(milliseconds: 600),
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          print(constraints.maxHeight.toString());
                                          return HtmlTextView(
                                              htmlText: widget.cartItems[index]
                                                  .service.description);
                                        },
                                      )),
                                  if (widget.cartItems[index].service.description.length > 100)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isShowMore = !_isShowMore;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 0.w,
                                        ),
                                        child: Text(
                                          _isShowMore ? "Show Less" : "Show More",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge!
                                              .copyWith(
                                                  fontSize: 14,
                                                  color: primaryColor),
                                        ),
                                      ),
                                    ),*/
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "₹ ${widget.cartItems[index].price}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: primaryColor),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
                          "Choose Delivery Address",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(), // This takes up all available space between the text and the button
                        ElevatedButton(
                          onPressed: () {
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutPage(
                                    serviceIds: widget.serviceIds,
                                    cartItems: widget.cartItems,
                                    cartSubTotal: widget.total,
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text(
                              "Change"), // You can customize this text
                        ),
                      ],
                    ),

                    /*    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (context.mounted) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CheckoutPage(
                                            serviceIds: widget.serviceIds,
                                            cartItems: widget.cartItems,
                                            cartSubTotal: widget.total,
                                          )));
                            }
                          },
                          child: Text(
                            "Choose Delivery Address",
                            style: TextStyle(
                                fontSize: 15.sp, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ), */
                    const Divider(),
                    const SizedBox(
                      height: 0,
                    ),
                    Text(
                      widget.selectedAddress?.billingName ?? "",
                      style: TextStyle(
                          fontSize: 16, color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Mobile: ${widget.selectedAddress?.billingMobile}",
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(getAddressFormat(widget.selectedAddress!)),
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
                          "Choose Payment Method",
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // CustomDropdown(
                    //     onChanged: (text) {
                    //       // if (text == "Online") {
                    //       //   setState(() {
                    //       //     showCard = true;
                    //       //   });
                    //       // } else {
                    //       //   setState(() {
                    //       //     showCard = false;
                    //       //   });
                    //       // }
                    //     },
                    //     hintText: "Select Payment Mode",
                    //     items: const ["Online"],
                    //     controller: _paymentModeController),

                    // radio button options for payment type 'complete' or 'partial' in variable _paymentTypeController and vartial amount is 25% of total amount
                    Column(
                      children: [
                        RadioListTile(
                          contentPadding: EdgeInsets.zero,
                          value: "Complete",
                          groupValue: _paymentTypeController.text,
                          onChanged: (text) {
                            setState(() {
                              _paymentTypeController.text = text.toString();
                            });
                          },
                          title: const Text("Complete"),
                        ),
                        RadioListTile(
                          contentPadding: EdgeInsets.zero,
                          value: "Partial",
                          groupValue: _paymentTypeController.text,
                          onChanged: (text) {
                            setState(() {
                              _paymentTypeController.text = text.toString();
                            });
                          },
                          title: const Text("Partial"),
                        ),
                        if (_paymentTypeController.text.contains("Partial"))
                          const Text(
                              "You have to pay 25 % of the total amount as a token. you can pay the remaining balance using cash or electronic payment method 24 hours before your services or event starts."),
                      ],
                    ),

                    // CustomDropdown(
                    //     onChanged: (p0) {
                    //       if (p0 == "Partial") {
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //             const SnackBar(
                    //                 content: Text(
                    //                     "25% of total amount will be paid now. Rest will be paid at the time of delivery")));
                    //       }
                    //       setState(() {});
                    //     },
                    //     hintText: "Select Payment Type",
                    //     items: const ["Complete", "Partial"],
                    //     controller: _paymentTypeController),
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
                                      ? "₹ ${(widget.total * 0.25 + widget.total * 0.25 * 0.18).toStringAsFixed(2)}"
                                      : "₹ ${(widget.total + widget.total * 0.18).toStringAsFixed(2)}",
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
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // policy Rich Text  for payment
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  text: const TextSpan(
                                text:
                                    '''When your order is placed, we'll send you an e-mail message acknowledging receipt of your order. If you choose to pay using an electronic payment method (credit card, debit card or net banking), you will be directed to your bank's website to complete your payment. Your contract to book a service will not be complete until we receive your electronic payment and successfully complete the service. If you choose to pay using a partial payment method, you can checkout to pay some amount of the total bill and you can pay the remaining balance using cash or electronic payment method 24 hours before your services starts.''',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              )),
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'See Utsavlife.com ',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Refund Policy.',
                                        style: const TextStyle(
                                          color: primaryColor,
                                          fontSize: 12,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushNamed(context,
                                                RefundPolicy.routeName);
                                          }),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                text: TextSpan(
                                  text:
                                      'Need to add more services to your order? Continue shopping on the',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: ' utsavlife homepage.',
                                        style: const TextStyle(
                                          color: primaryColor,
                                          fontSize: 12,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MainPageRoute()),
                                                (route) => route.isFirst);
                                          }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    /* if (showCard)
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Card Details",
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return "Required";
                                      }
                                      if (text.length != 16) {
                                        return "Please enter valid Card Number";
                                      }
                                      return null;
                                    },
                                    controller: _cardNumberController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide:
                                              const BorderSide(width: 0),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        labelText: "Enter Card Number"),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return "Required";
                                      }
                                      if (text.length != 3) {
                                        return "Please enter valid cvv";
                                      }
                                      return null;
                                    },
                                    controller: _cardNumberController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide:
                                              const BorderSide(width: 0),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        labelText: "CVV"),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ), */
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
        paymentType: _paymentTypeController.text.contains("Partial")
            ? "partial"
            : "completed",
        addressId: widget.selectedAddress?.id.toString() ?? "",
        currentCity: locationData["city"],
        fullAmount: widget.total + widget.total * 0.18,
        partialAmount: _paymentTypeController.text.contains("Partial")
            ? widget.total * 0.25 + widget.total * 0.25 * 0.18
            : 0,
      );
      if (auth.isAgent) {
        if (auth.user!.status != "A") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text("Your account is not active. Please contact admin")));
          setState(() {
            isloading = false;
          });
          return;
        }
      }

      await placeOrder(auth, data).then((value) {
        if (value == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text("There was something wrong. Please try again later")));
          return;
        }
        log(jsonEncode(value.toJson()), name: "/api/customer/address-submit");
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
