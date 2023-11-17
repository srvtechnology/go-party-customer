import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerapp/core/Constant/themData.dart';
import 'package:customerapp/core/components/divider.dart';
import 'package:customerapp/core/routes/cart.dart';
import 'package:flutter/material.dart';

import 'package:customerapp/core/components/commonHeader.dart';
import 'package:customerapp/core/models/orders.dart';
import 'package:customerapp/core/routes/product.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderHistory extends StatelessWidget {
  static String routeName = "/orderHistory";
  final OrderModel order;

  const OrderHistory({
    Key? key,
    required this.order,
  }) : super(key: key);

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      right: 4.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          order.service.images[0],
                        ),
                      ),
                    ),
                    height: 40.w,
                    width: 40.w,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        order.service.name,
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        order.category.name,
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${order.houseNumber}, ${order.landmark}, ${order.area}, ${order.state}",
                        overflow: TextOverflow.visible,
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        children: [
                          Text(
                            "₹ ${order.totalPrice}",
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            "  ${order.service.priceBasis}",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        children: [
                          Text(
                            "Discount Price: ",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "₹ ${order.service.discountedPrice}",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const DashedDivider(),
                      Row(
                        children: [
                          Text(
                            "Price: ",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "₹ ${order.service.price}",
                            // price cut decoration

                            style: TextStyle(
                              fontSize: 16.sp,
                              decoration: TextDecoration.lineThrough,
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const DashedDivider(),
                      Row(
                        children: [
                          Text(
                            "Unit: ",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            order.service.priceBasis,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              height: 2.h,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              width: double.infinity,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shipping to ${order.billingName}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    order.address,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const DashedDivider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        margin: EdgeInsets.only(
                          right: 4.w,
                        ),
                        alignment: Alignment.center,
                        color: Colors.greenAccent,
                        child: const Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 15,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Delivered ${DateFormat('dd MMMM').format(DateTime.parse(order.eventDate))} ",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    'Rate your delivery experience',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  PannableRatingBar(
                    rate: 1,
                    items: List.generate(
                        5,
                        (index) => const RatingWidget(
                              selectedColor: Colors.yellow,
                              unSelectedColor: Colors.grey,
                              child: Icon(
                                Icons.star,
                                size: 36,
                              ),
                            )),
                    onChanged: (value) {
                      // the rating value is updated on tap or drag.
                    },
                  ),
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
      ),
    );
  }
}
