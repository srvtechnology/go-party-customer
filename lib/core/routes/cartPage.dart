import 'dart:math';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:customerapp/core/components/currentLocation.dart';
import 'package:customerapp/core/components/cutom_card.dart';
import 'package:customerapp/core/models/package.dart';
import 'package:customerapp/core/models/service.dart';
import 'package:customerapp/core/routes/checkoutPage.dart';
import 'package:customerapp/core/routes/view_all_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constant/themData.dart';
import 'package:customerapp/core/components/card.dart';
import 'package:customerapp/core/components/commonHeader.dart';
import 'package:customerapp/core/models/cartModel.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/providers/cartProvider.dart';
import 'package:customerapp/core/providers/serviceProvider.dart';
import 'package:customerapp/core/repo/cartRepo.dart';
import 'package:customerapp/core/routes/product.dart';
import 'package:customerapp/core/routes/signin.dart';
import 'package:customerapp/core/routes/singlePackage.dart';
import 'package:customerapp/core/routes/singleService.dart';

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
          create: (_) => CartProvider(auth: context.read<AuthProvider>()),
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
                    body: CustomMaterialIndicator(
                      indicatorBuilder: (BuildContext context,
                          IndicatorController controller) {
                        return Container(
                            padding: EdgeInsets.all(2.w),
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ));
                      },
                      backgroundColor: primaryColor,
                      onRefresh: () {
                        return cart.refresh();
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.9,
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
                                )),
                          ],
                        ),
                      ),
                    ));
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
                    body: CustomMaterialIndicator(
                      indicatorBuilder: (BuildContext context,
                          IndicatorController controller) {
                        return Container(
                            padding: EdgeInsets.all(2.w),
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ));
                      },
                      backgroundColor: primaryColor,
                      onRefresh: () {
                        return cart.refresh();
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const CurrentLocationView(),
                            CustomCard(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
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
                                              await _handleQuantityChanged(
                                                  auth);
                                              if (context.mounted) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CheckoutPage(
                                                              serviceIds: cart
                                                                  .serviceIds,
                                                              cartItems:
                                                                  cart.data,
                                                              cartSubTotal: cart
                                                                  .totalPrice,
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
                            Column(
                                children: cart.data
                                    .map((e) => _cartTile(cart, e, auth))
                                    .toList()),
                            const ExtraDetails(),
                          ],
                        ),
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
    return CustomCard(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(item.service.images.first),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.service.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 1.w),
                  margin: EdgeInsets.only(right: 4.w, top: 1.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Price",
                        style: TextStyle(fontSize: 15),
                      ),
                      FittedBox(
                        child: Text(
                          "\u20B9 ${item.service.discountedPrice}",
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 1.w),
                  margin: EdgeInsets.only(right: 4.w, top: 1.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Package",
                        style: TextStyle(fontSize: 15),
                      ),
                      FittedBox(
                        child: Text(
                          item.category.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
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
                        "Days",
                        style: TextStyle(fontSize: 15),
                      ),
                      FittedBox(
                        child: Text(
                          item.days,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                /*--- commented on 03-09-24 : to fix the quantity & price issue ----*/
                /* Container(
                  margin: EdgeInsets.only(right: 4.w, top: 1.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Quantity",
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(
                        width: 50,
                        height: 30,
                        child: TextFormField(
                          keyboardType:
                              const TextInputType.numberWithOptions(
                            signed: false,
                            decimal: false,
                          ),
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          initialValue: item.quantity,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(0),
                            enabledBorder: OutlineInputBorder(),
                            border: OutlineInputBorder(),
                          ),
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
                ),*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Quantity",
                      style: TextStyle(fontSize: 14),
                    ),
                    // Wrapping the right Row with Expanded to prevent overflow
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Minus Button
                          IconButton(
                            icon: const Icon(Icons.remove),
                            padding: EdgeInsets.zero,
                            // Remove padding around the icon
                            constraints: const BoxConstraints(),
                            // Remove constraints
                            onPressed: () {
                              setState(() {
                                int currentQuantity =
                                    int.tryParse(item.quantity) ?? 1;
                                if (currentQuantity > 1) {
                                  currentQuantity -= 1;
                                  item.quantity =
                                      currentQuantity.toString();
                                  item.totalPrice = (currentQuantity *
                                      double.parse(item.days) * double.parse(item.price))
                                      .toString();
                                  changedQuantity[item.id] = item.quantity;
                                  state.calculateTotal();
                                  _handleQuantityChanged(auth);
                                }
                              });
                            },
                          ),
                          // Quantity Display
                          Container(
                            width: 40,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.quantity,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          // Plus Button
                          IconButton(
                            icon: const Icon(Icons.add),
                            padding: EdgeInsets.zero,
                            // Remove padding around the icon
                            constraints: const BoxConstraints(),
                            // Remove constraints
                            onPressed: () {
                              setState(() {
                                int currentQuantity =
                                    int.tryParse(item.quantity) ?? 1;
                                currentQuantity += 1;
                                item.quantity = currentQuantity.toString();
                                item.totalPrice = (currentQuantity *
                                        double.parse(item.days) * double.parse(item.price))
                                    .toString();
                                changedQuantity[item.id] = item.quantity;
                                state.calculateTotal();
                                _handleQuantityChanged(auth);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(right: 4.w, top: 1.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(fontSize: 15),
                      ),
                      FittedBox(
                        child: Text(
                          "\u20B9 ${item.totalPrice}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 1.h, right: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shadowColor: Colors.grey,
                          elevation: 2.5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          await removeFromCart(
                            context.read<AuthProvider>(),
                            item.id,
                          );
                          state.getCart(auth);
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 8,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (item.service is ServiceModel) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingleServiceRoute(
                                    service: item.service),
                              ),
                            );
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SinglePackageRoute(
                                          package: item.service,
                                        )));
                          }
                        },
                        child: const Text(
                          "See More",
                          style: TextStyle(fontSize: 8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*--- commented on : 29-07-24 to fix the design of the cart CardTile ----*/
/*Widget _cartTile(CartProvider state, CartModel item, AuthProvider auth) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SingleServiceRoute(service: item.service)));
      },
      child: CustomCard(
        padding: EdgeInsets.symmetric(vertical: 2.h),
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
                        /*  Builder(builder: (context) {
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
                        }), */
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 1.w),
                          margin: EdgeInsets.only(right: 4.w, top: 1.h),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Price :",
                                      style: TextStyle(
                                        fontSize: 15,
                                      )),
                                  FittedBox(
                                    child: Text(
                                        "\u20B9 ${item.service
                                            .discountedPrice}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                            Theme
                                                .of(context)
                                                .primaryColor,
                                            fontWeight: FontWeight.w600)),
                                  )
                                ],
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
                                "Quantity",
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              Expanded(
                                child: SizedBox(
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
                                          item.totalPrice =
                                              (double.parse(text) *
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
                                style: TextStyle(fontSize: 15),
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
                                        borderRadius:
                                        BorderRadius.circular(10))),
                                onPressed: () async {
                                  await removeFromCart(
                                      context.read<AuthProvider>(), item.id);
                                  state.getCart(auth);
                                },
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 8),
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
                                    style: TextStyle(fontSize: 8),
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
          ],
        ),
      ),
    );
  }*/

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
              return Column(
                children: [
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, right: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Browse Similar Packages",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(
                                              fontSize: 14, color: textColor),
                                    ),
                                  ],
                                ),
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
                                        fontSize: 12),
                                  ))
                            ],
                          ),
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
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, right: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Browse Similar Services",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(
                                              fontSize: 14, color: textColor),
                                    ),
                                  ],
                                ),
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
                                        fontSize: 12),
                                  ))
                            ],
                          ),
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
              );
            },
          ),
        );
      }),
    );
  }
}
