import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerapp/core/models/service.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SingleServiceRoute extends StatefulWidget {
  ServiceModel service;
  SingleServiceRoute({Key? key,required this.service}) : super(key: key);

  @override
  State<SingleServiceRoute> createState() => _SingleServiceRouteState();
}

class _SingleServiceRouteState extends State<SingleServiceRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
        onPressed: (){},
        child: const Text("Book Now !"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 25.h,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      child: Hero(
                        tag: "Product Image ${widget.service.id}",
                        child: CachedNetworkImage(
                          fit: BoxFit.fitWidth,
                          imageUrl: widget.service.image,
                          placeholder: (context,url)=>Container(alignment: Alignment.center,child: const CircularProgressIndicator(),),
                         errorWidget: (context,url,err)=>Container(alignment: Alignment.center,child: const Icon(Icons.error_outline),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
                child: Text(widget.service.name,style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w600),),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                alignment: Alignment.centerLeft,
                child: Text(widget.service.description,style: Theme.of(context).textTheme.bodyMedium,),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                alignment: Alignment.centerLeft,
                child: Text("Price Info",style: Theme.of(context).textTheme.titleLarge,),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                alignment: Alignment.centerLeft,
                child: Text("\u20B9 ${widget.service.price} ${widget.service.priceBasis}",style: Theme.of(context).textTheme.bodyMedium,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
