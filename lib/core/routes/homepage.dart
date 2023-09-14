import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:customerapp/core/components/banner.dart';
import 'package:customerapp/core/components/card.dart';
import 'package:customerapp/core/components/loading.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/providers/orderProvider.dart';
import 'package:customerapp/core/providers/serviceProvider.dart';
import 'package:customerapp/core/routes/cart.dart';
import 'package:customerapp/core/routes/eventsPage.dart';
import 'package:customerapp/core/routes/product.dart';
import 'package:customerapp/core/routes/profile.dart';
import 'package:customerapp/core/routes/singleService.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/orders.dart';

class HomePageScreen extends StatefulWidget {
  static const routeName = "/home";
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int currentIndex = 1;
  List<Widget> items = const [Orders(),Home(),CartPage(),Profile()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: items[currentIndex],
      bottomNavigationBar: ConvexAppBar(
        height: 40,
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },
        initialActiveIndex: currentIndex,
        backgroundColor: Colors.white,
        color: Theme.of(context).primaryColorDark,
        activeColor: Theme.of(context).primaryColorDark,
        items: const [
          TabItem(icon: Icons.shopping_bag),
          TabItem(icon: Icons.home),
          TabItem(icon: Icons.shopping_cart),
          TabItem(icon: Icons.person),
        ],
      )
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
      create: (_)=>OrderProvider(context.read<AuthProvider>()),
      child: Consumer<OrderProvider>(
        builder: (context,state,child) {
          if(state.isLoading){
            return const ShimmerWidget();
          }
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                elevation: 1,
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                centerTitle: false,
                title: Image.asset("assets/images/logo/logo-resized.png",width: 120,),
                actions: [
                  Container(
                    width: 250,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(5),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, ProductPageRoute.routeName);
                      },
                      child: TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xffe5e5e5),
                            labelText: "Search ...",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )
                        ),
                      ),
                    ),
                  )
                ],
                bottom:  TabBar(
                    labelColor: Theme.of(context).primaryColorDark,
                    tabs:const [
                  Tab(icon: Text("Upcoming",),),
                  Tab(icon: Text("Delivered"),),
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
        }
      ),
    );
  }
  Widget _upcomingOrders(List<OrderModel> upcomingOrders){
    if(upcomingOrders.isEmpty){
      return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_business_sharp,size: 100,color: Theme.of(context).primaryColorDark,),
            const SizedBox(height: 20,),
            const Text("Looks like there are no upcoming orders."),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
          children:upcomingOrders.map((e) => OrderTile(order:e)).toList()
      ),
    );
  }
  Widget _deliveredOrders(List<OrderModel> deliveredOrders){
    if(deliveredOrders.isEmpty){
      return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_business_sharp,size: 100,color: Theme.of(context).primaryColorDark,),
            const SizedBox(height: 20,),
            const Text("Looks like there are no previous orders."),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
          children: deliveredOrders.map((e) => OrderTile(order:e,review:true)).toList()
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (_)=>FilterProvider(),
      child: Consumer<FilterProvider>(
        builder: (context,filter,child) {
          return ListenableProvider(
            create: (_)=>ServiceProvider(filters: filter),
            child: Consumer<ServiceProvider>(
              builder: (context,state,child) {
                if(state.isLoading){
                  return Scaffold(
                    body: Container(
                      alignment: Alignment.center,
                      child:const ShimmerWidget())
                  );
               }
                if(state.data==null){
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
                                  backgroundColor: Colors.white
                              ),
                              onPressed: (){
                                Navigator.pushNamed(context, ProductPageRoute.routeName);
                              }, child: Icon(Icons.search,color:Theme.of(context).primaryColorDark,)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  backgroundColor: Colors.white
                              ),
                              onPressed: (){
                                Navigator.pushNamed(context, CartPage.routeName);

                              }, child: Icon(Icons.add_shopping_cart,color:Theme.of(context).primaryColorDark,)),
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
                  appBar: AppBar(
                    elevation: 1,
                    backgroundColor: Colors.white,
                    automaticallyImplyLeading: false,
                    centerTitle: false,
                    title: Image.asset("assets/images/logo/logo-resized.png",width: 120,),
                    actions: [
                      Container(
                        width: 250,
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.all(5),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, ProductPageRoute.routeName);
                          },
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xffe5e5e5),
                              labelText: "Search ...",
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  body: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Container(
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              color: const Color(0xffE9EFF5),
                              boxShadow: [
                                BoxShadow(
                                    offset:const Offset(0,1),
                                    spreadRadius: 3,
                                    blurRadius: 6,
                                    color: Colors.grey[300]!
                                )
                              ]
                          ),
                          padding: const EdgeInsets.only(top: 10),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                    child: Text("Our Events",style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 20),),
                                  ),
                                  TextButton(onPressed: (){
                                    Navigator.push(context,MaterialPageRoute(builder: (context)=>EventsPage(events: state.eventData!)));
                                    }, child: Text("View All",style: TextStyle(color: Theme.of(context).primaryColorDark,fontSize: 15),))
                                ],
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children: state.eventData!.getRange(0, min(4,state.data!.length)).map((e) => CircularEventCard(event: e,)).toList()
                                ),
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
                          padding: const EdgeInsets.only(top: 10,bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                child: Text("Top Services",style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 20),),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: state.data!.getRange(0, min(4,state.data!.length)).map((e) => CircularOrderCard(service: e,)).toList()
                                ),
                              )
                            ],
                          ),
                        ),
                        ImageSlider(imageUrls: state.banner1Images),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Packages",style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 20),),
                                    TextButton(onPressed: (){
                                      Navigator.pushNamed(context, ProductPageRoute.routeName);
                                    }, child: Text("View All",style: TextStyle(color: Theme.of(context).primaryColorDark,fontSize: 15),))
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: state.data!.getRange(4, min(7,state.data!.length)).map((e) => OrderCard(service: e,
                                    onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleServiceRoute(service: e)));
                                  },
                                  )).toList()
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Trending",style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 20),),
                                    TextButton(onPressed: (){
                                      Navigator.pushNamed(context, ProductPageRoute.routeName);
                                    }, child: Text("View All",style: TextStyle(color: Theme.of(context).primaryColorDark,fontSize: 15),))
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: state.data!.getRange(4, min(7,state.data!.length)).map((e) => OrderCard(service: e,
                                    onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleServiceRoute(service: e)));
                                  },
                                  )).toList()
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                    child: Text("Top Searches of the week",style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 20)),
                                  ),
                                  TextButton(onPressed: (){
                                    Navigator.pushNamed(context, ProductPageRoute.routeName);
                                  }, child: Text("View All",style: TextStyle(color: Theme.of(context).primaryColorDark,fontSize: 15),))
                                ],
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children: state.data!.getRange(7, min(10,state.data!.length)).map((e) => OrderCard(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleServiceRoute(service: e)));
                                        },
                                        service: e)).toList()
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              }
            ),
          );
        }
      ),
    );
  }
}

