import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

typedef OnTap  = void Function();

class OrderCard extends StatelessWidget {
  String service,category,price,imageUrl;
  OnTap? onTap;
  OrderCard({Key? key,required this.service,required this.category,required this.price,required this.imageUrl,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(20),
        height: 30.h,
        width: 50.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 9,child:
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    fit: BoxFit.fitHeight,
                  image: AssetImage(
                    "assets/images/signup5bg.jpg"
                  )
                )
              ),
            )),
            const SizedBox(height: 20,),
            Expanded(child: Text(service,style: const TextStyle(fontWeight: FontWeight.bold),)),
            Expanded(child: Text(category)),
            Expanded(child: Text("₹ $price",style: const TextStyle(fontWeight: FontWeight.bold)),),
          ],
        ),
      ),
    );
  }
}

class CircularOrderCard extends StatelessWidget {
  String service,category,imageUrl;
  CircularOrderCard({Key? key,required this.service,required this.category,required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage("assets/images/signup3bg.jpg"),
          ),
          Text(service)
        ],
      ),
    );
  }
}

class OrderTile extends StatelessWidget {
  String category,service,vendor,date,price;
  OrderTile({Key? key,required this.category,required this.service,required this.vendor,required this.price,required this.date}) : super(key: key);

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
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(category,style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).primaryColor),),
                Text(vendor,),
              ],
            ),
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
  String category,service,vendor,price;
  ProductTile({Key? key,required this.category,required this.service,required this.vendor,required this.price,}) : super(key: key);

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
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(category,style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).primaryColor),),
                Text(vendor,),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          Expanded(child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(service,style: Theme.of(context).textTheme.labelMedium,),
              Text("₹ $price",style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),)
            ],
          )),
          const SizedBox(height: 20,),
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

