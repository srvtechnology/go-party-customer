import 'package:cached_network_image/cached_network_image.dart';
import '../constant/themData.dart';
import 'package:customerapp/core/components/commonHeader.dart';
import 'package:customerapp/core/components/divider.dart';
import 'package:customerapp/core/components/loading.dart';
import 'package:customerapp/core/models/orders.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/providers/orderProvider.dart';
import 'package:customerapp/core/routes/cartPage.dart';
import 'package:customerapp/core/routes/mainpage.dart';
import 'package:customerapp/core/routes/orderInfoView.dart';
import 'package:customerapp/core/routes/product.dart';
import 'package:customerapp/core/routes/singleService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:timelines/timelines.dart';

import '../utils/flush_bar_helper.dart';

class OrderStatusPage extends StatefulWidget {
  final OrderModel order;

  const OrderStatusPage({super.key, required this.order});

  @override
  State<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> {
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
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SingleServiceRoute(
                                    service: widget.order.service)));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Arriving ${DateFormat('dd MMM yy').format(DateTime.parse(widget.order.eventDate))}',
                              style: const TextStyle(
                                fontSize: 20,
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              right: 0.w,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                  widget.order.service.images![0],
                                ),
                              ),
                            ),
                            height: 20.w,
                            width: 20.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                    ),
                    margin: const EdgeInsets.only(
                      bottom: 5,
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TimelineTile(
                            nodeAlign: TimelineNodeAlign.start,
                            mainAxisExtent: 60,
                            contents: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                // order date here
                                'Order ${DateFormat('dd MMM yy').format(DateTime.parse(widget.order.eventDate))}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            node: const TimelineNode(
                              indicator: DotIndicator(
                                color: primaryColor,
                                size: 30,
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                              ),
                              // startConnector: SolidLineConnector(),
                              endConnector: DashedLineConnector(
                                thickness: 3,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          TimelineTile(
                            nodeAlign: TimelineNodeAlign.start,
                            mainAxisExtent: 60,
                            contents: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                'Arriving ${DateFormat('dd MMM yy').format(DateTime.parse(widget.order.eventEndDate))}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            node: const TimelineNode(
                              indicator: OutlinedDotIndicator(
                                color: Colors.grey,
                                size: 30,
                              ),
                              startConnector: DashedLineConnector(
                                thickness: 3,
                                color: Colors.grey,
                              ),
                              // endConnector: SolidLineConnector(),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // cancel button here
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 50,
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showCancelOrderDialog(
                                        context, widget.order.id);
                                    /*context
                                        .read<OrderProvider>()
                                        .cancelOrder(
                                            context.read<AuthProvider>(),
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
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: const BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Cancel Order',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Shipping Address',
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
                  Container(
                    color: primaryColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Order Info',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        InkWell(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderInfoView(
                                  order: widget.order,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              const DashedDivider(
                                color: Colors.white,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'View Order Details',
                                    style: TextStyle(
                                        fontSize: 17.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.arrow_forward_ios_rounded,
                                      size: 16, color: Colors.white),
                                ],
                              ),
                              const DashedDivider(
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                  const ExtraDetails(),
                ],
              ),
            );
          })),
    );
  }
}

Future<void> showCancelOrderDialog(BuildContext context, String orderId) async {
  final TextEditingController reasonController =
      TextEditingController(); // Controller to capture the input

  return showDialog<void>(
    context: context,
    barrierDismissible:
        false, // Prevents the dialog from being dismissed by tapping outside
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
              controller:
                  reasonController, // Attach the controller to the TextField
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
