import 'dart:developer';

import '../constant/themData.dart';
import 'package:customerapp/core/components/card.dart';
import 'package:customerapp/core/components/divider.dart';
import 'package:customerapp/core/components/loading.dart';
import 'package:customerapp/core/features/ccavenues/models/enc_val_res.dart';
import 'package:customerapp/core/features/ccavenues/patmentWebview.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/providers/orderProvider.dart';
import 'package:customerapp/core/repo/order.dart';
import 'package:customerapp/core/routes/cartPage.dart';
import 'package:customerapp/core/routes/mainpage.dart';
import 'package:flutter/material.dart';

import 'package:customerapp/core/components/commonHeader.dart';
import 'package:customerapp/core/models/orders.dart';
import 'package:customerapp/core/routes/product.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../utils/flush_bar_helper.dart';

class OrderInfoView extends StatefulWidget {
  static String routeName = "/orderDetailsView";
  final OrderModel order;

  const OrderInfoView({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderInfoView> createState() => _OrderInfoViewState();
}

class _OrderInfoViewState extends State<OrderInfoView> {
  bool isLoading = false;

  payNow(double amount) async {
    setState(() => isLoading = true);
    log(amount.toString(), name: "URL PAY");
    final auth = context.read<AuthProvider>();
    final res = await payRemainingOrder(auth,
            userID: auth.user!.id, amount: amount, orderID: widget.order.id)
        .whenComplete(() => setState(() => isLoading = false));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentWebView(
          generateOrderValue: GenerateOrderValue(
            orderId: int.parse(res!['partialSecondPayObject']['order_id']),
            accessCode: res['partialSecondPayObject']['access_code'],
            redirectUrl: res['partialSecondPayObject']['redirect_url'],
            cancelUrl: res['partialSecondPayObject']['cancel_url'],
            encVal: res['partialSecondPayObject']['enc_val'],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonHeader.header(
          context,
          onBack: () {
            Navigator.pop(context);
          },
          onSearch: () {
            Navigator.pushNamed(context, ProductPageRoute.routeName);
          },
        ),
        body: ListenableProvider(
          create: (_) => OrderProvider(context.read<AuthProvider>()),
          child: Consumer<OrderProvider>(builder: (context, state, child) {
            if (state.isLoading) {
              return const ShimmerWidget();
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'View Oders Details',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order date',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    'Order Id',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    'Order Total',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.order.eventDate,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    widget.order.orderId,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    /* "₹ ${widget.order.totalPrice}", */
                                    "₹ ${widget.order.totalPrice}",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        InkWell(
                          onTap: () async {
                            showCancelOrderDialog(context, widget.order.id);
                            /*context
                                .read<OrderProvider>()
                                .cancelOrder(context.read<AuthProvider>(),
                                    widget.order.id)
                                .whenComplete(() =>
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MainPageRoute(
                                                  index: 0,
                                                )),
                                        (route) => route.isFirst));*/
                          },
                          child: Column(
                            children: [
                              const DashedDivider(),
                              Row(
                                children: [
                                  Text(
                                    'Cancel Order',
                                    style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.arrow_forward_ios_rounded,
                                      size: 16),
                                ],
                              ),
                              const DashedDivider(),
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.h),
                  // shipping details
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    width: double.infinity,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shipping Details',
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                        const Divider(),
                        Text('Delivery ',
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w400)),
                        const Divider(),
                        Text(
                          'Not Yet Dispatched',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        /* Text(
                          'Delivery Estimate',
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w400),
                        ), */
                        Text(
                          'Event Dates',
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "Event Start Date: ${DateFormat('dd.MM.yyyy').format(DateTime.parse(widget.order.eventDate))} \nEvent End Date:   ${DateFormat('dd.MM.yyyy').format(DateTime.parse(widget.order.eventEndDate))}",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        OrderTile(
                          order: widget.order,
                          isShowPrice: true,
                        ),
                        // const Divider(),
                        // Row(
                        //   children: [
                        //     Text(
                        //       'Tracking Shipment',
                        //       style: TextStyle(
                        //           fontSize: 16.sp, fontWeight: FontWeight.w400),
                        //     ),
                        //     const Spacer(),
                        //     const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                        //   ],
                        // ),
                        // const Divider(),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    width: double.infinity,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Information',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Payment Method',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  (widget.order.paidStatus ?? 'Not Paid')
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            if (widget.order.paidStatus == "partial") ...[
                              // paid amount button
                              InkWell(
                                onTap: () async {
                                  await payNow(
                                      int.parse(widget.order.totalPrice) *
                                          0.75);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.h),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          'Pay Now',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ]
                            // const Icon(Icons.arrow_forward_ios_rounded,
                            //     size: 16)
                          ],
                        ),
                        const Divider(),
                        // billing address
                        Text(
                          'Billing Address',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          widget.order.billingName,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          widget.order.address,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    width: double.infinity,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shipping Address',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        SizedBox(height: 1.h),
                        Text(
                          widget.order.billingName,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          widget.order.address,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    width: double.infinity,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Summary',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Text(
                              'Item Total ',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "₹ ${widget.order.totalPrice}",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        // if (order.paidStatus == "partial")
                        //   Row(
                        //     children: [
                        //       Text(
                        //         'Paid Amount ',
                        //         style: TextStyle(
                        //           fontSize: 16.sp,
                        //           fontWeight: FontWeight.w600,
                        //           color: Colors.grey,
                        //         ),
                        //       ),
                        //       const Spacer(),

                        //       // 25% of total price
                        //       Text(
                        //         "₹ ${int.parse(order.totalPrice) * 0.25}",
                        //         style: TextStyle(
                        //           fontSize: 16.sp,
                        //           fontWeight: FontWeight.w500,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        widget.order.paidStatus == "partial"
                            ?
                            // remaining amount
                            Row(
                                children: [
                                  Text(
                                    'Remaining Amount ',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const Spacer(),

                                  // 25% of total price
                                  Text(
                                    "₹ ${int.parse(widget.order.totalPrice) * 0.75}",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Text(
                                    'Paid Total ',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "₹ ${widget.order.totalPrice}",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                        // total

                        const Divider(),
                        widget.order.paidStatus == "partial"
                            ? Row(
                                children: [
                                  Text(
                                    'Paid Amount ',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "₹ ${int.parse(widget.order.totalPrice) * 0.25}",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Text(
                                    'Paid Total ',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "₹ ${widget.order.totalPrice}",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                        const Divider(),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: const ExtraDetails(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            );
          }),
        ));
  }
}

Future<void> showCancelOrderDialog(BuildContext context, String orderId) async {
  final TextEditingController reasonController =
      TextEditingController(); // Controller to capture the input

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    // Prevents the dialog from being dismissed by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(''),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            /*const Text('Are you sure? You can\'t undo this.'),*/
            /* const SizedBox(height: 16),*/
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Enter reason:'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: reasonController,
              // Attach the controller to the TextField
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Reason for cancellation',
              ),
              maxLines: 5,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close', style: TextStyle(color: Colors.grey)),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () {
              final String reason = reasonController.text;
              if (reason.isNotEmpty) {
                context
                    .read<OrderProvider>()
                    .cancelOrder(context.read<AuthProvider>(), orderId, reason)
                    .whenComplete(() {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainPageRoute(index: 0),
                    ),
                    (route) => route.isFirst,
                  );
                });
              } else {
                FlushBarHelper.flushBarErrorMessage(
                    'Please enter reason before cancelling!', context);
              }
            },
          ),
        ],
      );
    },
  );
}
