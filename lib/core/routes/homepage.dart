import 'dart:math';
import 'package:customerapp/core/Constant/themData.dart';
import 'package:customerapp/core/components/banner.dart';
import 'package:customerapp/core/components/bottomNav.dart';
import 'package:customerapp/core/components/card.dart';
import 'package:customerapp/core/components/commonHeader.dart';
import 'package:customerapp/core/components/currentLocatton.dart';
import 'package:customerapp/core/components/loading.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/providers/orderProvider.dart';
import 'package:customerapp/core/providers/serviceProvider.dart';
import 'package:customerapp/core/routes/cart.dart';
import 'package:customerapp/core/routes/eventsPage.dart';
import 'package:customerapp/core/routes/product.dart';
import 'package:customerapp/core/routes/singlePackage.dart';
import 'package:customerapp/core/routes/singleService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../models/orders.dart';

class HomePageScreen extends StatefulWidget {
  static const routeName = "/home";
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int currentIndex = 1;
  bool isLoading = false;
  // List<Widget> items = [
  //   const Orders(),
  //   const Home(),
  //   const CartPage(),
  //   Profile(
  //     onTabChange: (int v) {
  //       setState(() {
  //         currentIndex = v;
  //       });
  //     },
  //   )
  // ];
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: primaryColor,
      ),
      child: Consumer<AuthProvider>(builder: (context, state, child) {
        return isLoading
            ? Scaffold(
                body: Container(
                  alignment: Alignment.center,
                  child: const ShimmerWidget(),
                ),
              )
            : const BottomNav();
      }),
    );
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
                _upcomingOrders(state.upcomingData),
                _deliveredOrders(state.deliveredData)
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _upcomingOrders(List<OrderModel> upcomingOrders) {
    if (upcomingOrders.isEmpty) {
      return Container(
        alignment: Alignment.center,
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
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
          children: upcomingOrders.map((e) => OrderTile(order: e)).toList()),
    );
  }

  Widget _deliveredOrders(List<OrderModel> deliveredOrders) {
    if (deliveredOrders.isEmpty) {
      return Container(
        alignment: Alignment.center,
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
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
          children: deliveredOrders
              .map((e) => OrderTile(order: e, review: true, isDelivered: true))
              .toList()),
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
              // appBar: PreferredSize(
              //   preferredSize: Size(MediaQuery.of(context).size.width, 60),
              //   child: Material(
              //     elevation: 0.8,
              //     child: Container(
              //       margin: EdgeInsets.only(
              //           top: MediaQuery.of(context).padding.top),
              //       padding: const EdgeInsets.symmetric(horizontal: 5),
              //       child: Row(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           Image.asset("assets/images/logo/logo-new.png",
              //               width: 140),
              //           Expanded(
              //               child: Container(
              //             // margin: const EdgeInsets.only(right: 10),
              //             padding: const EdgeInsets.symmetric(
              //                 horizontal: 5, vertical: 10),
              //             child: GestureDetector(
              //               onTap: () {
              //                 Navigator.pushNamed(
              //                     context, ProductPageRoute.routeName);
              //               },
              //               child: TextFormField(
              //                 enabled: false,
              //                 decoration: InputDecoration(
              //                     filled: true,
              //                     fillColor: const Color(0xffe5e5e5),
              //                     labelText: "Search ...",
              //                     prefixIcon: const Icon(Icons.search),
              //                     border: OutlineInputBorder(
              //                       borderRadius: BorderRadius.circular(10),
              //                     )),
              //               ),
              //             ),
              //           )),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              body: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CurrentLocationView(),
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: const BoxDecoration(
                        color: tertiaryColor,
                      ),
                      padding: EdgeInsets.only(
                          left: 5.w, top: 2.h, bottom: 2.h, right: 2.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Our Events",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(fontSize: 20, color: textColor),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EventsPage(
                                                events: state.eventData!)));
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
                            height: 1.h,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: state.eventData!
                                    // .getRange(0, min(4, state.data!.length))
                                    .map((e) => GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                ProductPageRoute.routeName);
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
                      alignment: Alignment.centerLeft,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.only(
                          top: 2.h, bottom: 2.h, left: 5.w, right: 2.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  "Our Top Services",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(fontSize: 20, color: textColor),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, ProductPageRoute.routeName);
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => EventsPage(
                                    //             events: state.eventData!)));
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
                            height: 1.h,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: state.data!
                                    // .getRange(0, min(4, state.data!.length))
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
                      padding: EdgeInsets.only(
                          top: 2.h, bottom: 2.h, left: 5.w, right: 2.w),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Packages",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(fontSize: 20, color: textColor),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PackageListPageRoute(
                                                    packages:
                                                        state.packageData!)));
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
                    ImageSlider(imageUrls: state.banner1Images),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                          top: 2.h, bottom: 2.h, left: 5.w, right: 2.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Trending",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(fontSize: 20, color: textColor),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, ProductPageRoute.routeName);
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
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                          top: 2.h, bottom: 2.h, left: 5.w, right: 2.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text("Top Searches of the week",
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                            fontSize: 20, color: textColor)),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, ProductPageRoute.routeName);
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: state.data!
                                    .getRange(7, min(10, state.data!.length))
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
            );
          }),
        );
      }),
    );
  }
}
