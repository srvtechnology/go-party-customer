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
import 'package:customerapp/core/routes/product.dart';
import 'package:customerapp/core/routes/profile.dart';
import 'package:customerapp/core/routes/signin.dart';
import 'package:customerapp/core/routes/singleService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../models/orders.dart';
import 'addressPage.dart';

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
          children: deliveredOrders.map((e) => OrderTile(order:e)).toList()
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
  final CarouselController _carouselController = CarouselController();
  int _currentCarouselIndex = 0;
  @override
  void initState() {
    super.initState();
  }
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
                                    Navigator.pushNamed(context, ProductPageRoute.routeName);}, child: Text("View All",style: TextStyle(color: Theme.of(context).primaryColorDark,fontSize: 15),))
                                ],
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
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),

                          child: Stack(
                            children: [
                              CarouselSlider(
                                carouselController: _carouselController,
                                options: CarouselOptions(
                                  onPageChanged: (index,kwargs){
                                    setState(() {
                                      _currentCarouselIndex = index;
                                    });
                                  },
                                  enableInfiniteScroll: true,
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 3),
                                  autoPlayAnimationDuration:const Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeFactor: 0,
                                  viewportFraction: 1
                                ),
                                items: [
                                  "https://mobirise.com/extensions/commercem4/assets/images/gallery00.jpg",
                                  "https://mobirise.com/extensions/commercem4/assets/images/gallery04.jpg",
                                  "https://mobirise.com/extensions/commercem4/assets/images/gallery07.jpg"
                                ].map((e) => Container(
                                  width: double.infinity,
                                  child: Image.network(e,fit: BoxFit.fitWidth,),
                                )).toList(),
                              ),
                              Positioned.fill(
                                top: 180,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:[0,1,2].map((e) => Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 10),

                                      height: 8,width: 8,decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black,width: 0.5),
                                        shape: BoxShape.circle,color:_currentCarouselIndex==e?Theme.of(context).primaryColorDark:Colors.white),
                                    )).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          decoration: const BoxDecoration(
                            color: Colors.white,

                          ),
                          padding: const EdgeInsets.only(top: 10),
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

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context,state,child) {
        if(state.authState != AuthState.LoggedIn){
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
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: const Center(
                    child: CircleAvatar(
                      radius: 50.0,
                      child: Icon(Icons.person),
                    ),
                  ),
                ),
                const Text("Please Sign in to view"),
                SizedBox(height: 5.h,),
                ElevatedButton(onPressed: (){
                    Navigator.pushNamed(context, SignInPageRoute.routeName);
                }, child: const Text("Sign in / Sign up"))
              ],
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
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: const Center(
                    child: CircleAvatar(
                      radius: 50.0,
                      child: Icon(Icons.person),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person_2_outlined),
                  title: const Text('Edit Profile'),
                  onTap: () {
                    Navigator.pushNamed(context, EditProfilePage.routeName);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Manage Addresses'),
                  onTap: () {
                    Navigator.pushNamed(context, AddressPage.routeName);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.feedback),
                  title: const Text('Feedback'),
                  onTap: () {
                    Navigator.pushNamed(context, FeedbackPage.routeName);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.contact_phone),
                  title: const Text('Contact'),
                  onTap: () {
                    // Handle "Contact" option tap
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    state.logout();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
