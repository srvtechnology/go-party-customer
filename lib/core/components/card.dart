import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerapp/core/models/user.dart';
import 'package:customerapp/core/routes/singleService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../models/orders.dart';
import '../models/service.dart';
import '../providers/AuthProvider.dart';
import '../repo/services.dart';
import '../utils/logger.dart';

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
        height: 30.h,
        width: 50.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 4,child:
            Hero(
              tag: "Product Image ${service.id}",
              child: Container(
                height: 20.h,
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
                    image: CachedNetworkImageProvider(service.images[0],)
                  )
                ),
              ),
            )),
            const SizedBox(height: 10,),
            Expanded(child: Row(
              children: [
                Text(service.name,style: const TextStyle(fontSize: 18),),

              ],
            )),
            FittedBox(child: Text("${service.description.substring(0,min(26,service.description.length))} ...",overflow: TextOverflow.visible,textAlign: TextAlign.left,)),
            const SizedBox(height: 20,),
            Expanded(child: Text("₹ ${service.discountedPrice}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Theme.of(context).primaryColorDark)),),
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
                backgroundImage: CachedNetworkImageProvider(service.images[0]),
              ),
            ),
            const SizedBox(height: 10,),
            Text(service.name,style: const TextStyle(fontWeight: FontWeight.w600),)
          ],
        ),
      ),
    );
  }
}


class CircularEventCard extends StatelessWidget {
  final EventModel event;
  const CircularEventCard({Key? key,required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              backgroundImage: CachedNetworkImageProvider(event.image),
            ),
          ),
          const SizedBox(height: 10,),
          Text(event.name,style: const TextStyle(fontWeight: FontWeight.w600),)
        ],
      ),
    );
  }
}

class OrderTile extends StatefulWidget {
  OrderModel order;
  bool review;
  OrderTile({Key? key,required this.order,this.review=false}) : super(key: key);

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  final TextEditingController _reviewMessage = TextEditingController();
  double rating=0.0;
  Future<void> _writeReview()async {
    showModalBottomSheet(context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
        builder: (context){
          return StatefulBuilder(
              builder: (context,setState) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  height: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Rate the service",style: TextStyle(fontSize: 20),),
                      const SizedBox(height: 20,),
                      Center(
                        child: PannableRatingBar(
                          rate: rating,
                          items: List.generate(5, (index) =>
                          const RatingWidget(
                            selectedColor: Colors.yellow,
                            unSelectedColor: Colors.grey,
                            child: Icon(
                              Icons.star,
                              size: 30,
                            ),
                          )),
                          onChanged: (value) { // the rating value is updated on tap or drag.
                            setState(() {
                              rating = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          controller: _reviewMessage,
                          maxLines: 4,
                          minLines: 3,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              labelText: "Write a review ..."
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          child: const Text("Submit Review"),
                          onPressed: ()async{
                            try{
                              await writeReview(context.read<AuthProvider>(), widget.order.id, rating.toString(), _reviewMessage.text);
                              if(context.mounted)
                              {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Review Successfully Added")));
                                Navigator.pop(context);
                              }
                            }catch(e){
                              CustomLogger.error(e);
                              if(context.mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Some Error Occured. Please try again later")));
                            }
                          },
                        ),
                      )
                    ],
                  ),
                );
              }
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.h,
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
          Container(
            height: 20.h,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: CachedNetworkImageProvider(widget.order.service.images[0])
            )
            ),
          ),
          const SizedBox(height: 5,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Text(
                  widget.order.service.name,
                  style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600),),
              ),
              const SizedBox(height: 10,),
              Text(
                widget.order.category.name,
                style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),),
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd MMM yy').format(DateTime.parse(widget.order.eventDate)),
              ),
              Container(width: 40,alignment: Alignment.center,child: const Text("to"),),
              Text(
                DateFormat('dd MMM yy').format(DateTime.parse(widget.order.eventEndDate)),
              ),
            ],
          )
            ],
          ),
          const SizedBox(height: 5,),
          Text("${widget.order.houseNumber}, ${widget.order.landmark}, ${widget.order.area}, ${widget.order.state}"),
          const SizedBox(height: 5,),
          Container(
            padding: const EdgeInsets.all(5),
            child: Text("₹ ${widget.order.totalPrice}",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontWeight: FontWeight.w500),),
          ),
          if(widget.review)
          Center(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                onPressed: (){
                  _writeReview();
                }, child: const Text("Write a Review")),
          )
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
      height: 42.h,
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
                    image: CachedNetworkImageProvider(service.images[0])
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
          FittedBox(child: Text("${service.description.substring(0,min(42,service.description.length))} ...",style: const TextStyle(fontSize: 14),)),
          const SizedBox(height: 20,),
          Expanded(child: Text("₹ ${service.price}",style: TextStyle(fontSize: 24,color: Theme.of(context).primaryColor),)),
          const SizedBox(height: 10,),
          Expanded(child:Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColorDark),
                  onPressed: (){
                    if(onTap!=null){
                      onTap!();
                    }
                  },
                  child: const Text("View Details"),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

class ReviewTile extends StatelessWidget {
  final ReviewModel e;
  const ReviewTile({Key? key,required this.e}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                child: Text(e.name.substring(0,1)),
              ),
              const SizedBox(width: 20,),
              Text(e.name,style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
              const SizedBox(width: 20,),
              const Icon(Icons.star,color: Colors.yellow,),
              Text(e.rating)
            ],
          ),
          const SizedBox(height: 20,),
          Text(e.message,style: const TextStyle(fontSize: 16),),
        ],
      ),
    );
  }
}
