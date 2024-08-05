import 'dart:math';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import '../constant/themData.dart';
import 'package:customerapp/core/components/banner.dart';
import 'package:customerapp/core/components/bottomNav.dart';
import 'package:customerapp/core/components/card.dart';
import 'package:customerapp/core/components/commonHeader.dart';
import 'package:customerapp/core/components/currentLocation.dart';
import 'package:customerapp/core/components/loading.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/providers/cartProvider.dart';
import 'package:customerapp/core/providers/orderProvider.dart';
import 'package:customerapp/core/providers/serviceProvider.dart';
import 'package:customerapp/core/routes/cartPage.dart';
import 'package:customerapp/core/routes/eventsPage.dart';
import 'package:customerapp/core/routes/product.dart';
import 'package:customerapp/core/routes/singlePackage.dart';
import 'package:customerapp/core/routes/singleService.dart';
import 'package:customerapp/core/routes/view_all_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../models/orders.dart';

class HomePageScreen extends StatefulWidget {
  static const routeName = "/home";
  final int? index;
  const HomePageScreen({Key? key, this.index}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int currentIndex = 1;
  bool isLoading = false;

  @override
  void initState() {
    // initialize cart provider

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: primaryColor,
        ),
        child: ListenableProvider(
          create: (_) => CartProvider(auth: context.read<AuthProvider>()),
          child: Consumer2<CartProvider, AuthProvider>(
              builder: (context, cart, auth, child) {
            return isLoading || cart.isLoading
                ? Scaffold(
                    body: Container(
                      alignment: Alignment.center,
                      child: const ShimmerWidget(),
                    ),
                  )
                : BottomNav(
                    index: widget.index,
                  );
          }),
        ));
  }
}

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (_) => OrderProvider(context.read<AuthProvider>()),
      child: Consumer<OrderProvider>(builder: (context, state, child) {
        if (state.isLoading) {
          return const ShimmerWidget();
        }
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              // elevation: 1,
              leading: Container(),
              flexibleSpace: SizedBox(
                height: 90,
                child: CommonHeader.headerMain(context,
                    elevation: 0, isShowLogo: false, onSearch: () {
                  Navigator.pushNamed(context, ProductPageRoute.routeName);
                }),
              ),

              bottom: const TabBar(
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.white,
                  tabs: [
                    Tab(
                      icon: Text(
                        "Upcoming",
                      ),
                    ),
                    Tab(
                      icon: Text("Delivered"),
                    ),
                  ]),
            ),
            body: TabBarView(
              children: [
                _upcomingOrders(state.upcomingData, state),
                _deliveredOrders(state.deliveredData, state)
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _upcomingOrders(List<OrderModel> upcomingOrders, OrderProvider state) {
    if (upcomingOrders.isEmpty) {
      return CustomMaterialIndicator(
        indicatorBuilder:
            (BuildContext context, IndicatorController controller) {
          return Container(
              padding: EdgeInsets.all(2.w),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ));
        },
        backgroundColor: primaryColor,
        onRefresh: () {
          return state.refresh();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_business_sharp,
                      size: 100,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Looks like there are no upcoming orders."),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return CustomMaterialIndicator(
      indicatorBuilder: (BuildContext context, IndicatorController controller) {
        return Container(
            padding: EdgeInsets.all(2.w),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ));
      },
      backgroundColor: primaryColor,
      onRefresh: () {
        return state.refresh();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
            children: upcomingOrders.map((e) => OrderTile(order: e)).toList()),
      ),
    );
  }

  Widget _deliveredOrders(
      List<OrderModel> deliveredOrders, OrderProvider state) {
    if (deliveredOrders.isEmpty) {
      return CustomMaterialIndicator(
        indicatorBuilder:
            (BuildContext context, IndicatorController controller) {
          return Container(
              padding: EdgeInsets.all(2.w),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ));
        },
        backgroundColor: primaryColor,
        onRefresh: () {
          return state.refresh();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_business_sharp,
                      size: 100,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Looks like there are no previous orders."),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return CustomMaterialIndicator(
      indicatorBuilder: (BuildContext context, IndicatorController controller) {
        return Container(
            padding: EdgeInsets.all(2.w),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ));
      },
      backgroundColor: primaryColor,
      onRefresh: () {
        return state.refresh();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
            children: deliveredOrders
                .map(
                    (e) => OrderTile(order: e, review: true, isDelivered: true))
                .toList()),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (_) => FilterProvider(),
      child: Consumer<FilterProvider>(builder: (context, filter, child) {
        return ListenableProvider(
          create: (_) => ServiceProvider(filters: filter),
          child: Consumer<ServiceProvider>(builder: (context, state, child) {
            if (state.isLoading) {
              return Scaffold(
                  body: Container(
                      alignment: Alignment.center,
                      child: const ShimmerWidget()));
            }
            if (state.data == null) {
              return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: const Text("Home"),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: Colors.white),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, ProductPageRoute.routeName);
                          },
                          child: Icon(
                            Icons.search,
                            color: Theme.of(context).primaryColorDark,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: Colors.white),
                          onPressed: () {
                            Navigator.pushNamed(context, CartPage.routeName);
                          },
                          child: Icon(
                            Icons.add_shopping_cart,
                            color: Theme.of(context).primaryColorDark,
                          )),
                    ),
                  ],
                ),
                body: Container(
                  alignment: Alignment.center,
                  child: const Text("No services available"),
                ),
              );
            }
            return Scaffold(
              appBar: CommonHeader.headerMain(context, onSearch: () {
                Navigator.pushNamed(context, ProductPageRoute.routeName);
              }),
              body: CustomMaterialIndicator(
                indicatorBuilder:
                    (BuildContext context, IndicatorController controller) {
                  return Container(
                      padding: EdgeInsets.all(2.w),
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ));
                },
                backgroundColor: primaryColor,
                onRefresh: () {
                  return state.refresh();
                },
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CurrentLocationView(),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(width: 0.15, color: Colors.grey),
                        ),
                        padding: contentPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Our Events",
                                  style: headerTextStyle(context),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EventsPage(
                                                        events:
                                                            state.eventData!)));
                                      },
                                      child: Text(
                                        "View All",
                                        style: buttonTextStyle(context),
                                      )),
                                )
                              ],
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: state.eventData!
                                      /*-- Previously commented */
                                      /*.getRange(0, min(4, state.data!.length))*/
                                      .map((e) => GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                ViewAllServiceRoute.routeName,
                                              );
                                            },
                                            child: CircularEventCard(
                                              event: e,
                                            ),
                                          ))
                                      .toList()),
                            )
                          ],
                        ),
                      ),
                      ImageSlider(imageUrls: state.mobileBannerImages),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(width: 0.15, color: Colors.grey),
                        ),
                        padding: contentPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Our Top Services",
                                  style: headerTextStyle(context),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context,
                                            ViewAllServiceRoute.routeName);
                                      },
                                      child: Text(
                                        "View All",
                                        style: buttonTextStyle(context),
                                      )),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: state.data!
                                      /*-- Previously commented */
                                      /*.getRange(0, min(4, state.data!.length))*/
                                      .map((e) => CircularOrderCard(
                                            service: e,
                                          ))
                                      .toList()),
                            )
                          ],
                        ),
                      ),
                      // ImageSlider(imageUrls: state.banner1Images),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(width: 0.15, color: Colors.grey),
                        ),
                        padding: contentPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Packages",
                                  style: headerTextStyle(context),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PackageListPageRoute(
                                                        packages: state
                                                            .packageData!)));
                                      },
                                      child: Text(
                                        "View All",
                                        style: buttonTextStyle(context),
                                      )),
                                )
                              ],
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: state.packageData!
                                      /*-- Previously commented */
                                      /*.getRange(0, min(4, state.packageData!.length))*/
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
                      ImageSlider(imageUrls: state.banner1Images),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(width: 0.15, color: Colors.grey),
                        ),
                        padding: contentPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Trending",
                                  style: headerTextStyle(context),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context,
                                            ViewAllServiceRoute.routeName);
                                      },
                                      child: Text(
                                        "View All",
                                        style: buttonTextStyle(context),
                                      )),
                                )
                              ],
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: state.data!
                                      /*.getRange(4, min(7, state.data!.length))*/
                                      /* .getRange(0, min(7, state.data!.length))*/
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
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(width: 0.15, color: Colors.grey),
                        ),
                        padding: contentPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text("Top Searches of the week",
                                      overflow: TextOverflow.ellipsis,
                                      style: headerTextStyle(context)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context,
                                            ViewAllServiceRoute.routeName);
                                      },
                                      child: Text(
                                        "View All",
                                        style: buttonTextStyle(context),
                                      )),
                                )
                              ],
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: state.data!
                                      /*.getRange(7, min(10, state.data!.length))*/
                                      /* .getRange(0, min(10, state.data!.length))*/
                                      .map((e) => OrderCard(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SingleServiceRoute(
                                                            service: e)));
                                          },
                                          service: e))
                                      .toList()),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
