import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerapp/core/routes/singleService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../models/service.dart';

typedef OnTap  = void Function();

class OrderCard extends StatelessWidget {
  ServiceModel service;
  OnTap? onTap;
  OrderCard({Key? key,required this.service,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        height: 35.h,
        width: 50.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 9,child:
            Hero(
              tag: "Product Image ${service.id}",
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(1,1),
                        spreadRadius: 2,
                        blurRadius: 2,
                        color: Colors.grey[400]!
                    ),
                  ],
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.fitHeight,
                    image: CachedNetworkImageProvider(service.image,)
                  )
                ),
              ),
            )),
            const SizedBox(height: 20,),
            Expanded(child: Text(service.name,style: const TextStyle(fontWeight: FontWeight.bold),)),
            FittedBox(child: Text("${service.description.substring(0,min(26,service.description.length))} ...",overflow: TextOverflow.visible,textAlign: TextAlign.left,)),
            const SizedBox(height: 20,),
            Expanded(child: Text("₹ ${service.price}",style: const TextStyle(fontWeight: FontWeight.bold)),),
          ],
        ),
      ),
    );
  }
}

class CircularOrderCard extends StatelessWidget {
  final ServiceModel service;
  const CircularOrderCard({Key? key,required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleServiceRoute(service: service)));
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              decoration:BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 2,
                      color: Colors.grey[400]!,
                       spreadRadius: 1)],
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: CachedNetworkImageProvider(service.image),
              ),
            ),
            const SizedBox(height: 10,),
            Text(service.name)
          ],
        ),
      ),
    );
  }
}

class OrderTile extends StatelessWidget {
  String service,vendor,date,price;
  OrderTile({Key? key,required this.service,required this.vendor,required this.price,required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(1,1),
            blurRadius: 1,
            color: Colors.grey[300]!
          ),
          BoxShadow(
            offset: const Offset(-1,-1),
            blurRadius: 1,
            color: Colors.grey[300]!
          )
        ],
        borderRadius: BorderRadius.circular(10)
      ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 6,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage(
                        "assets/images/signup5bg.jpg"
                    )
                )
            ),
          )
          ),
          const SizedBox(
            height: 5,
          ),
          const SizedBox(height: 10,),
          Expanded(child:Text(service,style: Theme.of(context).textTheme.labelMedium,)),
          Expanded(child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date),
              Text("₹ $price",style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),)
            ],
          )),
          Expanded(child:Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: (){},
                  child: const Text("View"),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
class ProductTile extends StatelessWidget {
  ServiceModel service;
  Function? onTap;
  ProductTile({Key? key,required this.service,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(1,1),
            blurRadius: 1,
            color: Colors.grey[300]!
          ),
          BoxShadow(
            offset: const Offset(-1,-1),
            blurRadius: 1,
            color: Colors.grey[300]!
          )
        ],
        borderRadius: BorderRadius.circular(10)
      ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 6,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: CachedNetworkImageProvider(service.image)
                )
            ),
          )
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(service.name,style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).primaryColor),),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          Expanded(child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(child: Text("${service.description.substring(0,min(20,service.description.length))} ...",)),
              Text("₹ ${service.price}",style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),)
            ],
          )),
          const SizedBox(height: 20,),
          Expanded(child:Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: (){
                    if(onTap!=null){
                      onTap!();
                    }
                  },
                  child: const Text("View"),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

