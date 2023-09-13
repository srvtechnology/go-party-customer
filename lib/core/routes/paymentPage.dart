import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cc_avenue/cc_avenue.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/repo/order.dart';
import 'package:customerapp/core/routes/mainpage.dart';
import 'package:customerapp/core/utils/geolocator.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PaymentPage extends StatefulWidget {
  String addressId;
  PaymentPage({Key? key,required this.addressId}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _paymentModeController = TextEditingController();
  final TextEditingController _paymentTypeController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showCard=true;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Theme.of(context).primaryColorLight,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: const [
                        CircleAvatar(radius: 10,child: Icon(Icons.check,size: 10,),),
                        SizedBox(height: 5,),
                        Text("Cart",style: TextStyle(fontSize: 12),)
                      ],
                    ),
                    Column(
                      children: const [
                        CircleAvatar(radius: 10,child: Icon(Icons.check,size: 10,),),
                        SizedBox(height: 5,),
                        Text("Select Address",style: TextStyle(fontSize: 12),)
                      ],
                    ),
                    Column(
                      children: const [
                        CircleAvatar(radius: 10,child: Icon(Icons.circle,size: 10,),),
                        SizedBox(height: 5,),
                        Text("Payment",style: TextStyle(fontSize: 12),)
                      ],
                    ),
                    Column(
                      children: const [
                        CircleAvatar(radius: 10,backgroundColor: Colors.grey,),
                        SizedBox(height: 5,),
                        Text("Order Placed",style: TextStyle(fontSize: 12),)
                      ],
                    ),

                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 5,),
                        Text("Payment Details",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),)
                      ],
                    ),
                    const SizedBox(height: 20,),
                    CustomDropdown(
                        onChanged: (text){
                          if(text=="Online"){
                            setState(() {
                              showCard=true;
                            });
                          }
                          else{
                            setState(() {
                              showCard=false;
                            });
                          }
                        },
                        hintText: "Select Payment Mode",
                        items: const ["Cash On Delivery","Online"], controller: _paymentModeController),

                    CustomDropdown(
                        hintText: "Select Payment Type",
                        items: const ["Complete","Partial"], controller: _paymentTypeController),
                    const SizedBox(height: 20,),
                    if(showCard)
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 5,),
                                Text("Card Details",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),)
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    validator: (text){
                                      if(text==null || text.isEmpty){
                                        return "Required";
                                      }
                                      if(text.length!=16){
                                        return "Please enter valid Card Number";
                                      }
                                    },
                                    controller: _cardNumberController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(width: 0),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        labelText: "Enter Card Number"
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20,),
                                Expanded(
                                  child: TextFormField(
                                    validator: (text){
                                      if(text==null || text.isEmpty){
                                        return "Required";
                                      }
                                      if(text.length!=3){
                                        return "Please enter valid cvv";
                                      }
                                    },
                                    controller: _cardNumberController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(width: 0),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        labelText: "CVV"
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20,),
                              ],
                            ),
                            const SizedBox(height: 30,),
                          ],
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(child:
                        ElevatedButton(
                          onPressed:(){
                            submit(context.read<AuthProvider>());
                          },
                          child: const Text("Place Order"),
                        ))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> submit(AuthProvider auth)async{
    try{
      Map data=await getCountryCityState();
      await placeOrder(auth, _paymentModeController.text.contains("Cash")?"cod":"online", _paymentTypeController.text.contains("Partial")?"partial":"completed",widget.addressId,data["city"]);
      if(context.mounted){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const MainPageRoute()), (route) => route.isFirst);
      }

    }catch(e){
      CustomLogger.error(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("There was something wrong. Please try again later")));
    }
  }
}


