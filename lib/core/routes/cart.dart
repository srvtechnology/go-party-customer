import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerapp/core/models/cart.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/providers/cartProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../components/loading.dart';

class CartPage extends StatefulWidget {
  static const String routeName = '/cart';

  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
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
      child: Consumer<CartProvider>(
        builder: (context,cart,child){
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
                        Text("Cart is currently empty.")
                      ],
                    ))
            );
          }
          return Scaffold(
              appBar: AppBar(
                title: const Text('Cart'),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text("Service",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),)),
                        Expanded(child: Text("Quantity",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),)),
                        Expanded(child: Text("Total",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),)),
                      ],
                    ),
                    Column(
                      children: cart.data.map((e) => CartTile(e)).toList()
                    ),
                  ],
                ),
              )
          );
        },
      )
    );
  }
  Widget CartTile(CartModel item){
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10),
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
      height: 13.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: CachedNetworkImage(
                        imageUrl: item.service.image,
                        width: 80,
                        height: 150,
                      ),
                    )
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item.service.name,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16.sp),),
                      Text(item.category.name),

                    ],
                  )
                ],
              ),),
          Expanded(child: Container(
            alignment: Alignment.center,
            child:Row(
              children: [
                Expanded(child: IconButton(onPressed: (){
                  setState(() {
                    item.quantity=(double.parse(item.quantity)-1).toString();
                  });
                }, icon: const Icon(Icons.remove))),
                Expanded(child: TextFormField(
                  style: TextStyle(fontSize: 14.sp),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.sp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    )
                  ),
                  initialValue: item.quantity,
                  onChanged: (text){
                    setState(() {
                      item.quantity = text;
                    });
                  },
                ),
                ),
                Expanded(child: IconButton(onPressed: (){
                setState(() {
                  item.quantity=(double.parse(item.quantity)+1).toString();
                });
                  }, icon: const Icon(Icons.add))),
              ],
            )
          ),),
          Expanded(child: Container(
            alignment: Alignment.center,
            child: Text(item.totalPrice),)),
        ],
      ),
    );
  }
}
