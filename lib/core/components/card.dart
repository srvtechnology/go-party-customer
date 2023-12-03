import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerapp/core/Constant/themData.dart';
import 'package:customerapp/core/components/divider.dart';
import 'package:customerapp/core/components/htmlTextView.dart';
import 'package:customerapp/core/routes/orderHistory.dart';
import 'package:customerapp/core/routes/orderInfoView.dart';
import 'package:customerapp/core/routes/singleService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../models/orders.dart';
import '../models/package.dart';
import '../models/service.dart';
import '../providers/AuthProvider.dart';
import '../repo/services.dart';
import '../utils/logger.dart';

typedef OnTap = void Function();

class OrderCard extends StatelessWidget {
  ServiceModel service;
  OnTap? onTap;
  OrderCard({Key? key, required this.service, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          right: 5.w,
        ),
        height: 28.h,
        width: 50.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 4,
                child: Hero(
                  tag: "Product Image ${service.id}",
                  child: Container(
                    height: 20.h,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(1, 1),
                              spreadRadius: 2,
                              blurRadius: 2,
                              color: Colors.grey[400]!),
                        ],
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: CachedNetworkImageProvider(
                              service.images[0],
                            ))),
                  ),
                )),
            SizedBox(
              height: 1.h,
            ),
            Expanded(
                child: Row(
              children: [
                Expanded(
                  child: Text(service.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16,
                          color: textColor,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            )),
            // Expanded(
            //     child: HtmlTextView(
            //   htmlText: service.description,
            // )
            //     // FittedBox(
            //     //     child: Text(
            //     //   "${service.description.substring(0, min(26, service.description.length))} ...",
            //     //   overflow: TextOverflow.visible,
            //     //   textAlign: TextAlign.left,
            //     //   style: const TextStyle(fontSize: 14, color: textColor),
            //     // )),
            //     ),
            // short description of the product
            const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, color: textColor)),
            SizedBox(
              height: 1.h,
            ),
            Expanded(
              child: Text("₹ ${service.discountedPrice}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).primaryColorDark)),
            ),
          ],
        ),
      ),
    );
  }
}

class PackageCard extends StatelessWidget {
  PackageModel package;
  OnTap? onTap;
  PackageCard({Key? key, required this.package, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          right: 5.w,
        ),
        height: 28.h,
        width: 50.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 4,
                child: Container(
                  height: 20.h,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(1, 1),
                            spreadRadius: 2,
                            blurRadius: 2,
                            color: Colors.grey[400]!),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: CachedNetworkImageProvider(
                            package.images[0],
                          ))),
                )),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: Row(
              children: [
                Expanded(
                  child: Text(
                    package.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16,
                        color: textColor,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            )),
            const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, color: textColor)),
            // Expanded(
            //   child: Html(
            //     data: package.description,
            //   ),
            // ),
            // Expanded(
            //     child: HtmlTextView(
            //   htmlText: package.description,
            // )
            //     // FittedBox(
            //     //     child: Text(
            //     //   "${package.description.substring(0, min(26, package.description.length))} ...",
            //     //   overflow: TextOverflow.visible,
            //     //   textAlign: TextAlign.left,
            //     //   style: const TextStyle(fontSize: 14, color: textColor),
            //     // )),
            //     ),
            SizedBox(
              height: 1.h,
            ),
            Expanded(
              child: Text("₹ ${package.discountedPrice}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).primaryColorDark)),
            ),
          ],
        ),
      ),
    );
  }
}

class PackageTile extends StatelessWidget {
  final PackageModel package;
  final OnTap? onTap;
  const PackageTile({Key? key, required this.package, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        height: 22.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: const Offset(1, 1),
                blurRadius: 1,
                color: Colors.grey[300]!),
            BoxShadow(
                offset: const Offset(-1, -1),
                blurRadius: 1,
                color: Colors.grey[300]!)
          ],
          borderRadius: BorderRadius.circular(5),
        ),
        // margin: EdgeInsets.symmetric(vertical: 5, horizontal: 4.w),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36.w,
              // margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(package.images[0]))),
            ),
            SizedBox(
              width: 5.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      package.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    child: HtmlTextView(
                      htmlText: package.description,
                    ),
                  ),
                  Expanded(
                      child: Row(
                    children: [
                      Text(
                        "₹ ${package.price}",
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // unit == "per hour"
                      // Text(
                      //   " / ${package.priceBasis}",
                      //   style: TextStyle(
                      //     fontSize: 14.sp,
                      //     color: Colors.grey,
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                    ],
                  )),
                  // add to cart button
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          onPressed: () {
                            if (onTap != null) {
                              onTap!();
                            }
                          },
                          child: const Text("Add to Cart"),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),
            // Expanded(
            //     child: Row(
            //   children: [
            //     Expanded(
            //       child: ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //             backgroundColor: Theme.of(context).primaryColorDark),
            //         onPressed: () {
            //           if (onTap != null) {
            //             onTap!();
            //           }
            //         },
            //         child: const Text("View Details"),
            //       ),
            //     ),
            //   ],
            // )),
          ],
        ),
      ),
    );
    // return Container(
    //   margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
    //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    //   decoration: BoxDecoration(
    //     color: Colors.white,
    //     borderRadius: BorderRadius.circular(15),
    //     boxShadow: [
    //       BoxShadow(
    //           offset: const Offset(1, 1),
    //           blurRadius: 1,
    //           color: Colors.grey[300]!),
    //       BoxShadow(
    //           offset: const Offset(-1, -1),
    //           blurRadius: 1,
    //           color: Colors.grey[300]!)
    //     ],
    //   ),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Container(
    //         height: 20.h,
    //         decoration: BoxDecoration(
    //             boxShadow: [
    //               BoxShadow(
    //                   offset: const Offset(1, 1),
    //                   spreadRadius: 2,
    //                   blurRadius: 2,
    //                   color: Colors.grey[400]!),
    //             ],
    //             borderRadius: BorderRadius.circular(10),
    //             image: DecorationImage(
    //                 fit: BoxFit.fitHeight,
    //                 image: CachedNetworkImageProvider(
    //                   package.images[0],
    //                 ))),
    //       ),
    //       const SizedBox(
    //         height: 10,
    //       ),
    //       Row(
    //         children: [
    //           Text(
    //             package.name,
    //             style:
    //                 const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    //           ),
    //         ],
    //       ),
    //       FittedBox(
    //           child: Text(
    //         "${package.description.substring(0, min(26, package.description.length))} ...",
    //         overflow: TextOverflow.visible,
    //         textAlign: TextAlign.left,
    //       )),
    //       const SizedBox(
    //         height: 10,
    //       ),
    //       Text("₹ ${package.discountedPrice}",
    //           style: TextStyle(
    //               fontWeight: FontWeight.bold,
    //               fontSize: 18,
    //               color: Theme.of(context).primaryColorDark)),
    //       Center(
    //         child: SizedBox(
    //           width: 200,
    //           child: ElevatedButton(
    //             onPressed: () {
    //               onTap!();
    //             },
    //             child: const Text("View"),
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}

class CircularOrderCard extends StatelessWidget {
  final ServiceModel service;
  const CircularOrderCard({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 2.w),
      width: 24.w,
      height: 18.h,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SingleServiceRoute(service: service)));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 1.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 10.h,
                width: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2,
                        color: Colors.grey[400]!,
                        spreadRadius: 1)
                  ],
                ),
                child: CircleAvatar(
                  // radius: 40,
                  backgroundImage:
                      CachedNetworkImageProvider(service.images[0]),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Expanded(
                child: Text(
                  service.name,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: textColor,
                      fontSize: 12),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CircularEventCard extends StatelessWidget {
  final EventModel event;
  const CircularEventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 2.w),
      child: Column(
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(event.image),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Text(
            event.name,
            style:
                const TextStyle(fontWeight: FontWeight.w500, color: textColor),
          )
        ],
      ),
    );
  }
}

class OrderTile extends StatefulWidget {
  OrderModel order;
  bool review;
  bool isShowPrice;
  bool isDelivered;
  OrderTile(
      {Key? key,
      required this.order,
      this.review = false,
      this.isShowPrice = false,
      this.isDelivered = false})
      : super(key: key);

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  final TextEditingController _reviewMessage = TextEditingController();
  double rating = 0.0;
  Future<void> _writeReview() async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            // padding: EdgeInsets.only(
            //     bottom: MediaQuery.of(context).viewInsets.bottom),
            child: StatefulBuilder(builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Rate the service",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: PannableRatingBar(
                        rate: rating,
                        items: List.generate(
                            5,
                            (index) => const RatingWidget(
                                  selectedColor: Colors.yellow,
                                  unSelectedColor: Colors.grey,
                                  child: Icon(
                                    Icons.star,
                                    size: 30,
                                  ),
                                )),
                        onChanged: (value) {
                          // the rating value is updated on tap or drag.
                          setState(() {
                            rating = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: TextFormField(
                        onFieldSubmitted: (text) {
                          FocusScope.of(context).unfocus();
                        },
                        controller: _reviewMessage,
                        maxLines: 4,
                        minLines: 3,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            labelText: "Write a review ..."),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        child: const Text("Submit Review"),
                        onPressed: () async {
                          try {
                            await writeReview(
                                context.read<AuthProvider>(),
                                widget.order.id,
                                rating.toString(),
                                _reviewMessage.text);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Review Successfully Added")));
                              Navigator.pop(context);
                            }
                          } catch (e) {
                            CustomLogger.error(e);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Some Error Occured. Please try again later")));
                            }
                          }
                        },
                      ),
                    )
                  ],
                ),
              );
            }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isDelivered) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderHistory(
                order: widget.order,
              ),
            ),
          );
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderInfoView(
              order: widget.order,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 19.h, maxHeight: 21.h),
        margin:
            widget.isShowPrice ? null : EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16.h,
                  width: 40.w,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                            widget.order.service.images[0])),
                  ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.order.service.name,
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        widget.order.category.name,
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${widget.order.houseNumber}, ${widget.order.landmark}, ${widget.order.area}, ${widget.order.state}",
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      widget.isShowPrice
                          ? Row(
                              children: [
                                Text(
                                  "₹ ${widget.order.totalPrice}",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  "  ${widget.order.service.priceBasis}",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              '${DateFormat('dd MMM yy').format(DateTime.parse(widget.order.eventDate))} To ${DateFormat('dd MMM yy').format(DateTime.parse(widget.order.eventEndDate))}'
                                  .toUpperCase(),
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).primaryColorDark),
                            ),
                    ],
                  ),
                ),

                // const SizedBox(
                //   height: 5,
                // ),

                // const SizedBox(
                //   height: 5,
                // ),
                // Container(
                //   padding: const EdgeInsets.all(5),
                //   child: Text(
                //     "₹ ${widget.order.totalPrice}",
                //     style: TextStyle(
                //         fontSize: 20,
                //         color: Theme.of(context).primaryColor,
                //         fontWeight: FontWeight.w500),
                //   ),
                // ),
                // if (widget.review)
                //   Center(
                //     child: ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //             shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(20))),
                //         onPressed: () {
                //           _writeReview();
                //         },
                //         child: const Text("Write a Review")),
                //   )
              ],
            ),
            if (!widget.isShowPrice) const DashedDivider(),
          ],
        ),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  ServiceModel service;
  Function? onTap;
  ProductTile({Key? key, required this.service, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        height: 22.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: const Offset(1, 1),
                blurRadius: 1,
                color: Colors.grey[300]!),
            BoxShadow(
                offset: const Offset(-1, -1),
                blurRadius: 1,
                color: Colors.grey[300]!)
          ],
          // borderRadius: BorderRadius.circular(5),
        ),
        // margin: EdgeInsets.symmetric(vertical: 5, horizontal: 4.w),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36.w,
              // margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(service.images[0]))),
            ),
            SizedBox(
              width: 5.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      service.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    child: HtmlTextView(
                      htmlText: service.description,
                    ),
                  ),
                  Expanded(
                      child: Row(
                    children: [
                      Text(
                        "₹ ${service.price}",
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // unit == "per hour"
                      Text(
                        " / ${service.priceBasis}",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )),
                  // add to cart button
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          onPressed: () {
                            if (onTap != null) {
                              onTap!();
                            }
                          },
                          child: const Text("Add to Cart"),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),
            // Expanded(
            //     child: Row(
            //   children: [
            //     Expanded(
            //       child: ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //             backgroundColor: Theme.of(context).primaryColorDark),
            //         onPressed: () {
            //           if (onTap != null) {
            //             onTap!();
            //           }
            //         },
            //         child: const Text("View Details"),
            //       ),
            //     ),
            //   ],
            // )),
          ],
        ),
      ),
    );
  }
}

class ReviewTile extends StatelessWidget {
  final ReviewModel e;
  const ReviewTile({Key? key, required this.e}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
                child: Text(
                  e.name.substring(0, 1),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    Text(
                      e.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: Color.fromARGB(255, 212, 119, 61),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      e.rating,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 1,
                ),
                const Text(
                  "Review viewed 6 months ago",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600),
                ),
              ])
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            e.message,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(vertical: 2.h),
              child: const DashedDivider())
        ])
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Row(
        //       children: [
        //         CircleAvatar(
        //           backgroundColor:
        //               Colors.primaries[Random().nextInt(Colors.primaries.length)],
        //           child: Text(e.name.substring(0, 1)),
        //         ),
        //         const SizedBox(
        //           width: 20,
        //         ),
        //         Text(
        //           e.name,
        //           style:
        //               const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        //         ),
        //         const SizedBox(
        //           width: 20,
        //         ),
        //         const Icon(
        //           Icons.star,
        //           color: Colors.yellow,
        //         ),
        //         Text(e.rating)
        //       ],
        //     ),
        //     const SizedBox(
        //       height: 20,
        //     ),
        //     Text(
        //       e.message,
        //       style: const TextStyle(fontSize: 16),
        //     ),
        //   ],
        // ),
        );
  }
}
