import 'dart:math';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:customerapp/core/components/card.dart';
import 'package:customerapp/core/components/divider.dart';
import 'package:customerapp/core/models/service.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/providers/categoryProvider.dart';
import 'package:customerapp/core/repo/cart.dart';
import 'package:customerapp/core/routes/product.dart';
import 'package:customerapp/core/routes/signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../components/banner.dart';

class SingleServiceRoute extends StatefulWidget {
  final ServiceModel service;
  const SingleServiceRoute({Key? key,required this.service}) : super(key: key);

  @override
  State<SingleServiceRoute> createState() => _SingleServiceRouteState();
}

class _SingleServiceRouteState extends State<SingleServiceRoute> {
  final TextEditingController _categoryName = TextEditingController();
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  final TextEditingController _days = TextEditingController();
  final TextEditingController _duration = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void _calculateDays(){
    _days.text = DateTime.parse(_endDate.text).difference(DateTime.parse(_startDate.text)).inDays.toString();
  }
  @override
  void initState() {
    super.initState();
    _startDate.addListener(_calculateDays);
    _endDate.addListener(_calculateDays);
  }
  TextFormField datePickField(TextEditingController controller,String hintText){
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 0.5,color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
          enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 0.5,color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(10),
        )
      ),
      validator: (text){
        if(text==null || text.isEmpty){
          return "Required";
        }
      },
      readOnly: true,
      onTap: ()async{
        DateTime? date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(3000));
        if (date!=null){
          controller.text=date.toString().substring(0,10);
        }
      },
    );
  }
  void addToCartDialog(BuildContext context,CategoryProvider categories){
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
        context: context, builder: (context){
      return Container(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(30),
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  CustomDropdown.search(
                    borderSide: BorderSide(width: 0.5,color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(10),
                    hintText: "Select Occasion",
                    controller: _categoryName,
                    items: categories.data.map((e) => e.name).toList(),
                  ),
                  const SizedBox(height: 20,),
                  datePickField(_startDate,"Select Start Date"),
                  const SizedBox(height: 20),
                  datePickField(_endDate,"Select End Date"),
                  const SizedBox(height: 20,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _quantity,
                    validator: (text){
                      if(text==null || text.isEmpty){
                        return "Required";
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.5,color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.5,color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(10),
                        )
                        ,hintText: "Select Quantity"
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    controller: _days,
                    validator: (text){
                      if(text==null || text.isEmpty){
                        return "Required";
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.5,color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.5,color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Select Days"
                    ),
                  ),
                  const SizedBox(height: 20,),
                  CustomDropdown(
                      borderSide: BorderSide(width: 0.5,color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(10),
                      items: const ["Full Day","Morning","Night"], controller: _duration),
                  const SizedBox(height: 20,),
                  ElevatedButton(onPressed: ()async{
                  if(_formKey.currentState!.validate()){
                    String categoryId = categories.data.firstWhere((element) => element.name == _categoryName.text).id.toString();
                    Map data = {
                      "service_id":widget.service.id,
                      "cart_category":categoryId,
                      "date":_startDate.text,
                      "end_date":_endDate.text,
                      "quantity":_quantity.text,
                      "days":_days.text,
                      "time":_duration.text.substring(0,1)
                    };
                    await addtoCart(context.read<AuthProvider>(), data);
                   if(context.mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully added to cart")));
                    if(context.mounted)Navigator.pop(context);
                  }
                }, child: const Text("Proceed")),
                  const SizedBox(height: 40,),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>CategoryProvider(),),
      ],
      child: Consumer2<CategoryProvider,AuthProvider>(
        builder: (context,categories,auth,child) {

          return Scaffold(
            appBar: AppBar(
              elevation: 1,
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.grey),
              centerTitle: false,
              title: Image.asset("assets/images/logo/logo-resized.png",width: 120,),
              actions: [
                Container(
                  width: 200,
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
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: (){
                    if(auth.authState == AuthState.LoggedIn) {
                      addToCartDialog(context,categories);
                    }
                    else {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignInPageRoute(comeBack: true,)))
                          .then((value) => addToCartDialog(context,categories));
                    }
                  },
                  child: const Text("Add to Cart"),
                ),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            body: Container(
              constraints: BoxConstraints(
                minHeight: 500.h
              ),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    ImageSlider(imageUrls: widget.service.images),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(widget.service.name,style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w600),),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.star,color: Colors.orange,),
                          const SizedBox(width: 10,),
                          Text(widget.service.rating??"Not Rated",style: const TextStyle(fontWeight: FontWeight.w600),),
                          const SizedBox(width: 10,),
                          Text("( ${widget.service.reviews.length} rating${widget.service.reviews.length>1?"s":""} )",style: const TextStyle(fontSize: 12),),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(widget.service.description,style: Theme.of(context).textTheme.bodyMedium,),
                    ),

                    const Divider(thickness: 1,),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "\u20B9 ${widget.service.discountedPrice}  ",
                                  style: TextStyle(fontSize: 20.sp,color: Theme.of(context).primaryColorDark),
                                  children: [
                                    TextSpan(
                                      text: "${widget.service.priceBasis} inc. tax",
                                      style: TextStyle(fontSize: 15.sp,color: Colors.black),
                                    ),
                                  ]
                              ),
                            ]
                        ),),
                    ),
                    const Divider(thickness: 1,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100]
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Pricing Info",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                          const SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Discount Price:",style: TextStyle(fontSize: 16),),
                              Text("\u20B9 ${widget.service.discountedPrice}")
                            ],
                          ),
                          const DashedDivider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Original Price:",style: TextStyle(fontSize: 16),),
                              Text("\u20B9 ${widget.service.price}",style: const TextStyle(decoration: TextDecoration.lineThrough),)
                            ],
                          ),
                          const DashedDivider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Unit:",style: TextStyle(fontSize: 16),),
                              Text(widget.service.priceBasis,)
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1,),
                    const SizedBox(height: 10,),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Text("Reviews",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),)),
                    const SizedBox(height: 10,),
                    const Divider(thickness: 1,),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: widget.service.reviews.getRange(0, min(4,widget.service.reviews.length)).map((e) => ReviewTile(e: e)).toList(),
                        )
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(side: BorderSide(color: Theme.of(context).primaryColorDark)),
                          onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ReviewPage(reviews: widget.service.reviews)));
                      }, child: Text("View All Reviews",style: TextStyle(fontSize: 18,color: Theme.of(context).primaryColorDark),)),
                    ),
                    const SizedBox(height: 100,),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}


class ReviewPage extends StatefulWidget {
  final List<ReviewModel> reviews;
  const ReviewPage({Key? key, required this.reviews}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reviews"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: widget.reviews.map((e) => ReviewTile(e: e)).toList(),
          ),
        ),
      ),
    );
  }
}
