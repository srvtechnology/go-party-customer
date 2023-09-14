import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerapp/core/models/cart.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/providers/cartProvider.dart';
import 'package:customerapp/core/repo/cart.dart';
import 'package:customerapp/core/routes/checkoutPage.dart';
import 'package:customerapp/core/routes/product.dart';
import 'package:customerapp/core/routes/signin.dart';
import 'package:customerapp/core/routes/singleService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
  double total=0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (_)=>CartProvider(context.read<AuthProvider>()),
      child: Consumer2<CartProvider,AuthProvider>(
        builder: (context,cart,auth,child){
          if(auth.authState!= AuthState.LoggedIn){
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
          return GestureDetector(
            onTap: (){
              FocusManager.instance.primaryFocus!.unfocus();
            },
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
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(10),
                        padding:const EdgeInsets.all(20),
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
                        height: 120,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Subtotal: \u20B9 ${cart.totalPrice}",style: const TextStyle(fontSize: 16),),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green
                                    ),
                                    onPressed: ()async{
                                      await _handleQuantityChanged(auth);
                                      if(context.mounted)Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckoutPage(serviceIds: cart.serviceIds,cartItems: cart.data,)));
                                    },
                                    child: Text("Proceed to buy (${cart.data.length} items)"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const DashedDivider(),
                      Column(
                        children: cart.data.map((e) => _cartTile(cart,e,auth)).toList()
                      ),
                    ],
                  ),
                )
            ),
          );
        },
      )
    );
  }
  Future<void> _handleQuantityChanged(AuthProvider auth)async{
      for (String key in changedQuantity.keys){
          await changeCartItemQuantity(auth, changedQuantity[key], key);
      }
  }
  Widget _cartTile(CartProvider state,CartModel item,AuthProvider auth){
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
          ),
          height: 350,
            child: Container(
              height: 200,
              child: Row(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  width: 40.w,
                  margin: const EdgeInsets.all(20),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                        image: NetworkImage(item.service.images.first),
                        fit: BoxFit.fill
                      )
                    ),
                  ),
                ),
                Container(
                  width: 40.w,
                  margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.service.name,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Text(item.service.description.substring(0,min<int>(30, item.service.description.length)),style: const TextStyle(fontSize: 12),),
                      ),
                      Builder(
                        builder: (context) {
                          try{
                            return Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("₹ ${item.service.price}",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 16),),

                                Text("  ${item.service.priceBasis}",style:const TextStyle(fontSize: 12),)
                              ],
                            ),
                          );
                          }catch(e){
                            return Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Text("₹ ${item.service.price}",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 16),),
                            );
                          }
                        }
                      ),
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        margin: const EdgeInsets.only(right: 10,top: 10),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     const Text("Discount Price:",style: TextStyle(fontSize: 12,)),
                            //     FittedBox(child:Text("\u20B9 ${item.service.discountedPrice}",style: TextStyle(color: Theme.of(context).primaryColor)),)
                            //   ],
                            // ),
                            const DashedDivider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Original Price:",style: TextStyle(fontSize: 12,),),
                                FittedBox(child:Text("\u20B9 ${item.service.price}",style: const TextStyle(decoration: TextDecoration.lineThrough),),)
                              ],
                            ),
                            const DashedDivider(),
                            Builder(
                              builder: (context) {
                               try{
                                 return Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     const Text("Unit:",style: TextStyle(fontSize: 12),),
                                     Text(item.service.priceBasis,style: const TextStyle(decoration: TextDecoration.lineThrough),)
                                   ],
                                 );
                               }catch(e){
                                 return Container();
                               }
                              }
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Quantity",style: TextStyle(fontSize: 12),),
                            const SizedBox(width: 20,),
                            Container(
                              width: 50,
                              height: 30,
                              child: TextFormField(
                                keyboardType: const TextInputType.numberWithOptions(signed: false,decimal: false),
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                initialValue: item.quantity,
                                decoration:const InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  enabledBorder: OutlineInputBorder(

                                  ),
                                  border: OutlineInputBorder(

                                  )
                                ),
                                onChanged: (text){
                                  if(text.isNotEmpty){
                                    setState(() {
                                      item.quantity = text;
                                      item.totalPrice=(double.parse(text) * double.parse(item.price)).toString();
                                      changedQuantity[item.id]=text;
                                      state.calculateTotal();
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10,top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Total",style: TextStyle(fontSize: 12),),
                            const SizedBox(width: 20,),
                            FittedBox(child: Text("\u20B9 ${item.totalPrice}",style: const TextStyle(fontSize: 12),)),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child:Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shadowColor: Colors.grey,
                                elevation: 2.5,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                              ),
                              onPressed: ()async{
                                await removeFromCart(context.read<AuthProvider>(), item.id);
                                state.getCart(auth);

                              }, child: const Text("Delete",style: TextStyle(color: Colors.black,fontSize: 12),),),
                            const SizedBox(width: 10,),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                              ),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleServiceRoute(service: item.service,)));
                              }, child: const Text("View",style: TextStyle(fontSize: 12),),)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
          ),
            )
        ),
        const DashedDivider(),
      ],
    );
  }
}


//
// Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.start,
// children: [
// Row(
// children: [
// Expanded(
// child: Container(
// height: 20.h,
// alignment: Alignment.center,
// decoration: BoxDecoration(
// image: DecorationImage(
// image: CachedNetworkImageProvider(
// item.service.images[0],
// ),
// fit: BoxFit.fitWidth,
// )
// ),
// ),
// ),
// ],
// ),
// Text(item.service.name,style: Theme.of(context).textTheme.titleLarge,),
// Text("${item.service.description.substring(0,min(item.service.description.length, 45))} ..",),
// const SizedBox(height: 20,),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [
// Container(
// height: 40,
// width: 80,
// padding: const EdgeInsets.all(10),
// alignment: Alignment.center,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(10),
// color: Colors.grey[300]
// ),
// child: FittedBox(child: Text("₹ ${item.price}")),
// ),
// const Text("X"),
// Container(
// height: 40,
// width: 80,
// padding: const EdgeInsets.all(10),
// alignment: Alignment.center,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(10),
// color: Colors.grey[300]
// ),
// child: TextFormField(
// keyboardType: const TextInputType.numberWithOptions(signed: false,decimal: false),
// textAlign: TextAlign.center,
// textAlignVertical: TextAlignVertical.center,
// initialValue: item.quantity,
// onChanged: (text){
// if(text.isNotEmpty){
// setState(() {
// item.quantity = text;
// item.totalPrice=(double.parse(text) * double.parse(item.price)).toString();
// changedQuantity[item.id]=text;
// });
// }
// },
// decoration: const InputDecoration(
// border: InputBorder.none
// ),
// ),
// ),
// const Text(" = "),
// Container(
// height: 40,
// width: 80,
// padding: const EdgeInsets.all(10),
// alignment: Alignment.center,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(10),
// color: Colors.grey[300]
// ),
// child: FittedBox(child: Text("₹ ${item.totalPrice}")),
// ),
// ],
// ),
// const SizedBox(height: 10,),
// Center(
// child: ElevatedButton(
// onPressed: ()async{
// await removeFromCart(context.read<AuthProvider>(), item.id);
// state.getCategories(auth);
// },child: const Text("Remove"),),
// )
// ],
// ),