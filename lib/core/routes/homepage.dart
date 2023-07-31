import 'dart:math';
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
  List<Widget> items = const [Orders(),Home(),Profile()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: items[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          setState(() {
            currentIndex = index ;
          });
        },
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag),label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profile"),
        ],
      ),
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
                title: const Text("Orders"),
                automaticallyImplyLeading: false,
                centerTitle: true,
                actions: [
                  IconButton(onPressed: (){}, icon: const Icon(Icons.add_shopping_cart)),
                ],
                bottom: const TabBar(tabs: [
                  Tab(icon: Text("Upcoming"),),
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
                  body: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        const EcommerceBanner(imageUrl: "https://images.unsplash.com/photo-1492684223066-81342ee5ff30?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2940&q=80",
                            title: "Discover the experience",
                            subtitle: "Shop the latest trends"),
                        Container(
                          alignment: Alignment.centerLeft,
                          color: Colors.grey[300],
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child: Text("Our top services",style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w700),),
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
                                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child: Text("Trending",style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w700),),
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
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                  side: const BorderSide(width: 1,color: Colors.blue),
                                  shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            )
                                          ),
                                          onPressed: (){
                                            Navigator.pushNamed(context, ProductPageRoute.routeName);
                                          }, child:const Text("View all")),
                                    ),
                                  ],
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
                                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child: Text("Top Searches of the week",style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w700)),
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
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                              side: const BorderSide(width: 1,color: Colors.blue),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              )
                                          ),
                                          onPressed: (){
                                            Navigator.pushNamed(context, ProductPageRoute.routeName);
                                          }, child:const Text("View all")),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        // Container(
                        //   alignment: Alignment.centerLeft,
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Padding(
                        //         padding: const EdgeInsets.all(20.0),
                        //         child: Text("Top Categories",style: Theme.of(context).textTheme.labelLarge,),
                        //       ),
                        //       SingleChildScrollView(
                        //         scrollDirection: Axis.horizontal,
                        //         child: Row(
                        //           children: [
                        //             OrderCard(service: "Catering", imageUrl:"",price:"1499"),
                        //             OrderCard(service: "Catering", imageUrl:"",price:"1499"),
                        //             OrderCard(service: "More", imageUrl:"",price:"1499"),
                        //           ],
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
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
              title: const Text("Profile"),
              centerTitle: true,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(onPressed: (){
                  Navigator.pushNamed(context, ProductPageRoute.routeName);
                }, icon: const Icon(Icons.search)),
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
            title: const Text("Profile"),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(onPressed: (){
                Navigator.pushNamed(context, ProductPageRoute.routeName);
              }, icon: const Icon(Icons.search)),
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
