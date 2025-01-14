import 'dart:developer';
import 'dart:ffi';

import '../constant/themData.dart';
import 'package:customerapp/core/components/card.dart';
import 'package:customerapp/core/components/divider.dart';
import 'package:customerapp/core/components/loading.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/providers/orderProvider.dart';
import 'package:customerapp/core/routes/cartPage.dart';
import 'package:customerapp/core/utils/addressFormater.dart';
import 'package:flutter/material.dart';

import 'package:customerapp/core/components/commonHeader.dart';
import 'package:customerapp/core/models/orders.dart';
import 'package:customerapp/core/routes/product.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../features/ccavenues/models/enc_val_res.dart';
import '../features/ccavenues/patmentWebview.dart';
import '../repo/order.dart';

class OrderSummary extends StatefulWidget {
  static String routeName = "/orderDetailsView";
  final OrderModel order;

  const OrderSummary({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    print(">>>>_OrderSummaryState");
    log(widget.order.id.toString(), name: "ORDER ID");
  }


  @override
  Widget build(BuildContext context) {
    print(">>>>summery order id${widget.order.orderId}");
    String order_Id=widget.order.orderId;
    double gprice=(double.parse(widget.order.totalPrice)*0.18);
    double tprice=gprice + double.parse(widget.order.totalPrice);
    print(">>>>remainin g amount ${widget.order.totalPrice} ${((int.parse(widget.order.totalPrice) + gprice)*0.75) .toStringAsFixed(2)}");


    OrderProvider(context.read<AuthProvider>());
    return Scaffold(
        appBar: CommonHeader.header(
          showBackButton: true,
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

            Future.delayed(Duration.zero, () {
              // Example: setting the orderId when the widget builds
              state.setOrderId(context,widget.order.id,context.read<AuthProvider>());
            });

            print(">>>>provider orderid${state.orderId}");

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
                          'View Order Details',
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
                                    DateFormat('dd/MM/yyyy').format(
                                        DateTime.parse("${widget.order?.eventDate}")),
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
                                    /*  "₹ ${widget.order.totalPrice}", */
                                    '₹ ${tprice.toStringAsFixed(2)}',
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
                            await context
                                .read<OrderProvider>()
                                .downloadAndOpenInvoicePdf(
                                    context,
                                    context.read<AuthProvider>(),
                                    widget.order.id);
                          },
                          child: Column(
                            children: [
                              const DashedDivider(),
                              Row(
                                children: [
                                  Text(
                                    'Download Invoice',
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.order.orderStatus == "2")
                              Text(
                                'Order Cancelled',
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              )
                            else if (widget.order.orderStatus == "1")
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order Pending',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      // Black for pending
                                    ),
                                  ),
                                  const SizedBox(
                                      height:
                                          1), // Space between text and divider
                                  const Divider(),
                                  const SizedBox(
                                      height:
                                          1), // Space between divider and the following text
                                  Text(
                                    'Event Start Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.order.eventDate))}',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Event End Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.order.eventEndDate))}',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            else ...[
                              Text(
                                'Order Received on ${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.order.eventDate))}\n',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .primaryColor, // Adjust color as needed
                                ),
                              ),
                              Text(
                                'Order Delivered on ${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.order.eventEndDate))}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors
                                      .green, // Green for "Order Delivered on"
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 2.h),
                        OrderTile(
                          order: widget.order,
                          isShowPrice: true,
                        ),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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

                                  double amt = double.parse(
                                      ((double.parse(widget.order.totalPrice) + gprice) * 0.75)
                                          .toStringAsFixed(2));
                                  await payNow(amt);

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
                                          'Pay Now ',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ]
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
                          getAddressFormatOrder(widget.order),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                          getAddressFormatOrder(widget.order),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                              'Order Total ',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "₹ ${tprice.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
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
                                  Text("₹ ${((int.parse(widget.order.totalPrice) + gprice)*0.75) .toStringAsFixed(2)}", style: TextStyle(
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
                                    '₹ ${tprice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
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
                                    "₹ ${(int.parse(widget.order.totalPrice) +gprice)*0.25}",
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
                                    "₹ ${widget.order?.totalPrice}",
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
                  const ExtraDetails(
                    color: Colors.white,
                  )
                ],
              ),
            );
          }),
        ));
  }



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
}
