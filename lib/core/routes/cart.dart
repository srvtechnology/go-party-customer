import 'dart:math';

import 'package:customerapp/core/components/currentLocatton.dart';
import 'package:customerapp/core/routes/checkoutPage.dart';
import 'package:customerapp/core/routes/view_all_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:customerapp/core/Constant/themData.dart';
import 'package:customerapp/core/components/card.dart';
import 'package:customerapp/core/components/commonHeader.dart';
import 'package:customerapp/core/components/htmlTextView.dart';
import 'package:customerapp/core/models/cart.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/providers/cartProvider.dart';
import 'package:customerapp/core/providers/serviceProvider.dart';
import 'package:customerapp/core/repo/cart.dart';
import 'package:customerapp/core/routes/product.dart';
import 'package:customerapp/core/routes/signin.dart';
import 'package:customerapp/core/routes/singlePackage.dart';
import 'package:customerapp/core/routes/singleService.dart';

import '../components/divider.dart';
import '../components/loading.dart';

class CartPage extends StatefulWidget {
  static const String routeName = '/cart';

  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class CartItem {
  String name;
  String category;
  double price;
  int quantity;

  CartItem({
    required this.name,
    required this.category,
    required this.price,
    required this.quantity,
  });
}

class _CartPageState extends State<CartPage> {
  Map changedQuantity = {};
  double total = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString(), name: "INR");
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
          statusBarColor: primaryColor,
          statusBarIconBrightness: Brightness.light),
      child: ListenableProvider(
          create: (_) => CartProvider(context.read<AuthProvider>()),
          child: Consumer2<CartProvider, AuthProvider>(
            builder: (context, cart, auth, child) {
              if (auth.authState != AuthState.LoggedIn) {
                return Scaffold(
                    appBar: CommonHeader.headerMain(context, isShowLogo: false,
                        onSearch: () {
                      Navigator.pushNamed(context, ProductPageRoute.routeName);
                    }),
                    body: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(50),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.shopping_cart,
                              size: 100,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text("Please log in to view your cart."),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, SignInPageRoute.routeName);
                                },
                                child: const Text("Sign in"))
                          ],
                        )));
              }
              if (cart.isLoading) {
                return Scaffold(
                    body: Container(
                        alignment: Alignment.center,
                        child: const ShimmerWidget()));
              }
              if (cart.data.isEmpty) {
                return Scaffold(
                    appBar: CommonHeader.headerMain(context, isShowLogo: false,
                        onSearch: () {
                      Navigator.pushNamed(context, ProductPageRoute.routeName);
                    }),
                    body: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(50),
                        child: Column(
                          children: const [
                            Icon(
                              Icons.shopping_cart,
                              size: 100,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Cart is currently empty."),
                          ],
                        )));
              }
              return GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus!.unfocus();
                },
                child: Scaffold(
                    appBar: CommonHeader.headerMain(context, isShowLogo: false,
                        onSearch: () {
                      Navigator.pushNamed(context, ProductPageRoute.routeName);
                    }),
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          const CurrentLocationView(),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 2.h),
                            height: 22.h,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Subtotal: ${formatCurrency.format(cart.totalPrice)}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: primaryColor,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 1.w,
                                    ),
                                    Expanded(
                                      child: RichText(
                                          text: TextSpan(
                                              text:
                                                  "Your order is eligible for FREE Delivery.",
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 16.sp),
                                              children: [
                                            TextSpan(
                                                text:
                                                    " Select this option at checkout. Details",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: textColor,
                                                ))
                                          ])),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 6.h,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: primaryColor),
                                          onPressed: () async {
                                            print(cart.data.first.quantity);
                                            await _handleQuantityChanged(auth);
                                            if (context.mounted) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CheckoutPage(
                                                            serviceIds:
                                                                cart.serviceIds,
                                                            cartItems:
                                                                cart.data,
                                                            cartSubToatal:
                                                                cart.totalPrice,
                                                          )));
                                            }
                                          },
                                          child: Text(
                                            "Proceed to Book (${cart.data.length} items)",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const DashedDivider(),
                          Column(
                              children: cart.data
                                  .map((e) => _cartTile(cart, e, auth))
                                  .toList()),
                          const ExtraDetails(),
                        ],
                      ),
                    )),
              );
            },
          )),
    );
  }

  Future<void> _handleQuantityChanged(AuthProvider auth) async {
    for (String key in changedQuantity.keys) {
      await changeCartItemQuantity(auth, changedQuantity[key], key);
    }
  }

  Widget _cartTile(CartProvider state, CartModel item, AuthProvider auth) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SingleServiceRoute(service: item.service)));
      },
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(minHeight: 20.h, maxHeight: 56.h),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  width: 40.w,
                  margin: EdgeInsets.only(right: 4.w, left: 4.w),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image: NetworkImage(item.service.images.first),
                            fit: BoxFit.fill)),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.service.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      // Container(
                      //   margin: const EdgeInsets.only(right: 10),
                      //   child: Text(
                      //     item.service.description.substring(
                      //         0, min<int>(30, item.service.description.length)),
                      //     style: const TextStyle(fontSize: 12),
                      //   ),
                      // ),
                      Container(
                          constraints: BoxConstraints(
                              minHeight: 1.h,
                              maxHeight: 10.h,
                              minWidth: double.infinity,
                              maxWidth: double.infinity),
                          alignment: Alignment.centerLeft,
                          child:
                              HtmlTextView(htmlText: item.service.description)),
                      Builder(builder: (context) {
                        try {
                          return Container(
                            margin: EdgeInsets.only(top: 1.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "₹ ${item.service.price}",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "  ${item.service.priceBasis}",
                                  style: const TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          );
                        } catch (e) {
                          return Container(
                            margin: EdgeInsets.only(top: 1.h),
                            child: Text(
                              "₹ ${item.service.price}",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          );
                        }
                      }),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 1.w),
                        margin: EdgeInsets.only(right: 4.w, top: 1.h),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Discount Price:",
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                                FittedBox(
                                  child: Text(
                                      "\u20B9 ${item.service.discountedPrice}",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w600)),
                                )
                              ],
                            ),
                            // const DashedDivider(),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     const Text(
                            //       "Original Price:",
                            //       style: TextStyle(
                            //         fontSize: 12,
                            //       ),
                            //     ),
                            //     FittedBox(
                            //       child: Text(
                            //         "\u20B9 ${item.service.price}",
                            //         style: const TextStyle(
                            //             decoration: TextDecoration.lineThrough,
                            //             fontWeight: FontWeight.bold,
                            //             color: primaryColor),
                            //       ),
                            //     )
                            //   ],
                            // ),
                            // const DashedDivider(),
                            // Builder(builder: (context) {
                            //   try {
                            //     return Row(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         const Text(
                            //           "Unit:",
                            //           style: TextStyle(fontSize: 12),
                            //         ),
                            //         Text(
                            //           item.service.priceBasis,
                            //           style: const TextStyle(
                            //               fontWeight: FontWeight.bold,
                            //               color: primaryColor),
                            //         )
                            //       ],
                            //     );
                            //   } catch (e) {
                            //     return Container();
                            //   }
                            // }),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 4.w, top: 1.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Quantity",
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 50,
                              height: 30,
                              child: TextFormField(
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        signed: false, decimal: false),
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                initialValue: item.quantity,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(0),
                                    enabledBorder: OutlineInputBorder(),
                                    border: OutlineInputBorder()),
                                onChanged: (text) {
                                  if (text.isNotEmpty) {
                                    setState(() {
                                      item.quantity = text;
                                      item.totalPrice = (double.parse(text) *
                                              double.parse(item.price))
                                          .toString();
                                      changedQuantity[item.id] = text;
                                      state.calculateTotal();
                                    });
                                    _handleQuantityChanged(auth);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 4.w, top: 1.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Total",
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            FittedBox(
                                child: Text(
                              "\u20B9 ${item.totalPrice}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            )),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 2.h, right: 4.w),
                        child: Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shadowColor: Colors.grey,
                                  elevation: 2.5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () async {
                                await removeFromCart(
                                    context.read<AuthProvider>(), item.id);
                                state.getCart(auth);
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SingleServiceRoute(
                                                service: item.service,
                                              )));
                                },
                                child: const Text(
                                  "See More",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const DashedDivider(),
        ],
      ),
    );
  }
}

class ExtraDetails extends StatelessWidget {
  final Color? color;
  const ExtraDetails({
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (_) => FilterProvider(),
      child: Consumer<FilterProvider>(builder: (context, filter, child) {
        return ListenableProvider(
          create: (_) => ServiceProvider(filters: filter),
          child: Consumer<ServiceProvider>(
            builder: (context, state, child) {
              if (state.isLoading) {
                // progress indicator
                return Container(
                  height: 10.h,
                  alignment: Alignment.center,
                  child: SizedBox(
                      height: 3.h,
                      width: 3.h,
                      child: const CircularProgressIndicator(
                        color: primaryColor,
                        strokeWidth: 2,
                      )),
                );
              }
              if (state.data == null) {
                return Container();
              }
              return Container(
                color: color ?? tertiaryColor,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                          top: 2.h, bottom: 2.h, left: 5.w, right: 2.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Browse Similar Packages",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                            fontSize: 20, color: textColor),
                                  ),
                                  Text(
                                    "our most popular packages",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                            fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              TextButton(
                                  onPressed: () {
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PackageListPageRoute(
                                                packages: state.packageData!));
                                  },
                                  child: Text(
                                    "View All",
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontSize: 15),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: state.packageData!
                                    .getRange(
                                        0, min(4, state.packageData!.length))
                                    .map((e) => PackageCard(
                                          package: e,
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SinglePackageRoute(
                                                          package: e,
                                                        )));
                                          },
                                        ))
                                    .toList()),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                          top: 2.h, bottom: 2.h, left: 5.w, right: 2.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Browse Similar Services",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                            fontSize: 20, color: textColor),
                                  ),
                                  Text(
                                    "our most popular services",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                            fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, ViewAllServiceRoute.routeName);
                                  },
                                  child: Text(
                                    "View All",
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontSize: 15),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: state.data!
                                    .getRange(4, min(7, state.data!.length))
                                    .map((e) => OrderCard(
                                          service: e,
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SingleServiceRoute(
                                                            service: e)));
                                          },
                                        ))
                                    .toList()),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
