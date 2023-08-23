import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerapp/core/models/cart.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/providers/cartProvider.dart';
import 'package:customerapp/core/repo/cart.dart';
import 'package:customerapp/core/routes/checkoutPage.dart';
import 'package:customerapp/core/routes/signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (_)=>CartProvider(context.read<AuthProvider>()),
      child: Consumer2<CartProvider,AuthProvider>(
        builder: (context,cart,auth,child){
          if(auth.authState!= AuthState.LoggedIn){
            return Scaffold(
                appBar: AppBar(),
                body: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(50),
                    child:Column(
                      children:[
                        const Icon(Icons.shopping_cart,size: 100,),
                        const SizedBox(height: 20,),
                        const Text("Please log in to view your cart."),
                        ElevatedButton(onPressed: (){
                          Navigator.pushNamed(context, SignInPageRoute.routeName);
                        }, child: const Text("Sign in"))
                      ],
                    ))
            );
          }
          if(cart.isLoading){
            return Scaffold(
                body: Container(
                    alignment: Alignment.center,
                    child:const ShimmerWidget())
            );
          }
          if(cart.data.isEmpty){
            return Scaffold(
              appBar: AppBar(),
                body: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(50),
                    child:Column(
                      children:const [
                         Icon(Icons.shopping_cart,size: 100,),
                         SizedBox(height: 20,),
                         Text("Cart is currently empty."),
                      ],
                    ))
            );
          }
          return Scaffold(
              appBar: AppBar(
                title: const Text('Cart'),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent
                  ),
                  onPressed: (){
                    Navigator.pushNamed(context, CheckoutPage.routeName);
                  },
                  child: const Text("Checkout"),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    Column(
                      children: cart.data.map((e) => _cartTile(cart,e,auth)).toList()
                    ),
                  ],
                ),
              )
          );
        },
      )
    );
  }
  Widget _cartTile(CartProvider state,CartModel item,AuthProvider auth){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset:  const Offset(1, 1),
              spreadRadius: 1,
              color: Colors.grey[300]!
            ),
            BoxShadow(
              offset: const Offset(-1, -1),
              spreadRadius: 1,
                color: Colors.grey[300]!
            ),
          ]
      ),
      height: 40.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 20.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        item.service.images[0],
                      ),
                      fit: BoxFit.fitWidth,
                    )
                  ),
                ),
              ),
            ],
          ),
          Text(item.service.name,style: Theme.of(context).textTheme.titleLarge,),
          Text("${item.service.description.substring(0,min(item.service.description.length, 45))} ..",),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 40,
                width: 80,
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300]
                ),
                child: FittedBox(child: Text("₹ ${item.price}")),
              ),
              const Text("X"),
              Container(
                height: 40,
                width: 80,
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300]
                ),
                child: Text(item.quantity),
              ),
              const Text(" = "),
              Container(
                height: 40,
                width: 80,
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300]
                ),
                child: FittedBox(child: Text("₹ ${item.totalPrice}")),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Center(
            child: ElevatedButton(
              onPressed: ()async{
                await removeFromCart(context.read<AuthProvider>(), item.id);
                state.getCategories(auth);
            },child: const Text("Remove"),),
          )
        ],
      ),
    );
  }
}
