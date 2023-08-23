import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerapp/core/models/service.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/providers/categoryProvider.dart';
import 'package:customerapp/core/repo/cart.dart';
import 'package:customerapp/core/routes/signin.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SingleServiceRoute extends StatefulWidget {
  final ServiceModel service;
  SingleServiceRoute({Key? key,required this.service}) : super(key: key);

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
        border: const OutlineInputBorder()
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
    showDialog(context: context, builder: (context){
      return Dialog(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(30),
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  CustomDropdown.search(
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
                    decoration: const InputDecoration(
                      border:OutlineInputBorder(),
                      hintText: "Select Quantity"
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
                    decoration: const InputDecoration(
                      border:OutlineInputBorder(),
                      hintText: "Select Days"
                    ),
                  ),
                  const SizedBox(height: 20,),
                  CustomDropdown(items: const ["Full Day","Morning","Night"], controller: _duration),
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
                }, child: const Text("Proceed"))
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
    return ListenableProvider(
      create: (_)=>CategoryProvider(),
      child: Consumer2<CategoryProvider,AuthProvider>(
        builder: (context,categories,auth,child) {
          return Scaffold(
            appBar: AppBar(),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
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
                  children: [
                    Container(
                      height: 25.h,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Expanded(
                            child: Hero(
                              tag: "Product Image ${widget.service.id}",
                              child: SingleChildScrollView(
                                physics: const ClampingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  children:widget.service.images.map((e)
                                  => Container(
                                    height: 25.h,
                                    margin:const EdgeInsets.symmetric(horizontal: 20),
                                    alignment: Alignment.center,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.fitWidth,
                                      imageUrl: e,
                                      placeholder: (context,url)=>Container(alignment: Alignment.center,child: const CircularProgressIndicator(),),
                                      errorWidget: (context,url,err)=>Container(alignment: Alignment.center,child: const Icon(Icons.error_outline),),
                                    ),
                                  )).toList()
                                ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      alignment: Alignment.centerLeft,
                      child: Text("Discounted Price",style: Theme.of(context).textTheme.titleLarge,),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                      alignment: Alignment.centerLeft,
                      child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "\u20B9 ${widget.service.discountedPrice}  ",
                              style: TextStyle(fontSize: 20.sp,color: Colors.redAccent),
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                      alignment: Alignment.centerLeft,
                      child: Text("\u20B9 ${widget.service.price}",style: Theme.of(context).textTheme.bodyMedium!.copyWith(decoration: TextDecoration.lineThrough),),
                    ),
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
